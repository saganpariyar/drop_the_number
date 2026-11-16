import 'package:flutter/material.dart';
import '../models/game_engine.dart';
import '../utils/tile_colors.dart';

class TopBarWidget extends StatelessWidget {
  final GameEngine engine;
  final VoidCallback onPause;
  final VoidCallback onRestart;

  const TopBarWidget({
    super.key,
    required this.engine,
    required this.onPause,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo / Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF0844), Color(0xFFFFB199)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF0844).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DROP THE NUMBER',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Merge Blocks • Reach 2048',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Control buttons
              Row(
                children: [
                  _IconButton(
                    icon: Icons.refresh_rounded,
                    tooltip: 'Restart',
                    onTap: onRestart,
                  ),
                  const SizedBox(width: 8),
                  _IconButton(
                    icon: Icons.pause_rounded,
                    tooltip: 'Pause & Settings',
                    onTap: onPause,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Score row
          Row(
            children: [
              // Current Score
              Expanded(
                flex: 4,
                child: _ScoreBox(
                  label: 'SCORE',
                  value: engine.score.toString(),
                  color: const Color(0xFF1E293B),
                  accentColor: const Color(0xFF38BDF8),
                ),
              ),
              const SizedBox(width: 8),

              // High Score
              Expanded(
                flex: 4,
                child: _ScoreBox(
                  label: 'BEST 👑',
                  value: engine.highScore.toString(),
                  color: const Color(0xFF1E293B),
                  accentColor: const Color(0xFFFBBF24),
                ),
              ),
              const SizedBox(width: 8),

              // Highest Tile Trophy
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TOP TILE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.55),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        TileColors.formatNumber(engine.highestTile),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color accentColor;

  const _ScoreBox({
    required this.label,
    required this.value,
    required this.color,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white.withOpacity(0.55),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.85),
            size: 20,
          ),
        ),
      ),
    );
  }
}
