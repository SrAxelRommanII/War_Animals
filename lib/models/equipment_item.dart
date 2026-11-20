import 'package:flutter/material.dart';
import 'item_rarity.dart';

class EquipmentItem {
  final String id;
  final String name;
  final ItemRarity rarity;
  final String category; // 'GORRAS', 'CHALECOS', 'CASCOS', etc.
  final IconData icon;
  final int bonusArmor;
  final int bonusStealth;
  
  bool isOwned; // True si el jugador ya lo obtuvo en batalla o recompensa

  EquipmentItem({
    required this.id,
    required this.name,
    required this.rarity,
    required this.category,
    required this.icon,
    this.bonusArmor = 0,
    this.bonusStealth = 0,
    this.isOwned = false,
  });
}