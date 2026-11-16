import 'package:flutter/material.dart';
import '../models/game_engine.dart';
import '../utils/tile_colors.dart';

class GameOverDialog extends StatelessWidget {
  final GameEngine engine;
  final VoidCallback onPlayAgain;

  const GameOverDialog({
    super.key,
    required this.engine,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNewHighScore = engine.score >= engine.highScore && engine.score > 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isNewHighScore ? const Color(0xFFFBBF24) : const Color(0xFFEF4444),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isNewHighScore
                  ? const Color(0xFFFBBF24).withOpacity(0.35)
                  : const Color(0xFFEF4444).withOpacity(0.35),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isNewHighScore
                    ? const Color(0xFFFBBF24).withOpacity(0.15)
                    : const Color(0xFFEF4444).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNewHighScore ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied_rounded,
                color: isNewHighScore ? const Color(0xFFFBBF24) : const Color(0xFFEF4444),
                size: 48,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              isNewHighScore ? 'NEW HIGH SCORE! 👑' : 'GAME OVER',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isNewHighScore ? const Color(0xFFFBBF24) : Colors.white,
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              isNewHighScore
                  ? 'Incredible performance! You set a new personal record!'
                  : 'The board filled up! Give it another shot!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.65),
              ),
            ),

            const SizedBox(height: 20),

            // Score board
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FINAL SCORE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        engine.score.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BEST SCORE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        engine.highScore.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HIGHEST TILE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        TileColors.formatNumber(engine.highestTile),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Play again button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPlayAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay_rounded, color: Color(0xFF0F172A), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

