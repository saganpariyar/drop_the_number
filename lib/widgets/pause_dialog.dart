import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class PauseDialog extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;

  const PauseDialog({
    super.key,
    required this.onResume,
    required this.onRestart,
  });

  @override
  State<PauseDialog> createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> {
  late bool soundEnabled;
  late bool vibrationEnabled;

  @override
  void initState() {
    super.initState();
    soundEnabled = StorageService.isSoundEnabled();
    vibrationEnabled = StorageService.isVibrationEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF334155), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'GAME PAUSED',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Drop The Number: Merge & 2048',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 20),

            // Settings toggles
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            soundEnabled
                                ? Icons.volume_up_rounded
                                : Icons.volume_off_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Sound Effects',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: soundEnabled,
                        activeColor: const Color(0xFF38BDF8),
                        onChanged: (val) {
                          setState(() => soundEnabled = val);
                          StorageService.setSoundEnabled(val);
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            vibrationEnabled
                                ? Icons.vibration_rounded
                                : Icons.smartphone_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Haptic Feedback',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: vibrationEnabled,
                        activeColor: const Color(0xFF38BDF8),
                        onChanged: (val) {
                          setState(() => vibrationEnabled = val);
                          StorageService.setVibrationEnabled(val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // How to play guide
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.help_outline_rounded,
                          color: Color(0xFF38BDF8), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'HOW TO PLAY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF38BDF8),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• Tap any column to drop the falling number block.\n'
                    '• Same numbers merge into higher power of 2 (2+2=4, 4+4=8).\n'
                    '• Chain combos for massive bonus multipliers!\n'
                    '• Reach 2048, 4096 and infinity before columns overflow!',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onRestart,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'RESTART',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEF4444),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: widget.onResume,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'RESUME',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

