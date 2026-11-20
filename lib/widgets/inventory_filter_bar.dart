import 'package:flutter/material.dart';
import '../models/item_rarity.dart';

class InventoryFilterBar extends StatelessWidget {
  final String selectedFilter; // 'TODOS', 'POSEÍDOS', 'COMÚN', 'RARO', etc.
  final ValueChanged<String> onFilterChanged;

  const InventoryFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'label': 'TODOS', 'color': Colors.amber.shade600},
      {'label': 'POSEÍDOS', 'color': Colors.white},
      {'label': 'COMÚN', 'color': ItemRarity.comun.color},
      {'label': 'RARO', 'color': ItemRarity.raro.color},
      {'label': 'ÉPICO', 'color': ItemRarity.epico.color},
      {'label': 'LEGENDARIO', 'color': ItemRarity.legendario.color},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final label = f['label'] as String;
          final color = f['color'] as Color;
          final isSelected = selectedFilter == label;

          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: ChoiceChip(
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : color,
                ),
              ),
              selected: isSelected,
              selectedColor: color,
              backgroundColor: const Color(0xFF1A1A26),
              side: BorderSide(
                color: isSelected ? color : color.withOpacity(0.3),
              ),
              onSelected: (_) => onFilterChanged(label),
            ),
          );
        }).toList(),
      ),
    );
  }
}