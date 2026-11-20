import 'package:flutter/material.dart';
import '../core/connection_service.dart';

class KitsuneOfflineDialog extends StatefulWidget {
  final String kitsuneAssetPath;
  final VoidCallback? onSwitchToOfflineMode;

  const KitsuneOfflineDialog({
    super.key,
    this.kitsuneAssetPath = 'assets/kitsune.png', // Ajusta al nombre exacto de tu imagen en assets
    this.onSwitchToOfflineMode,
  });

  /// Método rápido para invocar la alerta desde cualquier pantalla
  static Future<void> show(
    BuildContext context, {
    String kitsuneAssetPath = 'assets/kitsune.png',
    VoidCallback? onSwitchToOfflineMode,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Obliga al jugador a reintentar o salir al modo offline
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => KitsuneOfflineDialog(
        kitsuneAssetPath: kitsuneAssetPath,
        onSwitchToOfflineMode: onSwitchToOfflineMode,
      ),
    );
  }

  @override
  State<KitsuneOfflineDialog> createState() => _KitsuneOfflineDialogState();
}

class _KitsuneOfflineDialogState extends State<KitsuneOfflineDialog> {
  bool _isChecking = false;
  String _statusText = 'ENLACE SATELITAL CAÍDO // ERROR 503';

  Future<void> _retryConnection() async {
    setState(() {
      _isChecking = true;
      _statusText = 'ESCANEANDO FRECUENCIA DE RED...';
    });

    await Future.delayed(const Duration(milliseconds: 800));
    final isOnline = await ConnectionService.hasConnection();

    if (!mounted) return;

    if (isOnline) {
      Navigator.of(context).pop(); // Cierra el aviso y vuelve a la partida
    } else {
      setState(() {
        _isChecking = false;
        _statusText = 'SIN SEÑAL DETECTADA // REINTENTE';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161622),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.shade200, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.25),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera de alerta táctica
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        color: Colors.redAccent, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      _statusText,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Avatar de Kitsune con marco luminoso
              Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D0D14),
                  border: Border.all(color: Colors.amber.shade600, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.25),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.kitsuneAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent,
                            size: 48, color: Colors.amber.shade600),
                        const SizedBox(height: 4),
                        Text(
                          'KITSUNE',
                          style: TextStyle(
                            color: Colors.amber.shade600,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Nombre y rol del asistente
              Text(
                'KITSUNE // OFICIAL DE ENLACE',
                style: TextStyle(
                  color: Colors.amber.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              // Caja de diálogo táctico
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Text(
                  '¡Comandante! Se ha perdido la conexión con la red satelital. '
                  'No es posible sincronizar el mapa global ni los combates en línea en este momento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botón 1: Reintentar conexión
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isChecking ? null : _retryConnection,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(
                    _isChecking ? 'VERIFICANDO...' : 'REINTENTAR CONEXIÓN',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),

              // Botón 2: Ir al Modo Historia Offline (Opcional)
              if (widget.onSwitchToOfflineMode != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSwitchToOfflineMode!();
                    },
                    icon: const Icon(Icons.shield_outlined, size: 18),
                    label: const Text(
                      'JUGAR MODO HISTORIA (OFFLINE)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}