import 'dart:math' as math;
import 'package:flutter/material.dart';

class CityPointOfInterest {
  final String id;
  final String name;
  final String type;
  final String chapter;
  final Offset worldPos; // Coordenadas dentro de la ciudad (2400 x 2400)
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final String targetRoute;

  const CityPointOfInterest({
    required this.id,
    required this.name,
    required this.type,
    required this.chapter,
    required this.worldPos,
    required this.icon,
    required this.color,
    this.isUnlocked = true,
    this.targetRoute = '/home',
  });
}

class StoryMapScreen extends StatefulWidget {
  const StoryMapScreen({super.key});

  @override
  State<StoryMapScreen> createState() => _StoryMapScreenState();
}

class _StoryMapScreenState extends State<StoryMapScreen>
    with SingleTickerProviderStateMixin {
  // Posición actual del jugador/cámara en las calles de la ciudad
  Offset _playerWorldPos = const Offset(750, 1500);
  late AnimationController _pulseController;

  // Edificios, bases y puntos de interés dentro de la ciudad offline
  final List<CityPointOfInterest> _pois = const [
    CityPointOfInterest(
      id: 'hq_ambar',
      name: 'Cuartel Refugio Ámbar',
      type: 'BASE ALIADA // ARMERÍA',
      chapter: 'CAPÍTULO 01',
      worldPos: Offset(750, 1280),
      icon: Icons.shield,
      color: Color(0xFF2ECC71),
      isUnlocked: true,
      targetRoute: '/avatar_customization',
    ),
    CityPointOfInterest(
      id: 'barracones_k9',
      name: 'Centro de Entrenamiento K9',
      type: 'ESTRUCTURA // ESCUADRÓN',
      chapter: 'CAPÍTULO 01',
      worldPos: Offset(1250, 1500),
      icon: Icons.pets,
      color: Color(0xFF3498DB),
      isUnlocked: true,
      targetRoute: '/starter_selection',
    ),
    CityPointOfInterest(
      id: 'plaza_control',
      name: 'Avenida de Control Norte',
      type: 'ZONA DE COMBATE',
      chapter: 'CAPÍTULO 02',
      worldPos: Offset(750, 750),
      icon: Icons.local_fire_department,
      color: Colors.amber,
      isUnlocked: true,
      targetRoute: '/battle',
    ),
    CityPointOfInterest(
      id: 'torre_alfa',
      name: 'Ciudadela Central Alfa',
      type: 'FORTALEZA // JEFE',
      chapter: 'CAPÍTULO 03',
      worldPos: Offset(1500, 750),
      icon: Icons.castle,
      color: Color(0xFF9B59B6),
      isUnlocked: false,
      targetRoute: '/battle',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Permite caminar arrastrando el dedo por la pantalla
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      final nextX = (_playerWorldPos.dx - details.delta.dx * 1.6)
          .clamp(150.0, 2250.0);
      final nextY = (_playerWorldPos.dy - details.delta.dy * 1.6)
          .clamp(150.0, 2250.0);
      _playerWorldPos = Offset(nextX, nextY);
    });
  }

  void _openPoiSheet(CityPointOfInterest poi) {
    // Mueve el escuadrón cerca de la estructura seleccionada
    setState(() {
      _playerWorldPos = Offset(poi.worldPos.dx, poi.worldPos.dy + 140);
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141622),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: poi.color, width: 1.5),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${poi.chapter} // ${poi.type}',
              style: TextStyle(
                color: poi.color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              poi.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      poi.isUnlocked ? Colors.amber.shade600 : Colors.white12,
                  foregroundColor:
                      poi.isUnlocked ? Colors.black : Colors.white38,
                ),
                onPressed: poi.isUnlocked
                    ? () {
                        Navigator.pop(context);
                        if (poi.targetRoute != '/battle') {
                          Navigator.pushNamed(context, poi.targetRoute);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF161622),
                              content: Text(
                                'Desplegando escuadrón en ${poi.name}...',
                                style: const TextStyle(color: Colors.amber),
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                icon: Icon(poi.isUnlocked ? Icons.login : Icons.lock, size: 18),
                label: Text(
                  poi.isUnlocked
                      ? 'ENTRAR A LA ESTRUCTURA'
                      : 'BLOQUEADO // COMPLETA CAPÍTULO ANTERIOR',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E17),
      body: GestureDetector(
        onPanUpdate: _onPanUpdate,
        child: Stack(
          children: [
            // 1. LIENZO DE CIUDAD 2.5D INCLINADA (ESTILO POKÉMON GO)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ProceduralCity25DPainter(
                      cameraCenter: _playerWorldPos,
                      pois: _pois,
                      pulseValue: _pulseController.value,
                    ),
                  );
                },
              ),
            ),

            // 2. NEBLINA ATMOSFÉRICA EN EL HORIZONTE SUPERIOR
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 190,
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0B0E17),
                        Color(0xD90B0E17),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. BARRA SUPERIOR TÁCTICA Y ACCESO RÁPIDO A ESTRUCTURAS
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF161622),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 20),
                            onPressed: () =>
                                Navigator.pushReplacementNamed(context, '/home'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161622).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.amber.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'CIUDAD TÁCTICA // MODO HISTORIA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Text(
                                  '${_playerWorldPos.dx.toInt()}, ${_playerWorldPos.dy.toInt()}',
                                  style: TextStyle(
                                    color: Colors.amber.shade500,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botones horizontales para interactuar con las estructuras cercanas
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      scrollDirection: Axis.horizontal,
                      itemCount: _pois.length,
                      itemBuilder: (context, index) {
                        final poi = _pois[index];
                        return GestureDetector(
                          onTap: () => _openPoiSheet(poi),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161622).withOpacity(0.92),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: poi.color, width: 1.2),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  poi.isUnlocked ? poi.icon : Icons.lock,
                                  color: poi.color,
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  poi.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 4. INSTRUCCIÓN INFERIOR DE NAVEGACIÓN
            Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    'Arrastra para caminar por las calles • Toca una estructura arriba',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// MOTOR DE RENDERIZADO 2.5D DE CIUDAD PROCEDURAL (SIN ARCHIVOS EXTERNOS)
// =========================================================================
class _ProceduralCity25DPainter extends CustomPainter {
  final Offset cameraCenter;
  final List<CityPointOfInterest> pois;
  final double pulseValue;

  _ProceduralCity25DPainter({
    required this.cameraCenter,
    required this.pois,
    required this.pulseValue,
  });

  // Proyecta coordenadas planas del mundo (X, Y) a perspectiva inclinada 2.5D
  Offset _project(Offset worldPt, Size screenSize) {
    final dx = worldPt.dx - cameraCenter.dx;
    final dy = worldPt.dy - cameraCenter.dy;

    // Factor de profundidad: lo que está más arriba (dy negativo) se encoge hacia el horizonte
    final depthScale = (1.0 + (dy / 1400.0)).clamp(0.32, 1.65);

    final screenX = (screenSize.width / 2) + (dx * depthScale);
    final screenY = (screenSize.height * 0.68) + (dy * 0.52 * depthScale);

    return Offset(screenX, screenY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fondo base de asfalto de calles
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF1D2430),
    );

    const double blockStep = 250.0; // Cada cuadra mide 250x250 unidades
    const double roadHalfWidth = 34.0;

    final blockFill = Paint()..color = const Color(0xFF142826);
    final blockBorder = Paint()
      ..color = Colors.amber.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final buildingRoof = Paint()..color = const Color(0xFF191D2B);
    final buildingSide = Paint()..color = const Color(0xFF0E111A);

    // 2. Dibujar cuadrícula de manzanas de ciudad visibles alrededor del jugador
    final int startCol = ((cameraCenter.dx - 1400) / blockStep).floor();
    final int endCol = ((cameraCenter.dx + 1400) / blockStep).ceil();
    final int startRow = ((cameraCenter.dy - 1600) / blockStep).floor();
    final int endRow = ((cameraCenter.dy + 900) / blockStep).ceil();

    for (int row = startRow; row <= endRow; row++) {
      for (int col = startCol; col <= endCol; col++) {
        final left = col * blockStep + roadHalfWidth;
        final right = (col + 1) * blockStep - roadHalfWidth;
        final top = row * blockStep + roadHalfWidth;
        final bottom = (row + 1) * blockStep - roadHalfWidth;

        final pTL = _project(Offset(left, top), size);
        final pTR = _project(Offset(right, top), size);
        final pBR = _project(Offset(right, bottom), size);
        final pBL = _project(Offset(left, bottom), size);

        // Ignorar bloques fuera de pantalla
        if (pBL.dy < 40 || pTL.dy > size.height + 100) continue;

        final blockPath = Path()
          ..moveTo(pTL.dx, pTL.dy)
          ..lineTo(pTR.dx, pTR.dy)
          ..lineTo(pBR.dx, pBR.dy)
          ..lineTo(pBL.dx, pBL.dy)
          ..close();

        // Manzana verde táctico con borde amarillo/ámbar (estilo Pokémon GO)
        canvas.drawPath(blockPath, blockFill);
        canvas.drawPath(blockPath, blockBorder);

        // Dibujar bloques de edificios 2.5D dentro de las manzanas
        if ((row + col).abs() % 2 == 0) {
          final bL = left + 28;
          final bR = right - 28;
          final bT = top + 28;
          final bB = bottom - 28;

          final baseTL = _project(Offset(bL, bT), size);
          final baseTR = _project(Offset(bR, bT), size);
          final baseBR = _project(Offset(bR, bB), size);
          final baseBL = _project(Offset(bL, bB), size);

          const double roofHeight = 26.0;
          final roofTL = baseTL.translate(0, -roofHeight);
          final roofTR = baseTR.translate(0, -roofHeight);
          final roofBR = baseBR.translate(0, -roofHeight);
          final roofBL = baseBL.translate(0, -roofHeight);

          // Cara frontal del edificio
          final frontWall = Path()
            ..moveTo(baseBL.dx, baseBL.dy)
            ..lineTo(baseBR.dx, baseBR.dy)
            ..lineTo(roofBR.dx, roofBR.dy)
            ..lineTo(roofBL.dx, roofBL.dy)
            ..close();
          canvas.drawPath(frontWall, buildingSide);

          // Techo del edificio
          final roofPath = Path()
            ..moveTo(roofTL.dx, roofTL.dy)
            ..lineTo(roofTR.dx, roofTR.dy)
            ..lineTo(roofBR.dx, roofBR.dy)
            ..lineTo(roofBL.dx, roofBL.dy)
            ..close();
          canvas.drawPath(roofPath, buildingRoof);
          canvas.drawPath(
            roofPath,
            Paint()
              ..color = Colors.white12
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          );
        }
      }
    }

    // 3. Dibujar Balizas / Estructuras Interactivas verticales
    for (final poi in pois) {
      final base = _project(poi.worldPos, size);
      if (base.dy < 60 || base.dy > size.height) continue;

      // Aro en el suelo
      canvas.drawOval(
        Rect.fromCenter(center: base, width: 54, height: 26),
        Paint()
          ..color = poi.color.withOpacity(0.35)
          ..style = PaintingStyle.fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: base, width: 54, height: 26),
        Paint()
          ..color = poi.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Pilar vertical luminoso
      final topBeacon = base.translate(0, -48);
      canvas.drawLine(
        base,
        topBeacon,
        Paint()
          ..color = poi.color
          ..strokeWidth = 3,
      );

      // Núcleo flotante de la estructura
      canvas.drawCircle(
        topBeacon,
        14,
        Paint()..color = const Color(0xFF161622),
      );
      canvas.drawCircle(
        topBeacon,
        14,
        Paint()
          ..color = poi.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }

    // 4. Dibujar Escuadrón del Jugador en primer plano (Comandante + Animal)
    final playerScreenPos = Offset(size.width / 2, size.height * 0.68);

    // Onda de radar pulsante alrededor del jugador
    final radarRadius = 25.0 + (pulseValue * 55.0);
    canvas.drawOval(
      Rect.fromCenter(
        center: playerScreenPos,
        width: radarRadius * 2,
        height: radarRadius,
      ),
      Paint()
        ..color = Colors.amber.withOpacity((1.0 - pulseValue) * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Ficha del Comandante (centro)
    canvas.drawCircle(
      playerScreenPos.translate(0, -14),
      15,
      Paint()..color = Colors.amber.shade600,
    );
    canvas.drawCircle(
      playerScreenPos.translate(0, -14),
      15,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Ficha del Animal Compañero (a su izquierda, como en Pokémon GO)
    canvas.drawCircle(
      playerScreenPos.translate(-34, -6),
      11,
      Paint()..color = const Color(0xFF2ECC71),
    );
    canvas.drawCircle(
      playerScreenPos.translate(-34, -6),
      11,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _ProceduralCity25DPainter oldDelegate) => true;
}