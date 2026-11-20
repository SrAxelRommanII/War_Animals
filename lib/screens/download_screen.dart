import 'dart:async';
import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double _progress = 0.0;
  int _currentTipIndex = 0;
  Timer? _downloadTimer;
  Timer? _tipTimer;

  // Lista con los 5 personajes y sus consejos (Sintaxis de tipo corregida)
  final _tips = [
    {
      'title': 'Lala',
      'image': 'assets/images/Osa.png',
      'tag': 'DEFENSA / TANQUE',
      'tip': 'Mantén siempre a tus unidades tanque en la línea frontal. Su blindaje absorberá el impacto directo.',
    },
    {
      'title': 'SKY',
      'image': 'assets/images/Zorro.png',
      'tag': 'VELOCIDAD / ESPECIALISTA',
      'tip': 'Su agilidad le permite flanquear las posiciones enemigas y deshabilitar sus defensas.',
    },
    {
      'title': 'ALFA',
      'image': 'assets/images/Lobo.png',
      'tag': 'EQUILIBRIO / LÍDER',
      'tip': 'Aumenta el moral y la velocidad de ataque de todos los aliados cercanos en combate.',
    },
    {
      'title': 'SOMBRA',
      'image': 'assets/images/Gato.png',
      'tag': 'SIGILO / ASESINO',
      'tip': 'Utiliza las zonas oscuras del mapa para infiltrarte sin ser detectado por radares enemigos.',
    },
    {
      'title': 'Hunter',
      'image': 'assets/images/Buho.png',
      'tag': 'RECONOCIMIENTO / APOYO',
      'tip': 'Revela la posición de las emboscadas enemigas desde el aire antes de enviar a tus tropas.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startDownloadProcess();
  }

  void _startDownloadProcess() {
    // 1. Avance de la barra de progreso
    _downloadTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.009;

        if (_progress >= 1.0) {
          _progress = 1.0;
          _downloadTimer?.cancel();
          _tipTimer?.cancel();
          // Navega automáticamente a la bienvenida con Kitsune
          Navigator.pushReplacementNamed(context, '/assistant_intro');
        }
      });
    });

    // 2. Rotación rápida de tarjetas cada 2.2 segundos
    _tipTimer = Timer.periodic(const Duration(milliseconds: 2200), (timer) {
      if (!mounted) return;
      if (_progress < 1.0) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _downloadTimer?.cancel();
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTip = _tips[_currentTipIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: Stack(
        children: [
          // Imagen de Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/Fondo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0D0D14)),
            ),
          ),

          // Capa de contraste
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Logo Superior
                  Image.asset(
                    'assets/logo.png',
                    height: 75,
                    errorBuilder: (_, __, ___) => const SizedBox(height: 75),
                  ),

                  const Spacer(),

                  // --- TARJETA DE PERSONAJE Y CONSEJO ---
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey<int>(_currentTipIndex),
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161622).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.shade600, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.25),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Encabezado de la Tarjeta
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade600,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  currentTip['tag']!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'CONSEJO ${_currentTipIndex + 1}/${_tips.length}',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // IMAGEN DEL ANIMAL
                          SizedBox(
                            height: 180,
                            child: Image.asset(
                              currentTip['image']!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.pets, size: 70, color: Colors.amber),
                                  SizedBox(height: 6),
                                  Text(
                                    'Imagen no encontrada',
                                    style: TextStyle(color: Colors.white54, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Título del Personaje
                          Text(
                            currentTip['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Texto del Consejo
                          Text(
                            currentTip['tip']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // --- BARRA DE PROGRESO ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'DESCARGANDO RECURSOS...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(_progress * 45.8).toStringAsFixed(1)} MB / 45.8 MB (${(_progress * 100).toInt()}%)',
                        style: TextStyle(
                          color: Colors.amber.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 12,
                      backgroundColor: Colors.black45,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.shade600),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}