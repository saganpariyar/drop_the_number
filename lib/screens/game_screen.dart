import 'package:flutter/material.dart';
import '../models/game_engine.dart';
import '../widgets/top_bar_widget.dart';
import '../widgets/dropper_widget.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/booster_bar_widget.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameEngine _engine;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _engine = GameEngine();
    _engine.addListener(_onEngineUpdate);
  }

  @override
  void dispose() {
    _engine.removeListener(_onEngineUpdate);
    _engine.dispose();
    super.dispose();
  }

  void _onEngineUpdate() {
    if (_engine.isGameOver && !_dialogOpen) {
      _dialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => GameOverDialog(
            engine: _engine,
            onPlayAgain: () {
              Navigator.of(context).pop();
              _dialogOpen = false;
              _engine.resetGame();
            },
          ),
        ).then((_) => _dialogOpen = false);
      });
    }
  }

  void _showPauseDialog() {
    if (_dialogOpen) return;
    _dialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PauseDialog(
        onResume: () {
          Navigator.of(context).pop();
          _dialogOpen = false;
        },
        onRestart: () {
          Navigator.of(context).pop();
          _dialogOpen = false;
          _engine.resetGame();
        },
      ),
    ).then((_) => _dialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Deep dark sleek background
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _engine,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final totalHeight = constraints.maxHeight;

                // Column calculation for board
                final usableColWidth = (totalWidth - 24) / GameEngine.columnCount;
                final tileSize = usableColWidth - 6;

                return Column(
                  children: [
                    // Top header stats
                    TopBarWidget(
                      engine: _engine,
                      onPause: _showPauseDialog,
                      onRestart: () => _engine.resetGame(),
                    ),

                    // Dropper lane indicator
                    DropperWidget(
                      engine: _engine,
                      columnWidth: usableColWidth,
                      tileSize: tileSize,
                    ),

                    // Main playfield grid
                    Expanded(
                      child: Center(
                        child: GameBoardWidget(
                          engine: _engine,
                          width: totalWidth,
                          height: totalHeight * 0.64,
                        ),
                      ),
                    ),

                    // Bottom booster bar
                    BoosterBarWidget(engine: _engine),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

