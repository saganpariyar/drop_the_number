import 'package:flutter/material.dart';
import '../models/game_tile.dart';
import '../utils/tile_colors.dart';

class TileWidget extends StatelessWidget {
  final GameTile tile;
  final double size;
  final VoidCallback? onTap;

  const TileWidget({
    super.key,
    required this.tile,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = TileColors.getStyle(tile.value);
    final text = TileColors.formatNumber(tile.value);

    // Font size scaling depending on string length
    double fontSize = size * 0.40;
    if (text.length >= 4) {
      fontSize = size * 0.28;
    } else if (text.length == 3) {
      fontSize = size * 0.34;
    }

    final tileBody = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.gradientColors,
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            blurRadius: style.elevation * 1.5,
            spreadRadius: 1.0,
            offset: Offset(0, style.elevation * 0.5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.25),
            blurRadius: 1,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
        border: tile.isHighlight
            ? Border.all(color: Colors.white, width: 2.5)
            : Border.all(color: Colors.white.withOpacity(0.18), width: 1.2),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: style.textColor,
            letterSpacing: -0.5,
            shadows: const [
              Shadow(
                color: Colors.black38,
                blurRadius: 3,
                offset: Offset(0, 1.5),
              ),
            ],
          ),
        ),
      ),
    );

    Widget animatedTile = tileBody;

    if (tile.isMerged) {
      animatedTile = TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.25, end: 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: tileBody,
      );
    } else if (tile.isNew) {
      animatedTile = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.6, end: 1.0),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: tileBody,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: animatedTile,
    );
  }
}

