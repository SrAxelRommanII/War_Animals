import 'package:flutter/material.dart';

enum ItemRarity { comun, raro, epico, legendario }

extension ItemRarityExtension on ItemRarity {
  String get name {
    switch (this) {
      case ItemRarity.comun: return 'COMÚN';
      case ItemRarity.raro: return 'RARO';
      case ItemRarity.epico: return 'ÉPICO';
      case ItemRarity.legendario: return 'LEGENDARIO';
    }
  }

  // Color primario para bordes, resplandores y etiquetas
  Color get color {
    switch (this) {
      case ItemRarity.comun: return const Color(0xFF2ECC71);     // Verde
      case ItemRarity.raro: return const Color(0xFF3498DB);      // Azul
      case ItemRarity.epico: return const Color(0xFF9B59B6);     // Morado
      case ItemRarity.legendario: return const Color(0xFFF1C40F); // Amarillo
    }
  }

  // Fondo estilizado tipo carta táctica/gacha
  LinearGradient get cardGradient {
    final baseColor = color;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        baseColor.withOpacity(0.35),
        baseColor.withOpacity(0.08),
        const Color(0xFF10101A),
      ],
      stops: const [0.0, 0.4, 1.0],
    );
  }
}