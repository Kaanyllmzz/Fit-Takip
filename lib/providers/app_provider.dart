import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int _dailyWaterGoal = 8;
  int _currentWaterCount = 0;

  int get dailyWaterGoal => _dailyWaterGoal;
  int get currentWaterCount => _currentWaterCount;

  void incrementWater() {
    if (_currentWaterCount < _dailyWaterGoal) {
      _currentWaterCount++;
      notifyListeners();
    }
  }

  void decrementWater() {
    if (_currentWaterCount > 0) {
      _currentWaterCount--;
      notifyListeners();
    }
  }

  void resetWater() {
    _currentWaterCount = 0;
    notifyListeners();
  }

  void setDailyWaterGoal(int value) {
    _dailyWaterGoal = value;
    notifyListeners();
  }
}
