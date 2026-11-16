import 'package:flutter/material.dart';
import '../models/game_engine.dart';
import '../models/game_tile.dart';
import 'tile_widget.dart';

class DropperWidget extends StatelessWidget {
  final GameEngine engine;
  final double columnWidth;
  final double tileSize;

  const DropperWidget({
    super.key,
    required this.engine,
    required this.columnWidth,
    required this.tileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Next tile indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF94A3B8),
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                TileWidget(
                  tile: GameTile(id: 'next', value: engine.nextTileValue),
                  size: tileSize * 0.75,
                ),
              ],
            ),
          ),

          // Instruction or active booster badge
          Expanded(
            child: Center(
              child: engine.activeBooster != BoosterType.none
                  ? _buildBoosterActiveBanner(engine.activeBooster)
                  : (engine.comboMessage != null
                      ? TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(milliseconds: 180),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Text(
                                engine.comboMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFBBF24),
                                  shadows: [
                                    Shadow(
                                      color: Color(0x99F59E0B),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Text(
                          'TAP TO DROP ↓',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        )),
            ),
          ),

          // Current drop tile indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF38BDF8).withOpacity(0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withOpacity(0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'READY',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Color(0xFF38BDF8),
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                TileWidget(
                  tile: GameTile(id: 'current', value: engine.currentTileValue),
                  size: tileSize * 0.85,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoosterActiveBanner(BoosterType booster) {
    String text = '';
    Color color = Colors.amber;
    IconData icon = Icons.info;

    switch (booster) {
      case BoosterType.hammer:
        text = 'Tap tile to smash!';
        color = const Color(0xFFEF4444);
        icon = Icons.gavel_rounded;
        break;
      case BoosterType.bomb:
        text = 'Tap col to clear!';
        color = const Color(0xFFF97316);
        icon = Icons.local_fire_department_rounded;
        break;
      case BoosterType.doubler:
        text = 'Tap tile to 2X!';
        color = const Color(0xFFEAB308);
        icon = Icons.star_rounded;
        break;
      default:
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
