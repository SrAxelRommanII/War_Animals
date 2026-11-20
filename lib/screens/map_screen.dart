import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../core/connection_service.dart';
import '../widgets/kitsune_offline_dialog.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _loadingGPS = true;
  String _statusMessage = 'Sincronizando satélite GPS y buscando señal...';

  // Control de conexión en tiempo real
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<Position>? _positionSub;
  bool _isOnline = true;
  bool _isOfflineDialogOpen = false;

  // Nodos y Cajas simulados en los alrededores
  List<Marker> _tacticalMarkers = [];

  @override
  void initState() {
    super.initState();
    _initConnectionMonitoring();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _connectionSub?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }

  // Monitoreo de conexión a internet para el modo exploración en línea
  Future<void> _initConnectionMonitoring() async {
    final initialStatus = await ConnectionService.hasConnection();
    if (!mounted) return;

    setState(() => _isOnline = initialStatus);
    if (!initialStatus) {
      _triggerOfflineAlert();
    }

    _connectionSub = ConnectionService.connectionStream.listen((online) {
      if (!mounted) return;
      setState(() => _isOnline = online);

      if (!online) {
        _triggerOfflineAlert();
      }
    });
  }

  Future<void> _triggerOfflineAlert() async {
    if (_isOfflineDialogOpen || !mounted) return;
    _isOfflineDialogOpen = true;

    await KitsuneOfflineDialog.show(
      context,
      kitsuneAssetPath: 'assets/kitsune.png', // Ajusta al nombre exacto de tu imagen en assets/
      onSwitchToOfflineMode: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );

    _isOfflineDialogOpen = false;
    final onlineNow = await ConnectionService.hasConnection();
    if (mounted) {
      setState(() => _isOnline = onlineNow);
    }
  }

  // Permisos y obtención de coordenadas GPS
  Future<void> _initLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _statusMessage = 'Por favor activa el GPS de tu dispositivo.';
        _loadingGPS = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _statusMessage = 'Permiso de ubicación denegado.';
          _loadingGPS = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _statusMessage = 'Permisos de ubicación denegados permanentemente.';
        _loadingGPS = false;
      });
      return;
    }

    // Obtener primera posición conocida/actual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;
    _updatePlayerPosition(LatLng(position.latitude, position.longitude));

    // Escuchar cambios de movimiento GPS en tiempo real
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 3, // Actualiza cada 3 metros recorridos
      ),
    ).listen((Position updatedPosition) {
      if (mounted) {
        _updatePlayerPosition(
            LatLng(updatedPosition.latitude, updatedPosition.longitude));
      }
    });
  }

  void _updatePlayerPosition(LatLng newPos) {
    setState(() {
      _currentPosition = newPos;
      _loadingGPS = false;
      _statusMessage =
          '¡Bienvenido Operador! Explora el mapa para localizar nodos de ADN y cajas de suministros.';
      _generateNearbyPOI(newPos);
    });

    _mapController.move(newPos, 17.5);
  }

  // Genera puntos de interés (Nodos ADN / Cajas de suministros) dinámicos en un radio cercano
  void _generateNearbyPOI(LatLng center) {
    _tacticalMarkers = [
      // Marcador del Jugador (Comandante)
      Marker(
        point: center,
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.3),
            border: Border.all(color: Colors.greenAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 3,
              )
            ],
          ),
          child: const Icon(Icons.navigation, color: Colors.greenAccent, size: 32),
        ),
      ),

      // Nodo ADN 1 (Norte)
      Marker(
        point: LatLng(center.latitude + 0.0012, center.longitude + 0.0008),
        width: 45,
        height: 45,
        child: GestureDetector(
          onTap: () => _onPoiTapped('Nodo de ADN Mutante', '+50 ADN'),
          child: const CircleAvatar(
            backgroundColor: Colors.purpleAccent,
            child: Icon(Icons.science, color: Colors.white, size: 22),
          ),
        ),
      ),

      // Caja de Suministros 1 (Suroeste)
      Marker(
        point: LatLng(center.latitude - 0.0009, center.longitude - 0.0011),
        width: 45,
        height: 45,
        child: GestureDetector(
          onTap: () =>
              _onPoiTapped('Caja Táctica de Suministros', '+100 Monedas y Botiquín'),
          child: const CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.inventory_2, color: Colors.black, size: 22),
          ),
        ),
      ),
    ];
  }

  void _onPoiTapped(String title, String reward) {
    // Si no hay conexión al intentar interactuar con un nodo en línea, avisar con Kitsune
    if (!_isOnline) {
      _triggerOfflineAlert();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Recompensa disponible: $reward',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Suministros recolectados: $reward!')),
                  );
                },
                child: const Text(
                  'RECOLECTAR RECURSOS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recibir el nombre del comandante desde el navegador
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String commanderName = args?['commanderName'] ?? 'Recluta_Alpha';

    return Scaffold(
      backgroundColor: const Color(0xFF0D180D),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. CAPA DEL MAPA REAL
            _loadingGPS
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.greenAccent),
                        const SizedBox(height: 16),
                        const Icon(Icons.map, color: Colors.greenAccent, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Cargando capa de Realidad Solapada...',
                          style: TextStyle(
                              color: Colors.greenAccent.shade200, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentPosition ?? const LatLng(0, 0),
                      initialZoom: 17.5,
                      minZoom: 10.0,
                      maxZoom: 19.0,
                    ),
                    children: [
                      TileLayer(
                        // Estilo de mapa oscuro/militar (CartoDB Dark Matter)
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.waranimals.game',
                      ),
                      MarkerLayer(markers: _tacticalMarkers),
                    ],
                  ),

            // 2. HEADER SUPERIOR TÁCTICO
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFF1B381B).withOpacity(0.95),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Operador: $commanderName (Nvl. 5)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Indicador dinámico de red (tocarlo también permite probar la alerta de Kitsune)
                    Tooltip(
                      message: _isOnline
                          ? 'Enlace Satelital Activo (Tocar para probar aviso)'
                          : 'Sin conexión',
                      child: InkWell(
                        onTap: _triggerOfflineAlert,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            _isOnline ? Icons.wifi : Icons.wifi_off,
                            color: _isOnline
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. BARRA INFERIOR / RADAR HUD
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B381B).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.greenAccent.shade400, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pets, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. BOTÓN RECENTRAR GPS
            if (!_loadingGPS)
              Positioned(
                right: 20,
                bottom: 85,
                child: FloatingActionButton.small(
                  backgroundColor: const Color(0xFF1B381B),
                  foregroundColor: Colors.greenAccent,
                  onPressed: () {
                    if (_currentPosition != null) {
                      _mapController.move(_currentPosition!, 17.5);
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
          ],
        ),
      ),
    );
  }
}