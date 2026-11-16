import 'package:flutter/material.dart';

class TileStyle {
  final List<Color> gradientColors;
  final Color textColor;
  final Color shadowColor;
  final double elevation;

  const TileStyle({
    required this.gradientColors,
    required this.textColor,
    required this.shadowColor,
    this.elevation = 4.0,
  });
}

class TileColors {
  static const Map<int, TileStyle> _styles = {
    2: TileStyle(
      gradientColors: [Color(0xFF00C9FF), Color(0xFF4AC29A)],
      textColor: Colors.white,
      shadowColor: Color(0x6600C9FF),
    ),
    4: TileStyle(
      gradientColors: [Color(0xFF0BA360), Color(0xFF3CBA92)],
      textColor: Colors.white,
      shadowColor: Color(0x660BA360),
    ),
    8: TileStyle(
      gradientColors: [Color(0xFFFF8008), Color(0xFFFFC837)],
      textColor: Colors.white,
      shadowColor: Color(0x66FF8008),
    ),
    16: TileStyle(
      gradientColors: [Color(0xFFFF512F), Color(0xFFF09819)],
      textColor: Colors.white,
      shadowColor: Color(0x66FF512F),
    ),
    32: TileStyle(
      gradientColors: [Color(0xFFE52D27), Color(0xFFB31217)],
      textColor: Colors.white,
      shadowColor: Color(0x66E52D27),
    ),
    64: TileStyle(
      gradientColors: [Color(0xFFFF0844), Color(0xFFFF4E50)],
      textColor: Colors.white,
      shadowColor: Color(0x66FF0844),
    ),
    128: TileStyle(
      gradientColors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
      textColor: Colors.white,
      shadowColor: Color(0x667F00FF),
    ),
    256: TileStyle(
      gradientColors: [Color(0xFF654EA3), Color(0xFF904E95)],
      textColor: Colors.white,
      shadowColor: Color(0x66654EA3),
    ),
    512: TileStyle(
      gradientColors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
      textColor: Colors.white,
      shadowColor: Color(0x662193B0),
    ),
    1024: TileStyle(
      gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
      textColor: Colors.white,
      shadowColor: Color(0x6638EF7D),
      elevation: 6.0,
    ),
    2048: TileStyle(
      gradientColors: [Color(0xFFF7971E), Color(0xFFFFD200)],
      textColor: Colors.white,
      shadowColor: Color(0x88FFD200),
      elevation: 8.0,
    ),
    4096: TileStyle(
      gradientColors: [Color(0xFFED213A), Color(0xFF93291E)],
      textColor: Colors.white,
      shadowColor: Color(0x88ED213A),
      elevation: 8.0,
    ),
    8192: TileStyle(
      gradientColors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
      textColor: Colors.white,
      shadowColor: Color(0x888E54E9),
      elevation: 8.0,
    ),
    16384: TileStyle(
      gradientColors: [Color(0xFF00F260), Color(0xFF0575E6)],
      textColor: Colors.white,
      shadowColor: Color(0x8800F260),
      elevation: 10.0,
    ),
    32768: TileStyle(
      gradientColors: [Color(0xFFFF007F), Color(0xFF7F00FF)],
      textColor: Colors.white,
      shadowColor: Color(0x88FF007F),
      elevation: 10.0,
    ),
    65536: TileStyle(
      gradientColors: [Color(0xFFFFD700), Color(0xFFFF1493)],
      textColor: Colors.white,
      shadowColor: Color(0xAAFFD700),
      elevation: 12.0,
    ),
  };

  static TileStyle getStyle(int value) {
    if (_styles.containsKey(value)) {
      return _styles[value]!;
    }
    // High values fallback with intense gradient
    return const TileStyle(
      gradientColors: [Color(0xFFFF007F), Color(0xFFFFD700)],
      textColor: Colors.white,
      shadowColor: Color(0x88FFD700),
      elevation: 10.0,
    );
  }

  static String formatNumber(int value) {
    if (value >= 1000000) {
      final m = value / 1000000;
      return m % 1 == 0 ? '${m.toInt()}M' : '${m.toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      final k = value / 1000;
      return k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

