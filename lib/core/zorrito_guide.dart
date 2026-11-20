import 'package:flutter/material.dart';

class ZorritoGuideWidget extends StatelessWidget {
  final String message;
  final bool showGuide;
  final bool isOffline;

  const ZorritoGuideWidget({
    super.key,
    required this.message,
    this.showGuide = true,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showGuide && !isOffline) return const SizedBox.shrink();

    final displayMessage = isOffline
        ? '¡Perdiendo señal con la Realidad Solapada! Revisa tu conexión a internet.'
        : message;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade900.withOpacity(0.85), // Fondo verde oscuro profundo
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white, // Borde blanco limpio
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/animations/zorrito_confuso.gif',
            width: 65,
            height: 65,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isOffline ? Icons.wifi_off : Icons.pets,
                size: 45,
                color: isOffline ? Colors.white : Colors.amber.shade600, // Color modificado aquí
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              displayMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}