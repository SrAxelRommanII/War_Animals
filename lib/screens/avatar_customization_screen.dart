import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

// ==========================================
// 1. SISTEMA DE RAREZA Y COLORES TÁCTICOS
// ==========================================
enum ItemRarity { comun, raro, epico, legendario }

extension ItemRarityExt on ItemRarity {
  String get label {
    switch (this) {
      case ItemRarity.comun:
        return 'COMÚN';
      case ItemRarity.raro:
        return 'RARO';
      case ItemRarity.epico:
        return 'ÉPICO';
      case ItemRarity.legendario:
        return 'LEGENDARIO';
    }
  }

  Color get color {
    switch (this) {
      case ItemRarity.comun:
        return const Color(0xFF2ECC71); // Verde
      case ItemRarity.raro:
        return const Color(0xFF3498DB); // Azul
      case ItemRarity.epico:
        return const Color(0xFF9B59B6); // Morado
      case ItemRarity.legendario:
        return const Color(0xFFF1C40F); // Amarillo
    }
  }

  LinearGradient get cardGradient {
    final baseColor = color;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withOpacity(0.28),
        baseColor.withOpacity(0.08),
        const Color(0xFF12121C),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}

// ==========================================
// 2. MODELO DE PRENDA Y CONJUNTO
// ==========================================
class ClothingItem {
  final String id;
  final String name;
  final String category; // 'Conjuntos', 'Gorras', 'Camisas', 'Pantalones', 'Calzado'
  final String statBonus;
  final IconData icon;
  final ItemRarity rarity;
  final Map<String, String>? outfitPieces; // Solo se usa si es un Conjunto completo
  bool isOwned;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.statBonus,
    required this.icon,
    required this.rarity,
    this.outfitPieces,
    this.isOwned = false,
  });
}

// ==========================================
// 3. PANTALLA PRINCIPAL (ESTILO POKÉMON GO)
// ==========================================
class AvatarCustomizationScreen extends StatefulWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  State<AvatarCustomizationScreen> createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState extends State<AvatarCustomizationScreen> {
  String _selectedGender = 'Masculino';

  // Ítems actualmente equipados en el Comandante (Solo vestimenta)
  final Map<String, String> _equippedItems = {
    'Conjuntos': 'Personalizado',
    'Gorras': 'Gorra Táctica Ámbar',
    'Camisas': 'Camiseta Base (Defecto)',
    'Pantalones': 'Short Base (Defecto)',
    'Calzado': 'Botas Combate Pesado',
  };

  // Catálogo exclusivo de vestimenta del Comandante
  final List<ClothingItem> _catalog = [
    // --- CONJUNTOS COMPLETOS ---
    ClothingItem(
      id: 'set_1',
      name: 'Conjunto Recluta Urbano',
      category: 'Conjuntos',
      statBonus: 'Atuendo Inicial Completo',
      icon: Icons.person_pin,
      rarity: ItemRarity.comun,
      isOwned: true,
      outfitPieces: {
        'Gorras': 'Gorra Táctica Ámbar',
        'Camisas': 'Camiseta Base (Defecto)',
        'Pantalones': 'Short Base (Defecto)',
        'Calzado': 'Botas Combate Pesado',
      },
    ),
    ClothingItem(
      id: 'set_2',
      name: 'Conjunto Explorador Ámbar',
      category: 'Conjuntos',
      statBonus: '+15% Velocidad Exploración',
      icon: Icons.explore,
      rarity: ItemRarity.raro,
      isOwned: true,
      outfitPieces: {
        'Gorras': 'Gorra Veterano K9',
        'Camisas': 'Chaqueta Camuflada',
        'Pantalones': 'Pantalón Camuflado',
        'Calzado': 'Botas Combate Pesado',
      },
    ),
    ClothingItem(
      id: 'set_3',
      name: 'Conjunto Comandante Élite',
      category: 'Conjuntos',
      statBonus: '+25% Prestigio Táctico',
      icon: Icons.military_tech,
      rarity: ItemRarity.epico,
      isOwned: false,
      outfitPieces: {
        'Gorras': 'Boina Comandante',
        'Camisas': 'Chaqueta Táctica Cargo',
        'Pantalones': 'Pantalón Reforzado',
        'Calzado': 'Botas Sigilo Urbano',
      },
    ),
    ClothingItem(
      id: 'set_4',
      name: 'Conjunto Soberano Dorado',
      category: 'Conjuntos',
      statBonus: 'Atuendo Legendario',
      icon: Icons.auto_awesome,
      rarity: ItemRarity.legendario,
      isOwned: false,
      outfitPieces: {
        'Gorras': 'Boina Comandante',
        'Camisas': 'Abrigo de Operaciones',
        'Pantalones': 'Pantalón Reforzado',
        'Calzado': 'Botas Sigilo Urbano',
      },
    ),

    // --- GORRAS ---
    ClothingItem(
      id: 'g1',
      name: 'Gorra Táctica Ámbar',
      category: 'Gorras',
      statBonus: 'Estilo Urbano',
      icon: Icons.military_tech,
      rarity: ItemRarity.comun,
      isOwned: true,
    ),
    ClothingItem(
      id: 'g2',
      name: 'Gorra Veterano K9',
      category: 'Gorras',
      statBonus: 'Estilo Explorador',
      icon: Icons.sports_baseball,
      rarity: ItemRarity.raro,
      isOwned: true,
    ),
    ClothingItem(
      id: 'g3',
      name: 'Boina Comandante',
      category: 'Gorras',
      statBonus: 'Rango Oficial',
      icon: Icons.workspace_premium,
      rarity: ItemRarity.epico,
      isOwned: false,
    ),

    // --- CAMISAS ---
    ClothingItem(
      id: 'c1',
      name: 'Camiseta Base (Defecto)',
      category: 'Camisas',
      statBonus: 'Ligera',
      icon: Icons.checkroom,
      rarity: ItemRarity.comun,
      isOwned: true,
    ),
    ClothingItem(
      id: 'c2',
      name: 'Chaqueta Camuflada',
      category: 'Camisas',
      statBonus: 'Clima Templado',
      icon: Icons.dry_cleaning,
      rarity: ItemRarity.raro,
      isOwned: true,
    ),
    ClothingItem(
      id: 'c3',
      name: 'Chaqueta Táctica Cargo',
      category: 'Camisas',
      statBonus: 'Multi-bolsillos',
      icon: Icons.shield,
      rarity: ItemRarity.epico,
      isOwned: false,
    ),
    ClothingItem(
      id: 'c4',
      name: 'Abrigo de Operaciones',
      category: 'Camisas',
      statBonus: 'Edición Especial',
      icon: Icons.whatshot,
      rarity: ItemRarity.legendario,
      isOwned: false,
    ),

    // --- PANTALONES ---
    ClothingItem(
      id: 'p1',
      name: 'Short Base (Defecto)',
      category: 'Pantalones',
      statBonus: 'Movilidad Libre',
      icon: Icons.accessibility_new,
      rarity: ItemRarity.comun,
      isOwned: true,
    ),
    ClothingItem(
      id: 'p2',
      name: 'Pantalón Camuflado',
      category: 'Pantalones',
      statBonus: 'Campo y Bosque',
      icon: Icons.directions_run,
      rarity: ItemRarity.raro,
      isOwned: true,
    ),
    ClothingItem(
      id: 'p3',
      name: 'Pantalón Reforzado',
      category: 'Pantalones',
      statBonus: 'Alta Resistencia',
      icon: Icons.verified_user,
      rarity: ItemRarity.epico,
      isOwned: false,
    ),

    // --- CALZADO ---
    ClothingItem(
      id: 'b1',
      name: 'Botas Combate Pesado',
      category: 'Calzado',
      statBonus: 'Todo Terreno',
      icon: Icons.hiking,
      rarity: ItemRarity.comun,
      isOwned: true,
    ),
    ClothingItem(
      id: 'b2',
      name: 'Botas Sigilo Urbano',
      category: 'Calzado',
      statBonus: 'Suela Ligera',
      icon: Icons.do_not_step,
      rarity: ItemRarity.raro,
      isOwned: false,
    ),
  ];

  // ==========================================
  // MODAL INDEPENDIENTE DE VESTUARIO Y CONJUNTOS
  // ==========================================
  void _openWardrobeSheet() {
    String sheetCategory = 'Conjuntos';
    String sheetFilter = 'TODOS';
    final categories = [
      'Conjuntos',
      'Gorras',
      'Camisas',
      'Pantalones',
      'Calzado',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Filtrar y ordenar prendas dentro del modal
            List<ClothingItem> filteredList = _catalog
                .where((item) => item.category == sheetCategory)
                .toList();

            switch (sheetFilter) {
              case 'POSEÍDOS':
                filteredList = filteredList.where((i) => i.isOwned).toList();
                break;
              case 'COMÚN':
                filteredList = filteredList
                    .where((i) => i.rarity == ItemRarity.comun)
                    .toList();
                break;
              case 'RARO':
                filteredList = filteredList
                    .where((i) => i.rarity == ItemRarity.raro)
                    .toList();
                break;
              case 'ÉPICO':
                filteredList = filteredList
                    .where((i) => i.rarity == ItemRarity.epico)
                    .toList();
                break;
              case 'LEGENDARIO':
                filteredList = filteredList
                    .where((i) => i.rarity == ItemRarity.legendario)
                    .toList();
                break;
            }

            filteredList.sort((a, b) {
              if (a.isOwned != b.isOwned) return a.isOwned ? -1 : 1;
              return b.rarity.index.compareTo(a.rarity.index);
            });

            return Container(
              height: MediaQuery.of(context).size.height * 0.58,
              decoration: BoxDecoration(
                color: const Color(0xFF12121C),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: Colors.amber.shade600, width: 2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Indicador de arrastre superior
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Encabezado del Vestuario
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.checkroom,
                                color: Colors.amber.shade600, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'VESTUARIO DEL COMANDANTE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.close, color: Colors.white54),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Pestañas de Categorías 
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat == sheetCategory;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() => sheetCategory = cat);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.amber.shade600
                                  : const Color(0xFF1B1B29),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.white12,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat.toUpperCase(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Atajos de Rareza y Posesión
                  _buildModalFilterBar(sheetFilter, (newFilter) {
                    setModalState(() => sheetFilter = newFilter);
                  }),

                  const SizedBox(height: 10),
                    //Ya le dije a emman que te pase el url para las prendas del av
                  // Grilla Responsiva de Conjuntos / Prendas
                  Expanded(
                    child: filteredList.isEmpty
                        ? Center(
                            child: Text(
                              'Sin elementos en "$sheetFilter"',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: filteredList.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 260,
                              mainAxisExtent: 86,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final isEquipped =
                                  _equippedItems[sheetCategory] == item.name;

                              return _buildRarityCard(item, isEquipped, () {
                                if (!item.isOwned) return;
                                setState(() {
                                  if (item.category == 'Conjuntos' &&
                                      item.outfitPieces != null) {
                                    _equippedItems['Conjuntos'] = item.name;
                                    _equippedItems.addAll(item.outfitPieces!);
                                  } else {
                                    _equippedItems['Conjuntos'] =
                                        'Personalizado';
                                    _equippedItems[item.category] = item.name;
                                  }
                                });
                                setModalState(() {});
                              });
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmAvatar() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final commanderName = args?['commanderName'] ?? 'Comandante Alpha';

    Navigator.pushReplacementNamed(
      context,
      '/starter_selection',
      arguments: {
        'commanderName': commanderName,
        'gender': _selectedGender,
        'equippedOutfit': _equippedItems,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rawAssetPath = _selectedGender == 'Masculino'
        ? 'assets/models/AvatarHombre/AvatarMasculino.glb'
        : 'assets/models/AvatarMujer/AvatarMujer.glb';
    final String modelPath = kIsWeb ? 'assets/$rawAssetPath' : rawAssetPath;


    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161622),
        elevation: 0,
        title: const Text(
          'PERSONALIZAR COMANDANTE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/Fondo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF0D0D14)),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.82)),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),

                // 1. Selector de Género 
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161622),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  _buildGenderButton('Masculino', Icons.male)),
                          Expanded(
                              child:
                                  _buildGenderButton('Femenino', Icons.female)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 2. ESCENARIO CENTRAL DEL AVATAR (PROTAGONISMO ESTILO POKÉMON GO)
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 750),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161622).withOpacity(0.88),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: Colors.amber.shade600, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.16),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Etiqueta superior del modelo activo
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Text(
                                  'MODELO ACTIVO: Personaje$_selectedGender',
                                  style: TextStyle(
                                    color: Colors.amber.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            ),

                            // Halo ambiental detrás del modelo
                            Center(
                              child: Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.amber.withOpacity(0.18),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Visor 3D interactivo (.glb)
                            Positioned.fill(
                              top: 32,
                              bottom: 48,
                              child: ModelViewer(
                                key: ValueKey(modelPath),
                                src: modelPath,
                                alt: 'Avatar 3D $_selectedGender',
                                loading: Loading.eager,
                                autoRotate: true,
                                cameraControls: true,
                                autoPlay: true,
                                backgroundColor: Colors.transparent,
                              ),
                            ),

                            // BOTÓN INDEPENDIENTE DE VESTUARIO Y CONJUNTOS (Estilo Pokémon GO)
                            Positioned(
                              right: 8,
                              bottom: 54,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1F1F2E),
                                  foregroundColor: Colors.amber.shade500,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                        color: Colors.amber.shade600,
                                        width: 1.5),
                                  ),
                                  elevation: 8,
                                ),
                                onPressed: _openWardrobeSheet,
                                icon: const Icon(Icons.checkroom, size: 20),
                                label: const Text(
                                  'CONJUNTOS Y PRENDAS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),

                            // Resumen limpio del atuendo equipado en la base
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.amber.shade600
                                          .withOpacity(0.5)),
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    _buildEquippedTag('CONJUNTO',
                                        _equippedItems['Conjuntos']!),
                                    _buildEquippedTag(
                                        'GORRA', _equippedItems['Gorras']!),
                                    _buildEquippedTag(
                                        'TORSO', _equippedItems['Camisas']!),
                                    _buildEquippedTag('PIERNAS',
                                        _equippedItems['Pantalones']!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Botón Inferior de Confirmación
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade600,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: _confirmAvatar,
                          child: const Text(
                            'ELEGIR COMPAÑERO TÁCTICO',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
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

  Widget _buildEquippedTag(String slot, String itemName) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 10),
        children: [
          TextSpan(
            text: '$slot: ',
            style: TextStyle(
              color: Colors.amber.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: itemName,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildModalFilterBar(
      String currentFilter, ValueChanged<String> onSelect) {
    final filters = [
      {'label': 'TODOS', 'color': Colors.amber.shade600},
      {'label': 'POSEÍDOS', 'color': Colors.white},
      {'label': 'COMÚN', 'color': ItemRarity.comun.color},
      {'label': 'RARO', 'color': ItemRarity.raro.color},
      {'label': 'ÉPICO', 'color': ItemRarity.epico.color},
      {'label': 'LEGENDARIO', 'color': ItemRarity.legendario.color},
    ];

    return SizedBox(
      height: 28,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final f = filters[index];
          final label = f['label'] as String;
          final color = f['color'] as Color;
          final isSelected = currentFilter == label;

          return GestureDetector(
            onTap: () => onSelect(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? color : const Color(0xFF1B1B29),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.3),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : color,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRarityCard(
      ClothingItem item, bool isEquipped, VoidCallback onTap) {
    final rarityColor = item.rarity.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: item.rarity.cardGradient,
          border: Border.all(
            color: isEquipped
                ? Colors.amber.shade400
                : (item.isOwned ? rarityColor : Colors.white12),
            width: isEquipped ? 2.2 : 1.2,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isOwned
                          ? rarityColor.withOpacity(0.2)
                          : Colors.white10,
                      border: Border.all(
                        color: item.isOwned ? rarityColor : Colors.grey,
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: item.isOwned ? rarityColor : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.rarity.label,
                          style: TextStyle(
                            color: item.isOwned ? rarityColor : Colors.grey,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.isOwned ? Colors.white : Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.statBonus,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.isOwned
                                ? Colors.amber.shade600
                                : Colors.white24,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isOwned)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.white54, size: 22),
                ),
              ),
            if (isEquipped)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'EQUIPADO',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedGender = gender);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white54,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              gender.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}