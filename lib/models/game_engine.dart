import 'dart:math';
import 'package:flutter/foundation.dart';
import 'game_tile.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';

enum BoosterType {
  none,
  hammer, // Smash single block
  bomb, // Clear column
  doubler, // Double a block value
}

class GameEngine extends ChangeNotifier {
  static const int columnCount = 5;
  static const int maxRows = 7;

  final Random _random = Random();
  int _idCounter = 0;

  late List<List<GameTile>> columns;

  int _score = 0;
  int get score => _score;

  int _highScore = 0;
  int get highScore => _highScore;

  int _highestTile = 2;
  int get highestTile => _highestTile;

  late int currentTileValue;
  late int nextTileValue;

  int _selectedColumn = 2; // Hovered column (center default)
  int get selectedColumn => _selectedColumn;

  bool _isDropping = false;
  bool get isDropping => _isDropping;

  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  int _comboCount = 0;
  int get comboCount => _comboCount;

  String? _comboMessage;
  String? get comboMessage => _comboMessage;

  BoosterType _activeBooster = BoosterType.none;
  BoosterType get activeBooster => _activeBooster;

  int hammerCount = 3;
  int swapCount = 3;
  int bombCount = 2;
  int doublerCount = 2;

  GameEngine() {
    _highScore = StorageService.getHighScore();
    _highestTile = StorageService.getHighestTile();
    resetGame();
  }

  String _nextId() => 'tile_${++_idCounter}';

  void resetGame() {
    columns = List.generate(columnCount, (_) => []);
    _score = 0;
    _comboCount = 0;
    _comboMessage = null;
    _isGameOver = false;
    _isDropping = false;
    _activeBooster = BoosterType.none;
    _selectedColumn = 2;

    _highScore = StorageService.getHighScore();
    _highestTile = StorageService.getHighestTile();

    currentTileValue = _generateSpawnValue();
    nextTileValue = _generateSpawnValue();

    // Seed a couple of initial bottom blocks to give a lively starting board
    _seedInitialBoard();

    notifyListeners();
  }

  void _seedInitialBoard() {
    final values = [2, 4, 8, 2, 4];
    for (int c = 0; c < columnCount; c++) {
      if (_random.nextBool()) {
        columns[c].add(GameTile(id: _nextId(), value: values[c % values.length]));
      }
    }
  }

  int _generateSpawnValue() {
    // Generate power of 2 based on highest tile unlocked
    final availablePowers = <int>[1, 2, 3]; // 2, 4, 8
    if (_highestTile >= 64) availablePowers.add(4); // 16
    if (_highestTile >= 256) availablePowers.add(5); // 32
    if (_highestTile >= 1024) availablePowers.add(6); // 64
    if (_highestTile >= 4096) availablePowers.add(7); // 128

    // Weighted selection: lower values are more frequent
    final weights = <double>[];
    for (int i = 0; i < availablePowers.length; i++) {
      weights.add(1.0 / (i + 1));
    }
    final totalWeight = weights.reduce((a, b) => a + b);
    double r = _random.nextDouble() * totalWeight;

    for (int i = 0; i < availablePowers.length; i++) {
      r -= weights[i];
      if (r <= 0) {
        return 1 << availablePowers[i];
      }
    }
    return 2;
  }

  void setHoverColumn(int col) {
    if (col < 0 || col >= columnCount) return;
    if (_selectedColumn != col) {
      _selectedColumn = col;
      notifyListeners();
    }
  }

  Future<void> dropCurrentTile() async {
    if (_isDropping || _isGameOver) return;
    if (_activeBooster != BoosterType.none) {
      _activeBooster = BoosterType.none;
      notifyListeners();
      return;
    }

    final col = _selectedColumn;
    if (columns[col].length >= maxRows) {
      // Column is full: check if player can merge directly into the top tile
      final topTile = columns[col].last;
      if (topTile.value != currentTileValue) {
        // Can't place here
        AudioService.onBigTile();
        return;
      }
    }

    _isDropping = true;
    _comboCount = 0;
    _comboMessage = null;

    final newTile = GameTile(
      id: _nextId(),
      value: currentTileValue,
      isNew: true,
    );
    columns[col].add(newTile);
    AudioService.onDrop();
    notifyListeners();

    // Prepare next tiles
    currentTileValue = nextTileValue;
    nextTileValue = _generateSpawnValue();

    // Short delay for drop animation feel
    await Future.delayed(const Duration(milliseconds: 120));

    // Resolve cascading merges
    await _resolveBoardCascade(col);

    _clearTileAnimationFlags();

    // Check game over
    _checkGameOver();

    _isDropping = false;
    notifyListeners();
  }

  Future<void> _resolveBoardCascade(int startCol) async {
    bool hasMerged;
    int cascadeRound = 0;

    do {
      hasMerged = false;
      cascadeRound++;

      // Scan columns from bottom to top for merges
      for (int c = 0; c < columnCount; c++) {
        for (int r = 0; r < columns[c].length; r++) {
          final tile = columns[c][r];
          final val = tile.value;

          // Check identical neighbor below
          final bool matchBelow = (r > 0 && columns[c][r - 1].value == val);

          // Check left neighbor
          final bool matchLeft = (c > 0 &&
              columns[c - 1].length > r &&
              columns[c - 1][r].value == val);

          // Check right neighbor
          final bool matchRight = (c < columnCount - 1 &&
              columns[c + 1].length > r &&
              columns[c + 1][r].value == val);

          if (matchBelow || matchLeft || matchRight) {
            hasMerged = true;
            _comboCount++;

            // Count how many matched neighbors
            int mergeFactor = 1;
            final List<void Function()> removals = [];

            if (matchBelow) {
              mergeFactor *= 2;
              removals.add(() => columns[c].removeAt(r - 1));
            }
            if (matchLeft) {
              mergeFactor *= 2;
              removals.add(() => columns[c - 1].removeAt(r));
            }
            if (matchRight) {
              mergeFactor *= 2;
              removals.add(() => columns[c + 1].removeAt(r));
            }

            // Execute removals
            // Note: sort or execute safely so indices don't shift unpredictably
            if (matchRight) columns[c + 1].removeAt(r);
            if (matchLeft) columns[c - 1].removeAt(r);
            if (matchBelow) {
              columns[c].removeAt(r - 1);
              // Because tile below was removed, our current tile shifted down to r - 1
              r = max(0, r - 1);
            }

            // Upgrade current tile
            final targetTile = columns[c][r];
            targetTile.value = targetTile.value * mergeFactor;
            targetTile.isMerged = true;

            // Score calculation
            final earned = targetTile.value * _comboCount;
            _score += earned;
            if (_score > _highScore) {
              _highScore = _score;
              StorageService.setHighScore(_highScore);
            }

            if (targetTile.value > _highestTile) {
              _highestTile = targetTile.value;
              StorageService.setHighestTile(_highestTile);
              AudioService.onBigTile();
            }

            // Audio & Haptic
            AudioService.onMerge(combo: _comboCount);

            // Combo messages
            if (_comboCount >= 4) {
              _comboMessage = '🔥 MEGA MERGE x$_comboCount! 🔥';
            } else if (_comboCount == 3) {
              _comboMessage = '⚡ COMBO x3! ⚡';
            } else if (_comboCount == 2) {
              _comboMessage = '✨ COMBO x2! ✨';
            } else if (targetTile.value >= 2048) {
              _comboMessage = '👑 2048 MASTER! 👑';
            }

            notifyListeners();
            await Future.delayed(const Duration(milliseconds: 140));

            // Break inner loop to rescan board from scratch after gravity settles
            break;
          }
        }
        if (hasMerged) break;
      }
    } while (hasMerged && cascadeRound < 25);
  }

  void _clearTileAnimationFlags() {
    for (final col in columns) {
      for (final tile in col) {
        tile.isNew = false;
        tile.isMerged = false;
        tile.isHighlight = false;
      }
    }
  }

  void _checkGameOver() {
    // If every column is full to maxRows, or any column exceeds maxRows
    bool full = true;
    for (int c = 0; c < columnCount; c++) {
      if (columns[c].length < maxRows) {
        full = false;
        break;
      }
    }

    if (full) {
      // Check if ANY adjacent pair on the board can still merge
      bool canStillMerge = false;
      for (int c = 0; c < columnCount; c++) {
        for (int r = 0; r < columns[c].length; r++) {
          final v = columns[c][r].value;
          if (r + 1 < columns[c].length && columns[c][r + 1].value == v) {
            canStillMerge = true;
            break;
          }
          if (c + 1 < columnCount &&
              columns[c + 1].length > r &&
              columns[c + 1][r].value == v) {
            canStillMerge = true;
            break;
          }
        }
        if (canStillMerge) break;
      }

      if (!canStillMerge) {
        _isGameOver = true;
        AudioService.onGameOver();
        StorageService.incrementGamesPlayed();
      }
    }
  }

  // ==================== BOOSTERS ====================

  void toggleBooster(BoosterType type) {
    if (_isDropping || _isGameOver) return;
    if (_activeBooster == type) {
      _activeBooster = BoosterType.none;
    } else {
      // Check if remaining charges
      if (type == BoosterType.hammer && hammerCount <= 0) return;
      if (type == BoosterType.bomb && bombCount <= 0) return;
      if (type == BoosterType.doubler && doublerCount <= 0) return;
      _activeBooster = type;
    }
    notifyListeners();
  }

  void useSwap() {
    if (_isDropping || _isGameOver || swapCount <= 0) return;
    final temp = currentTileValue;
    currentTileValue = nextTileValue;
    nextTileValue = temp;
    swapCount--;
    AudioService.onBoosterUse();
    notifyListeners();
  }

  Future<void> onTileTapped(int colIndex, int rowIndex) async {
    if (_isDropping || _isGameOver) return;

    if (_activeBooster == BoosterType.hammer && hammerCount > 0) {
      if (colIndex >= 0 &&
          colIndex < columnCount &&
          rowIndex >= 0 &&
          rowIndex < columns[colIndex].length) {
        columns[colIndex].removeAt(rowIndex);
        hammerCount--;
        _activeBooster = BoosterType.none;
        AudioService.onBoosterUse();
        notifyListeners();
        await _resolveBoardCascade(colIndex);
        _clearTileAnimationFlags();
        _checkGameOver();
        notifyListeners();
      }
    } else if (_activeBooster == BoosterType.doubler && doublerCount > 0) {
      if (colIndex >= 0 &&
          colIndex < columnCount &&
          rowIndex >= 0 &&
          rowIndex < columns[colIndex].length) {
        final tile = columns[colIndex][rowIndex];
        tile.value *= 2;
        tile.isMerged = true;
        doublerCount--;
        _activeBooster = BoosterType.none;
        AudioService.onBoosterUse();
        notifyListeners();
        await _resolveBoardCascade(colIndex);
        _clearTileAnimationFlags();
        _checkGameOver();
        notifyListeners();
      }
    } else if (_activeBooster == BoosterType.bomb && bombCount > 0) {
      if (colIndex >= 0 && colIndex < columnCount) {
        columns[colIndex].clear();
        bombCount--;
        _activeBooster = BoosterType.none;
        AudioService.onBoosterUse();
        notifyListeners();
      }
    }
  }

  void onColumnTapped(int colIndex) {
    if (_activeBooster == BoosterType.bomb && bombCount > 0) {
      onTileTapped(colIndex, 0);
    } else if (_activeBooster == BoosterType.none) {
      setHoverColumn(colIndex);
      dropCurrentTile();
    }
  }
}

