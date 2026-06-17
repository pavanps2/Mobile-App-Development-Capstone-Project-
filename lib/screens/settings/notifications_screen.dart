import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../services/notification_service.dart';
import '../../services/storage_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

/// Notifications screen.
///
/// Configures app reminders: a master "Enable All Reminders" switch, the
/// daily reminder time, a per-habit reminder list, and a "Send Test
/// Notification" button that fires an immediate local notification (used for
/// the notification-alert evidence).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _storage = StorageService.instance;
  final _notifications = NotificationService.instance;

  Future<void> _sendTest() async {
    final granted = await _notifications.requestPermission();
    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Notification permission was denied.')),
        );
      }
      return;
    }
    await _notifications.showTestNotification();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification sent!')),
      );
    }
  }

  Future<void> _toggleHabitReminder(Habit habit, bool value) async {
    habit.reminderEnabled = value;
    AppState.instance.updateHabit(habit);

    if (value && _storage.remindersEnabled) {
      final parts = habit.reminderTime.split(':');
      await _notifications.scheduleDailyReminder(
        id: habit.id.hashCode,
        habitName: habit.name,
        time: TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
        ),
      );
    } else {
      await _notifications.cancel(habit.id.hashCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Notifications'),
      ),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final habits = AppState.instance.habits;
          return ListView(
            children: [
              // Master toggle — "Enable All Reminders".
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active,
                    color: AppColors.primary),
                activeColor: AppColors.primary,
                title: const Text('Enable All Reminders'),
                subtitle: Text(_storage.remindersEnabled
                    ? 'Reminders are active'
                    : 'Reminders are off'),
                value: _storage.remindersEnabled,
                onChanged: (v) =>
                    setState(() => _storage.setRemindersEnabled(v)),
              ),
              ListTile(
                leading: const Icon(Icons.access_time,
                    color: AppColors.primary),
                title: const Text('Daily Reminder Time'),
                subtitle: const Text('Applies to all habits'),
                trailing: Text(_storage.reminderTime,
                    style: const TextStyle(color: AppColors.textSecondary)),
                onTap: _pickTime,
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  'HABIT REMINDERS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 1,
                  ),
                ),
              ),

              ...habits.map((habit) {
                final color = AppColors.habitColors[
                    habit.colorIndex % AppColors.habitColors.length];
                return SwitchListTile(
                  secondary: CircleAvatar(
                    radius: 14,
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(Icons.circle, size: 12, color: color),
                  ),
                  activeColor: AppColors.primary,
                  title: Text(habit.name),
                  subtitle: Text(
                    habit.reminderEnabled
                        ? 'Reminder at ${habit.reminderTime}'
                        : 'No reminder set',
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: habit.reminderEnabled,
                  onChanged: (v) => _toggleHabitReminder(habit, v),
                );
              }),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: _sendTest,
                  icon: const Icon(Icons.notifications),
                  label: const Text('Send Test Notification'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Notification permission is required to receive reminders.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickTime() async {
    final parts = _storage.reminderTime.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 8,
        minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
      ),
    );
    if (picked != null) {
      final value =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() => _storage.setReminderTime(value));
    }
  }
}
