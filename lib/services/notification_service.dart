import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local-notification layer for Habitt.
///
/// Wraps [FlutterLocalNotificationsPlugin] to:
///  * request notification permission,
///  * fire an immediate test notification (the "test notification" evidence),
///  * schedule a daily habit reminder at a chosen time.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    'habitt_reminders',
    'Habit Reminders',
    channelDescription: 'Daily reminders to complete your habits',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const NotificationDetails _details = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  bool _initialised = false;

  Future<void> init() async {
    if (_initialised) return;

    tz.initializeTimeZones();

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);
    _initialised = true;
  }

  /// Asks the OS for permission to post notifications.
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    bool granted = true;
    if (android != null) {
      granted =
          await android.requestNotificationsPermission() ?? true;
    }
    if (ios != null) {
      granted = await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
    }
    return granted;
  }

  /// Fires an immediate notification — used for the "test notification" button.
  Future<void> showTestNotification() async {
    await _plugin.show(
      0,
      'Habitt Reminder ✅',
      'This is a test notification. Reminders are working!',
      _details,
    );
  }

  /// Schedules a daily reminder for [habitName] at [time].
  Future<void> scheduleDailyReminder({
    required int id,
    required String habitName,
    required TimeOfDay time,
  }) async {
    await _plugin.zonedSchedule(
      id,
      'Time for your habit',
      "Don't forget to complete: $habitName",
      _nextInstanceOf(time),
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();

  tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
