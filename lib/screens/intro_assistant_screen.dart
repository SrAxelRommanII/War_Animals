import 'package:flutter/material.dart';

class IntroAssistantScreen extends StatefulWidget {
  const IntroAssistantScreen({super.key});

  @override
  State<IntroAssistantScreen> createState() => _IntroAssistantScreenState();
}

class _IntroAssistantScreenState extends State<IntroAssistantScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  // Controladores de animación
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  late AnimationController _gestureController;
  late Animation<double> _gestureScaleAnimation;

  late final List _dialogues;

  @override
  void initState() {
    super.initState();

    // 1. Animación continua de respiración/flotación
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    // 2. Animación de gesto/rebote al cambiar de diálogo
    _gestureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _gestureScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _gestureController,
        curve: Curves.elasticOut,
      ),
    );

    _gestureController.forward();

    // Diálogos y gestos
    _dialogues = [
      {
        'text': '¡Hola, recluta! Soy Kitsune, tu asistente táctica y oficial de inteligencia en War Animals.',
        'hasInput': false,
        'gestureTag': 'SALUDO',
      },
      {
        'text': 'Antes de desplegarte en el campo de batalla, ¿cómo deseas que te registre en el comando central?',
        'hasInput': true,
        'gestureTag': 'PREGUNTA',
      },
      {
        'text': '¡Excelente elección! Sincronizaremos tu radar GPS en tiempo real para detectar zonas de batalla y recursos cerca de ti.',
        'hasInput': false,
        'gestureTag': 'EXPLICACIÓN',
      },
      {
        'text': 'Ahora, es momento de personalizar la apariencia de tu Comandante antes de tomar el mando.',
        'hasInput': false,
        'gestureTag': 'ACCIÓN',
      },
    ];
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _gestureController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final dialogue = _dialogues[_currentStep];

    // Validar si la etapa requiere nombre y el campo está vacío
    if (dialogue['hasInput'] == true && _nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = '(si queremos ganar esta batalla sera mejor tener un apodo para comunicarnos no crees?)';
      });
      return;
    }

    // Si la validación pasa, limpiamos el error
    setState(() {
      _errorMessage = null;
    });

    if (_currentStep < _dialogues.length - 1) {
      setState(() {
        _currentStep++;
      });
      _gestureController.reset();
      _gestureController.forward();
    } else {
      // ✅ PASAR NOMBRE INGRESADO A LA SIGUIENTE PANTALLA
      final commanderName = _nameController.text.trim().isEmpty
          ? 'Comandante Alpha'
          : _nameController.text.trim();

      Navigator.pushReplacementNamed(
        context,
        '/avatar_customization',
        arguments: {'commanderName': commanderName},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogue = _dialogues[_currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Botón Omitir
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // ✅ TAMBIÉN ENVÍA EL NOMBRE SI OMITEN
                    final commanderName = _nameController.text.trim().isEmpty
                        ? 'Comandante Alpha'
                        : _nameController.text.trim();

                    Navigator.pushReplacementNamed(
                      context,
                      '/avatar_customization',
                      arguments: {'commanderName': commanderName},
                    );
                  },
                  child: const Text('OMITIR', style: TextStyle(color: Colors.grey)),
                ),
              ),

              const Spacer(),

              // --- AVATAR CON MOVIMIENTO FLUIDO Y REBOTE DE GESTOS ---
              AnimatedBuilder(
                animation: Listenable.merge([_floatingController, _gestureController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: Transform.scale(
                      scale: _gestureScaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/kitsune.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.pets,
                      size: 100,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- CAJA DE DIÁLOGO RPG ---
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Container(
                  key: ValueKey<int>(_currentStep),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.record_voice_over, color: Colors.amber, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'KITSUNE',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              dialogue['gestureTag'] as String,
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 20),
                      Text(
                        dialogue['text'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      if (dialogue['hasInput'] == true) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (_) {
                            if (_errorMessage != null) {
                              setState(() => _errorMessage = null);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Nombre de Comandante...',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: Colors.black26,
                            errorText: _errorMessage,
                            errorMaxLines: 2,
                            errorStyle: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.amber, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.amber, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Botón Continuar
              ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentStep == _dialogues.length - 1 ? 'PERSONALIZAR COMANDANTE' : 'CONTINUAR',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}