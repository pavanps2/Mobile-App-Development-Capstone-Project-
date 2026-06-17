import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/storage_service.dart';

/// Holds the in-memory habit list and keeps it in sync with local storage.
///
/// A lightweight [ChangeNotifier] used via [AnimatedBuilder]/[ListenableBuilder]
/// in the screens. Every mutation immediately persists to [StorageService] so
/// the data survives an app restart (local-storage requirement).
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  final StorageService _storage = StorageService.instance;
  List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);
  List<Habit> get todo => _habits.where((h) => !h.completed).toList();
  List<Habit> get done => _habits.where((h) => h.completed).toList();

  /// Loads habits from local storage; seeds a starter list on first run.
  void load() {
    _habits = _storage.getHabits();
    if (_habits.isEmpty) {
      _habits = _seedHabits();
      _persist();
    }
    notifyListeners();
  }

  List<Habit> _seedHabits() => [
        Habit(id: _id(), name: 'Morning Exercise', colorIndex: 0),
        Habit(id: _id(), name: 'Read 20 pages', colorIndex: 2),
        Habit(id: _id(), name: 'Meditate', colorIndex: 1),
        Habit(
            id: _id(),
            name: 'Drink Water',
            colorIndex: 3,
            completed: true),
      ];

  Habit? byId(String id) {
    try {
      return _habits.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  void addHabit(String name, {int colorIndex = 0, String description = ''}) {
    _habits.add(Habit(
      id: _id(),
      name: name,
      colorIndex: colorIndex,
      description: description,
    ));
    _persist();
    notifyListeners();
  }

  void updateHabit(Habit habit) {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      _persist();
      notifyListeners();
    }
  }

  void toggleComplete(String id) {
    final habit = byId(id);
    if (habit == null) return;
    habit.completed = !habit.completed;
    _persist();
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    _persist();
    notifyListeners();
  }

  void clearCompleted() {
    _habits.removeWhere((h) => h.completed);
    _persist();
    notifyListeners();
  }

  void _persist() => _storage.saveHabits(_habits);

  // Monotonic counter guarantees unique ids even when several habits are
  // created within the same microsecond (e.g. the seed list).
  int _counter = 0;
  String _id() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_counter++}';
}
