import 'package:flutter/material.dart';
import 'starter_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Datos del jugador / Estado de la base
  final int _level = 5;
  final int _currentXp = 5715;
  final int _nextLevelXp = 20000;
  final int _totalXp = 105715;
  int _credits = 12500;
  final int _gems = 340;
  final int _energy = 85;
  bool _dailyCrateClaimed = false;

  // Valores de respaldo si se entra directo sin pasar por el carrusel
  final String _defaultAnimalName = 'Lala';
  final String _defaultAnimalImage = 'assets/images/Osa.png';

  // Controladores de animación (Llama del nombre y pulso táctico)
  late AnimationController _flameController;
  late AnimationController _pulseController;

  // Equipamiento táctico del Animal de Combate
 final List _animalGear = [
    {
      'slot': 'BLINDAJE DE VANGUARDIA',
      'item': 'Pechera Reforzada Mk-II',
      'bonus': '+25 DEFENSA',
      'icon': Icons.shield,
      'color': const Color(0xFF3498DB),
    },
    {
      'slot': 'MÓDULO DE ASALTO',
      'item': 'Colmillos / Garras de Tungsteno',
      'bonus': '+18 ATAQUE',
      'icon': Icons.bolt,
      'color': Colors.amber,
    },
    {
      'slot': 'ARNÉS TÁCTICO',
      'item': 'Propulsor Cinético Ligero',
      'bonus': '+12 VELOCIDAD',
      'icon': Icons.speed,
      'color': const Color(0xFF2ECC71),
    },
  ];

  @override
  void initState() {
    super.initState();
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flameController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Reclamar recompensa rápida diaria en el cuartel
  void _claimDailySupply() {
    if (_dailyCrateClaimed) return;
    setState(() {
      _dailyCrateClaimed = true;
      _credits += 500;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF161622),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(Icons.inventory, color: Colors.amber.shade500),
            const SizedBox(width: 10),
            const Text(
              '¡Suministro diario reclamado! +500 Créditos tácticos.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Panel modal para inspeccionar el equipamiento del Animal de Combate
  void _openAnimalEquipmentSheet(String animalName, String animalImage) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141622),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Colors.amber.shade600, width: 1.5),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.amber.shade600,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF0D0D14),
                      backgroundImage: AssetImage(animalImage),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EQUIPAMIENTO // ${animalName.toUpperCase()}',
                          style: TextStyle(
                            color: Colors.amber.shade500,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const Text(
                          'Módulos de Combate Activos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/starter_selection');
                    },
                    icon: const Icon(Icons.swap_horiz,
                        color: Colors.amber, size: 18),
                    label: const Text(
                      'CAMBIAR',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 24),
              ..._animalGear.map(
                (gear) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0E17),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: (gear['color'] as Color).withOpacity(0.45),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (gear['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          gear['icon'] as IconData,
                          color: gear['color'] as Color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gear['slot'] as String,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              gear['item'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (gear['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          gear['bonus'] as String,
                          style: TextStyle(
                            color: gear['color'] as Color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Diálogo interactivo de asistencia de Kitsune
  void _openKitsuneDialog(String commanderName, String animalName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161622).withOpacity(0.98),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.amber.shade600, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/kitsune.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.smart_toy, color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KITSUNE // ASISTENCIA TÁCTICA',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        'Oficial de Inteligencia y Estrategia',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 22),
              Text(
                '¡Listos para el despliegue, $commanderName! $animalName está equipado y en condiciones óptimas. Puedes patrullar tu zona real en Modo Online o avanzar por los capítulos de la ciudad en Modo Historia.',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber,
                        side: BorderSide(color: Colors.amber.shade600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/story_map');
                      },
                      child: const Text(
                        'IR A HISTORIA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/map',
                          arguments: {'commanderName': commanderName},
                        );
                      },
                      child: const Text(
                        'DESPLEGAR GPS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String commanderName = args?['commanderName'] ?? 'Comandante Alpha';
    final StarterAnimal? selectedAnimal = args?['starter'] as StarterAnimal?;

    final String activeAnimalName = selectedAnimal?.name ?? _defaultAnimalName;
    final String activeAnimalImage =
        selectedAnimal?.image ?? _defaultAnimalImage;
    final double xpProgress = (_currentXp / _nextLevelXp).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D14),
      body: Stack(
        children: [
          // 1. FONDO TÁCTICO Y MARCA DE AGUA DE FACCIÓN (ESTILO PERFIL POKÉMON GO)
          Positioned.fill(
            child: Image.asset(
              'assets/Fondo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF0B0D14)),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0B0D14).withOpacity(0.84),
                    const Color(0xFF121522).withOpacity(0.92),
                    const Color(0xFF0A0B10).withOpacity(0.98),
                  ],
                ),
              ),
            ),
          ),
          // Emblema gigante translúcido detrás del personaje
          Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Icon(
                Icons.shield,
                size: 310,
                color: Colors.amber.withOpacity(0.05),
              ),
            ),
          ),

          // 2. CONTENIDO PRINCIPAL DE LA INTERFAZ
          SafeArea(
            child: Column(
              children: [
                // --- BARRA SUPERIOR DE RECURSOS Y SUMINISTRO DIARIO ---
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      _buildResourceChip(
                          Icons.monetization_on, '$_credits', Colors.amber),
                      const SizedBox(width: 6),
                      _buildResourceChip(
                          Icons.diamond, '$_gems', Colors.cyanAccent),
                      const SizedBox(width: 6),
                      _buildResourceChip(
                          Icons.bolt, '$_energy/100', Colors.greenAccent),
                      const Spacer(),
                      // Botón rápido de recompensa diaria
                      InkWell(
                        onTap: _claimDailySupply,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _dailyCrateClaimed
                                ? Colors.white10
                                : Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _dailyCrateClaimed
                                  ? Colors.white24
                                  : Colors.amber,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _dailyCrateClaimed
                                    ? Icons.check_circle
                                    : Icons.card_giftcard,
                                color: _dailyCrateClaimed
                                    ? Colors.white54
                                    : Colors.amber,
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _dailyCrateClaimed ? 'LISTO' : 'COFRE',
                                style: TextStyle(
                                  color: _dailyCrateClaimed
                                      ? Colors.white54
                                      : Colors.amber,
                                  fontSize: 10,
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

                // --- ZONA CENTRAL SCROLLABLE (PERFIL + PERSONAJES + MODOS) ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        const SizedBox(height: 4),

                        // ESCENARIO DE PERSONAJES (COMANDANTE + ANIMAL DE COMBATE)
                        SizedBox(
                          height: 235,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Plataforma circular luminosa en el suelo
                              Positioned(
                                bottom: 8,
                                child: Container(
                                  width: 260,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(130),
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.amber.withOpacity(0.32),
                                        Colors.transparent,
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.amber.withOpacity(0.45),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),

                              // Avatar del Comandante (Izquierda/Centro)
                              Positioned(
                                left: 26,
                                bottom: 18,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 175,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        'assets/images/commander_avatar.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_pin,
                                              size: 98,
                                              color: Colors.amber.shade400,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.amber
                                                        .withOpacity(0.4)),
                                              ),
                                              child: const Text(
                                                'COMANDANTE',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Animal de Combate Seleccionado (Derecha/Centro)
                              Positioned(
                                right: 20,
                                bottom: 18,
                                child: GestureDetector(
                                  onTap: () => _openAnimalEquipmentSheet(
                                      activeAnimalName, activeAnimalImage),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 185,
                                        width: 155,
                                        child: Image.asset(
                                          activeAnimalImage,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.pets,
                                                  size: 110,
                                                  color: Colors.amber),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF161622)
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.amber.shade600),
                                        ),
                                        child: Text(
                                          activeAnimalName.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.amber,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // BOTONES RÁPIDOS DE PERSONALIZACIÓN (AVATAR Y EQUIPO ANIMAL)
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionChip(
                                icon: Icons.checkroom,
                                label: 'PERSONALIZAR AVATAR',
                                color: Colors.cyanAccent,
                                onTap: () => Navigator.pushNamed(
                                    context, '/avatar_customization'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildQuickActionChip(
                                icon: Icons.military_tech,
                                label: 'EQUIPO DE ${activeAnimalName.toUpperCase()}',
                                color: Colors.amber.shade500,
                                onTap: () => _openAnimalEquipmentSheet(
                                    activeAnimalName, activeAnimalImage),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // NOMBRE ESTILO LLAMA EN MOVIMIENTO + NIVEL Y BARRA DE PX
                        Text(
                          '$_totalXp PX TOTALES',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        _buildFlameCommanderTitle(commanderName, _level),
                        const SizedBox(height: 8),

                        // Barra de progreso de nivel (Inspirada en imagen 2)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: xpProgress,
                                  minHeight: 8,
                                  backgroundColor: Colors.white12,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.amber.shade600),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_currentXp / $_nextLevelXp PX',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // FILA DE INSIGNIAS DE PERFIL (ESTILO POKÉMON GO ADAPTADO)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161622).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Moneda / Medalla izquierda
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber.withOpacity(0.18),
                                      border: Border.all(
                                          color: Colors.amber, width: 1.5),
                                    ),
                                    child: const Icon(Icons.stars,
                                        color: Colors.amber, size: 20),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '14 VICTORIAS',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // Centro: Fecha de inicio y Rango
                              const Column(
                                children: [
                                  Text(
                                    'FECHA DE ALISTAMIENTO:',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '14/11/2026',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'RANGO: OFICIAL TÁCTICO',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // Derecha: Facción / Equipo
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF3498DB)
                                          .withOpacity(0.18),
                                      border: Border.all(
                                          color: const Color(0xFF3498DB),
                                          width: 1.5),
                                    ),
                                    child: const Icon(Icons.shield,
                                        color: Color(0xFF3498DB), size: 20),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'LEGIÓN ÁMBAR',
                                    style: TextStyle(
                                      color: Color(0xFF3498DB),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SELECTOR DE MODO DE JUEGO (ONLINE GPS VS MODO HISTORIA)
                        Row(
                          children: [
                            Expanded(
                              child: _buildModeCard(
                                title: 'MODO ONLINE',
                                subtitle: 'Mapa GPS • Combate PvP',
                                badge: 'EN LÍNEA',
                                icon: Icons.my_location,
                                primaryColor: Colors.amber.shade600,
                                filled: true,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/map',
                                  arguments: {'commanderName': commanderName},
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildModeCard(
                                title: 'MODO HISTORIA',
                                subtitle: 'Ciudad 2.5D • Campaña',
                                badge: 'OFFLINE',
                                icon: Icons.map,
                                primaryColor: const Color(0xFF2ECC71),
                                filled: false,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/story_map'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),

                // --- BARRA INFERIOR DE ACCESOS RÁPIDOS ---
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF141622),
                    border: Border(top: BorderSide(color: Colors.white12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavButton(
                        Icons.pets,
                        'ESCUADRÓN',
                        onTap: () =>
                            Navigator.pushNamed(context, '/starter_selection'),
                      ),
                      _buildNavButton(
                        Icons.checkroom,
                        'AVATAR',
                        onTap: () => Navigator.pushNamed(
                            context, '/avatar_customization'),
                      ),
                      _buildNavButton(
                        Icons.military_tech,
                        'EQUIPO',
                        onTap: () => _openAnimalEquipmentSheet(
                            activeAnimalName, activeAnimalImage),
                      ),
                      _buildNavButton(
                        Icons.smart_toy,
                        'KITSUNE',
                        onTap: () => _openKitsuneDialog(
                            commanderName, activeAnimalName),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. BOTÓN FLOTANTE DE ASISTENCIA DE KITSUNE CON PULSO
          Positioned(
            right: 16,
            top: 56,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber
                            .withOpacity(0.25 + (_pulseController.value * 0.35)),
                        blurRadius: 12 + (_pulseController.value * 8),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: () =>
                    _openKitsuneDialog(commanderName, activeAnimalName),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF161622),
                    border: Border.all(color: Colors.amber.shade600, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/kitsune.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.smart_toy,
                        color: Colors.amber,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget animado: Nombre del jugador y Nivel con efecto llama en movimiento
  Widget _buildFlameCommanderTitle(String name, int level) {
    return AnimatedBuilder(
      animation: _flameController,
      builder: (context, _) {
        final slide = (_flameController.value * 2.0) - 1.0;
        return Column(
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(-1.5 + slide, 0.8),
                  end: Alignment(1.5 + slide, -0.8),
                  colors: const [
                    Color(0xFFFF3D00), // Rojo fuego
                    Color(0xFFFF9100), // Naranja llama
                    Color(0xFFFFEA00), // Núcleo dorado brillante
                    Color(0xFFFF6D00), // Ámbar intenso
                    Color(0xFFFF3D00), // Rojo fuego
                  ],
                ).createShader(bounds);
              },
              child: Text(
                name.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                  shadows: [
                    Shadow(
                      color: Color(0xFFFF5722),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Color(0xFFFF6D00), size: 18),
                const SizedBox(width: 4),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment(-1.0 - slide, 0),
                      end: Alignment(1.0 - slide, 0),
                      colors: const [
                        Color(0xFFFFAB00),
                        Color(0xFFFF3D00),
                        Color(0xFFFFD600),
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'NIVEL $level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.local_fire_department,
                    color: Color(0xFFFF6D00), size: 18),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFF161622).withOpacity(0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required Color primaryColor,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: filled
              ? primaryColor
              : const Color(0xFF161622).withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor, width: 1.6),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: filled ? Colors.black : primaryColor,
                  size: 24,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: filled
                        ? Colors.black.withOpacity(0.18)
                        : primaryColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: filled ? Colors.black : primaryColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: filled ? Colors.black : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: filled ? Colors.black87 : Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.amber.shade600, size: 21),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}