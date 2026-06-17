import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import '../models/user.dart';

/// Local-storage layer for Habitt.
///
/// Uses [SharedPreferences] to persist the registered user, the logged-in
/// session, the user's habits and the app settings on the device. This is the
/// app's persistence / local-storage implementation: everything written here
/// survives an app restart.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _kUser = 'habitt_user';
  static const _kLoggedIn = 'habitt_logged_in';
  static const _kHabits = 'habitt_habits';
  static const _kRemindersEnabled = 'habitt_reminders_enabled';
  static const _kReminderTime = 'habitt_reminder_time';
  static const _kDarkMode = 'habitt_dark_mode';

  late SharedPreferences _prefs;

  /// Must be called once during app start-up.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // User account
  // ---------------------------------------------------------------------------
  Future<void> saveUser(User user) async {
    await _prefs.setString(_kUser, user.toJson());
  }

  User? getUser() {
    final raw = _prefs.getString(_kUser);
    if (raw == null) return null;
    return User.fromJson(raw);
  }

  bool get hasAccount => _prefs.getString(_kUser) != null;

  // ---------------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------------
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_kLoggedIn, value);
  }

  bool get isLoggedIn => _prefs.getBool(_kLoggedIn) ?? false;

  // ---------------------------------------------------------------------------
  // Habits
  // ---------------------------------------------------------------------------
  Future<void> saveHabits(List<Habit> habits) async {
    await _prefs.setString(_kHabits, Habit.encodeList(habits));
  }

  List<Habit> getHabits() {
    final raw = _prefs.getString(_kHabits);
    if (raw == null || raw.isEmpty) return [];
    return Habit.decodeList(raw);
  }

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------
  Future<void> setRemindersEnabled(bool value) async =>
      _prefs.setBool(_kRemindersEnabled, value);
  bool get remindersEnabled => _prefs.getBool(_kRemindersEnabled) ?? true;

  Future<void> setReminderTime(String value) async =>
      _prefs.setString(_kReminderTime, value);
  String get reminderTime => _prefs.getString(_kReminderTime) ?? '08:00';

  Future<void> setDarkMode(bool value) async =>
      _prefs.setBool(_kDarkMode, value);
  bool get darkMode => _prefs.getBool(_kDarkMode) ?? false;

  /// Raw snapshot of everything in local storage — handy for the
  /// "data stored in local storage" evidence screen.
  Map<String, Object?> debugSnapshot() {
    return {
      for (final key in _prefs.getKeys()) key: _prefs.get(key),
    };
  }

  Future<void> clearAll() async => _prefs.clear();
}
