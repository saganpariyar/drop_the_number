import 'package:flutter/services.dart';
import 'storage_service.dart';

class AudioService {
  static void onDrop() {
    if (StorageService.isVibrationEnabled()) {
      HapticFeedback.lightImpact();
    }
    if (StorageService.isSoundEnabled()) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  static void onMerge({int combo = 1}) {
    if (StorageService.isVibrationEnabled()) {
      if (combo > 2) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.mediumImpact();
      }
    }
    if (StorageService.isSoundEnabled()) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  static void onBigTile() {
    if (StorageService.isVibrationEnabled()) {
      HapticFeedback.heavyImpact();
    }
    if (StorageService.isSoundEnabled()) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  static void onBoosterUse() {
    if (StorageService.isVibrationEnabled()) {
      HapticFeedback.mediumImpact();
    }
    if (StorageService.isSoundEnabled()) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  static void onGameOver() {
    if (StorageService.isVibrationEnabled()) {
      HapticFeedback.heavyImpact();
    }
    if (StorageService.isSoundEnabled()) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  static void onClick() {
    if (StorageService.isVibrationEnabled()) {
      HapticFeedback.selectionClick();
    }
  }
}

