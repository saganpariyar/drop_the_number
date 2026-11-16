import 'package:flutter/material.dart';
import '../models/game_engine.dart';

class BoosterBarWidget extends StatelessWidget {
  final GameEngine engine;

  const BoosterBarWidget({
    super.key,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BoosterButton(
            title: 'HAMMER',
            icon: Icons.gavel_rounded,
            count: engine.hammerCount,
            color: const Color(0xFFEF4444),
            isActive: engine.activeBooster == BoosterType.hammer,
            onTap: () => engine.toggleBooster(BoosterType.hammer),
          ),
          _BoosterButton(
            title: 'SWAP',
            icon: Icons.swap_horiz_rounded,
            count: engine.swapCount,
            color: const Color(0xFF06B6D4),
            isActive: false,
            onTap: () => engine.useSwap(),
          ),
          _BoosterButton(
            title: 'BOMB',
            icon: Icons.local_fire_department_rounded,
            count: engine.bombCount,
            color: const Color(0xFFF97316),
            isActive: engine.activeBooster == BoosterType.bomb,
            onTap: () => engine.toggleBooster(BoosterType.bomb),
          ),
          _BoosterButton(
            title: 'DOUBLER',
            icon: Icons.star_rounded,
            count: engine.doublerCount,
            color: const Color(0xFFEAB308),
            isActive: engine.activeBooster == BoosterType.doubler,
            onTap: () => engine.toggleBooster(BoosterType.doubler),
          ),
        ],
      ),
    );
  }
}

class _BoosterButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _BoosterButton({
    required this.title,
    required this.icon,
    required this.count,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = count > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? color.withOpacity(0.3)
                : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? color
                  : (isAvailable ? color.withOpacity(0.35) : Colors.white10),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isAvailable ? color : Colors.white24,
                    size: 22,
                  ),
                  Positioned(
                    top: -6,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: isAvailable ? color : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: isAvailable ? Colors.white70 : Colors.white24,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

