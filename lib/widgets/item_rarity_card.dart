import 'package:flutter/material.dart';
import '../models/equipment_item.dart';
import '../models/item_rarity.dart';

class ItemRarityCard extends StatelessWidget {
  final EquipmentItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemRarityCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rarityColor = item.rarity.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: item.rarity.cardGradient,
          border: Border.all(
            color: isSelected
                ? Colors.white
                : (item.isOwned ? rarityColor : Colors.grey.shade800),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: rarityColor.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Haz de luz brillante superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: item.isOwned ? rarityColor : Colors.grey,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: item.isOwned ? rarityColor : Colors.transparent,
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ],
                ),
              ),
            ),

            // Contenido de la Tarjeta
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge de Rareza Superior
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.isOwned
                            ? rarityColor.withOpacity(0.2)
                            : Colors.black45,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: item.isOwned ? rarityColor : Colors.grey,
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        item.rarity.name,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: item.isOwned ? rarityColor : Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Icono Central del Objeto
                  Opacity(
                    opacity: item.isOwned ? 1.0 : 0.35,
                    child: Icon(
                      item.icon,
                      size: 42,
                      color: item.isOwned ? rarityColor : Colors.grey,
                    ),
                  ),

                  // Nombre y Estadísticas
                  Column(
                    children: [
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.isOwned ? Colors.white : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (item.bonusArmor > 0)
                        Text(
                          '+${item.bonusArmor} DEF',
                          style: TextStyle(
                            fontSize: 10,
                            color: item.isOwned ? rarityColor : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Capa de Bloqueo si NO posee el objeto
            if (!item.isOwned)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white54,
                    size: 26,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}