import 'package:flutter/material.dart';
import '../models/game_engine.dart';
import '../utils/tile_colors.dart';
import 'tile_widget.dart';

class GameBoardWidget extends StatelessWidget {
  final GameEngine engine;
  final double width;
  final double height;

  const GameBoardWidget({
    super.key,
    required this.engine,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    const int cols = GameEngine.columnCount;
    const int rows = GameEngine.maxRows;

    // Available board dimensions
    final boardPadding = 12.0;
    final usableWidth = width - (boardPadding * 2);
    final colGap = 6.0;
    final colWidth = (usableWidth - (colGap * (cols - 1))) / cols;
    final rowGap = 6.0;
    final tileSize = colWidth;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(boardPadding),
      child: GestureDetector(
        onPanUpdate: (details) {
          final localX = details.localPosition.dx - boardPadding;
          final targetCol = (localX / (colWidth + colGap)).floor().clamp(0, cols - 1);
          engine.setHoverColumn(targetCol);
        },
        onTapUp: (details) {
          final localX = details.localPosition.dx - boardPadding;
          final targetCol = (localX / (colWidth + colGap)).floor().clamp(0, cols - 1);
          engine.onColumnTapped(targetCol);
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF334155),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Background column tracks & danger line
                Row(
                  children: List.generate(cols, (c) {
                    final isHover = engine.selectedColumn == c;
                    final isAlmostFull = engine.columns[c].length >= rows - 1;

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: colGap / 2),
                        decoration: BoxDecoration(
                          color: isHover
                              ? (isAlmostFull
                                  ? const Color(0xFFEF4444).withOpacity(0.08)
                                  : const Color(0xFF38BDF8).withOpacity(0.06))
                              : Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isHover
                                ? (isAlmostFull
                                    ? const Color(0xFFEF4444).withOpacity(0.4)
                                    : const Color(0xFF38BDF8).withOpacity(0.35))
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                // Ceiling danger line (top row limit)
                Positioned(
                  top: tileSize * 0.9,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1.5,
                    color: const Color(0xFFEF4444).withOpacity(0.25),
                  ),
                ),

                // Tiles rendered in each column from bottom up
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(cols, (c) {
                    final columnTiles = engine.columns[c];
                    final isHover = engine.selectedColumn == c;

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: colGap / 2),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Ghost preview tile at the landing spot
                            if (isHover &&
                                !engine.isDropping &&
                                !engine.isGameOver &&
                                engine.activeBooster == BoosterType.none &&
                                columnTiles.length < rows)
                              Positioned(
                                bottom: columnTiles.length * (tileSize + rowGap) + 6,
                                child: _GhostPreviewTile(
                                  value: engine.currentTileValue,
                                  size: tileSize,
                                  willMerge: columnTiles.isNotEmpty &&
                                      columnTiles.last.value == engine.currentTileValue,
                                ),
                              ),

                            // Actual stacked tiles
                            ...List.generate(columnTiles.length, (r) {
                              final tile = columnTiles[r];
                              final isTargetForBooster =
                                  engine.activeBooster != BoosterType.none;

                              return Positioned(
                                bottom: r * (tileSize + rowGap) + 6,
                                child: TileWidget(
                                  key: ValueKey(tile.id),
                                  tile: tile.copyWith(
                                    isHighlight: isTargetForBooster,
                                  ),
                                  size: tileSize,
                                  onTap: () {
                                    if (engine.activeBooster != BoosterType.none) {
                                      engine.onTileTapped(c, r);
                                    } else {
                                      engine.onColumnTapped(c);
                                    }
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostPreviewTile extends StatelessWidget {
  final int value;
  final double size;
  final bool willMerge;

  const _GhostPreviewTile({
    required this.value,
    required this.size,
    required this.willMerge,
  });

  @override
  Widget build(BuildContext context) {
    final style = TileColors.getStyle(value);
    final text = TileColors.formatNumber(value);

    return Opacity(
      opacity: willMerge ? 0.85 : 0.40,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: style.gradientColors.first.withOpacity(0.35),
          borderRadius: BorderRadius.circular(size * 0.22),
          border: Border.all(
            color: willMerge ? Colors.yellowAccent : style.gradientColors.first,
            width: willMerge ? 2.5 : 1.5,
          ),
          boxShadow: willMerge
              ? [
                  BoxShadow(
                    color: Colors.yellowAccent.withOpacity(0.5),
                    blurRadius: 8,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              if (willMerge)
                Text(
                  'MERGE!',
                  style: TextStyle(
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.w900,
                    color: Colors.yellowAccent,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
