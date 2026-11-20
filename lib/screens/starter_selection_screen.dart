import 'package:flutter/material.dart';

// Modelo de datos para garantizar tipado estricto sin errores de conversión
class StarterAnimal {
  final String id;
  final String name;
  final String type;
  final String image;
  final String description;
  final int hp;
  final int attack;
  final int defense;
  final int speed;

  const StarterAnimal({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.description,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
  });
}

class StarterSelectionScreen extends StatefulWidget {
  const StarterSelectionScreen({super.key});

  @override
  State<StarterSelectionScreen> createState() => _StarterSelectionScreenState();
}

class _StarterSelectionScreenState extends State<StarterSelectionScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;

  // Lista tipada de los 5 compañeros tácticos
  final List<StarterAnimal> _animals = const [
    StarterAnimal(
      id: 'osa',
      name: 'Lala',
      type: 'TANQUE',
      image: 'assets/images/Osa.png',
      description: 'Especialista en absorción de daño directo y blindaje pesado de vanguardia.',
      hp: 180,
      attack: 45,
      defense: 90,
      speed: 35,
    ),
    StarterAnimal(
      id: 'zorro',
      name: 'Sky',
      type: 'ESPECIALISTA',
      image: 'assets/images/Zorro.png',
      description: 'Alta velocidad de maniobra, flanqueo táctico y deshabilitación de defensas.',
      hp: 110,
      attack: 85,
      defense: 40,
      speed: 95,
    ),
    StarterAnimal(
      id: 'lobo',
      name: 'Alfa',
      type: 'LÍDER / EQUILIBRIO',
      image: 'assets/images/Lobo.png',
      description: 'Liderazgo de escuadrón balanceado entre potencia de fuego y defensa.',
      hp: 140,
      attack: 70,
      defense: 65,
      speed: 70,
    ),
    StarterAnimal(
      id: 'gato',
      name: 'Sombra',
      type: 'ASESINO / SIGILO',
      image: 'assets/images/Gato.png',
      description: 'Infiltración sigilosa en zonas oscuras y ataques críticos a objetivos clave.',
      hp: 95,
      attack: 95,
      defense: 30,
      speed: 90,
    ),
    StarterAnimal(
      id: 'buho',
      name: 'Hunter',
      type: 'RECONOCIMIENTO',
      image: 'assets/images/Buho.png',
      description: 'Soporte aéreo, detección de emboscadas e inteligencia en tiempo real.',
      hp: 120,
      attack: 60,
      defense: 55,
      speed: 80,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _confirmSelection() {
    final selected = _animals[_selectedIndex];
    print('Personaje seleccionado: ${selected.name}');
    
    // Pasamos el personaje seleccionado a la pantalla /home
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _animals[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: Stack(
        children: [
          // Fondo táctico
          Positioned.fill(
            child: Image.asset(
              'assets/Fondo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0D0D14)),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.82),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                
                // Título Superior
                const Text(
                  'ELIGE TU COMPAÑERO TÁCTICO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'OPERADOR ${_selectedIndex + 1} DE ${_animals.length}',
                  style: TextStyle(
                    color: Colors.amber.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),

                const Spacer(),

                // --- CARRUSEL PRINCIPAL CON FLECHAS LATERALES ---
                SizedBox(
                  height: 480,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // VISTA DE TARJETAS
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _animals.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final animal = _animals[index];
                          final isSelected = index == _selectedIndex;

                          return GestureDetector(
                            onTap: () => _selectPage(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161622).withOpacity(0.95),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected ? Colors.amber.shade600 : Colors.white12,
                                  width: isSelected ? 2.5 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Column(
                                children: [
                                  // Etiqueta de Rol
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade600,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      animal.type,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // Imagen del personaje
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Image.asset(
                                        animal.image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.pets,
                                          size: 90,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Nombre del Personaje
                                  Text(
                                    animal.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    animal.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // --- BARRAS DE ESTADÍSTICAS TÁCTICAS ---
                                  _buildStatBar('SALUD', animal.hp, 200, Colors.redAccent, Icons.favorite),
                                  _buildStatBar('ATAQUE', animal.attack, 100, Colors.amber.shade600, Icons.flash_on),
                                  _buildStatBar('DEFENSA', animal.defense, 100, Colors.blueAccent, Icons.shield),
                                  _buildStatBar('VELOCIDAD', animal.speed, 100, Colors.greenAccent, Icons.speed),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Botón Flecha Izquierda
                      if (_selectedIndex > 0)
                        Positioned(
                          left: 4,
                          child: IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.amber),
                            onPressed: () => _selectPage(_selectedIndex - 1),
                          ),
                        ),

                      // Botón Flecha Derecha
                      if (_selectedIndex < _animals.length - 1)
                        Positioned(
                          right: 4,
                          child: IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.amber),
                            onPressed: () => _selectPage(_selectedIndex + 1),
                          ),
                        ),
                    ],
                  ),
                ),

                // --- SELECTOR DE MINIATURAS INFERIOR ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_animals.length, (index) {
                      final isSelected = index == _selectedIndex;
                      return GestureDetector(
                        onTap: () => _selectPage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(4),
                          width: isSelected ? 48 : 38,
                          height: isSelected ? 48 : 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E1E2C),
                            border: Border.all(
                              color: isSelected ? Colors.amber : Colors.white24,
                              width: isSelected ? 2.5 : 1,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              _animals[index].image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.pets,
                                size: 18,
                                color: isSelected ? Colors.amber : Colors.white38,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const Spacer(),

                // --- BOTÓN CONFIRMAR ELECCIÓN ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _confirmSelection,
                      child: Text(
                        'CONFIRMAR ELECCIÓN (${current.name.toUpperCase()})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para renderizar cada barra de estadística
  Widget _buildStatBar(String label, int value, int maxValue, Color color, IconData icon) {
    final double percentage = (value / maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8,
                backgroundColor: Colors.black45,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}