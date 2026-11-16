import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyHighScore = 'drop_the_number_high_score';
  static const String _keyHighestTile = 'drop_the_number_highest_tile';
  static const String _keySoundEnabled = 'drop_the_number_sound_enabled';
  static const String _keyVibrationEnabled = 'drop_the_number_vibration_enabled';
  static const String _keyGamesPlayed = 'drop_the_number_games_played';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int getHighScore() {
    return _prefs?.getInt(_keyHighScore) ?? 0;
  }

  static Future<bool> setHighScore(int score) async {
    final current = getHighScore();
    if (score > current) {
      return await _prefs?.setInt(_keyHighScore, score) ?? false;
    }
    return false;
  }

  static int getHighestTile() {
    return _prefs?.getInt(_keyHighestTile) ?? 2;
  }

  static Future<bool> setHighestTile(int tile) async {
    final current = getHighestTile();
    if (tile > current) {
      return await _prefs?.setInt(_keyHighestTile, tile) ?? false;
    }
    return false;
  }

  static bool isSoundEnabled() {
    return _prefs?.getBool(_keySoundEnabled) ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  static bool isVibrationEnabled() {
    return _prefs?.getBool(_keyVibrationEnabled) ?? true;
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs?.setBool(_keyVibrationEnabled, enabled);
  }

  static int getGamesPlayed() {
    return _prefs?.getInt(_keyGamesPlayed) ?? 0;
  }

  static Future<void> incrementGamesPlayed() async {
    final count = getGamesPlayed() + 1;
    await _prefs?.setInt(_keyGamesPlayed, count);
  }
}

