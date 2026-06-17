import 'package:flutter/material.dart';

import '../../services/storage_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'notifications_screen.dart';
import 'storage_debug_screen.dart';

/// Settings screen.
///
/// Grouped settings: Notifications (enable + reminder time + manage),
/// Appearance, Data (clear completed, view local storage, reset), and About
/// (app version + the external API source). Settings persist to local storage.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = StorageService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // --- Notifications ---
          const _SectionLabel('NOTIFICATIONS'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined,
                color: AppColors.primary),
            activeColor: AppColors.primary,
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive daily reminders'),
            value: _storage.remindersEnabled,
            onChanged: (v) {
              setState(() => _storage.setRemindersEnabled(v));
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: AppColors.primary),
            title: const Text('Reminder Time'),
            subtitle: Text(_storage.reminderTime),
            trailing: Text(_storage.reminderTime,
                style: const TextStyle(color: AppColors.textSecondary)),
            onTap: _pickTime,
          ),
          ListTile(
            leading: const Icon(Icons.tune, color: AppColors.primary),
            title: const Text('Manage Habit Reminders'),
            subtitle: const Text('Toggle per habit'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const NotificationsScreen()),
            ),
          ),

          // --- Appearance ---
          const _SectionLabel('APPEARANCE'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined,
                color: AppColors.primary),
            activeColor: AppColors.primary,
            title: const Text('Dark Mode'),
            subtitle: const Text('Coming soon'),
            value: _storage.darkMode,
            onChanged: (v) => setState(() => _storage.setDarkMode(v)),
          ),

          // --- Data ---
          const _SectionLabel('DATA'),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined,
                color: AppColors.primary),
            title: const Text('Clear Completed Habits'),
            subtitle: const Text('Remove done habits'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppState.instance.clearCompleted();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completed habits cleared')),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.storage_outlined, color: AppColors.primary),
            title: const Text('View Local Storage'),
            subtitle: const Text('Inspect persisted data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const StorageDebugScreen()),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.restart_alt, color: AppColors.danger),
            title: const Text('Reset All Data'),
            subtitle: const Text('Delete everything'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _confirmReset,
          ),

          // --- About ---
          const _SectionLabel('ABOUT'),
          const ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.primary),
            title: Text('Habitt v1.0.0'),
            subtitle: Text('Flutter · Dart'),
          ),
          const ListTile(
            leading: Icon(Icons.api, color: AppColors.primary),
            title: Text('Daily Quote API'),
            subtitle: Text('dummyjson.com/quotes'),
          ),
          const SizedBox(height: 24),
        ],
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

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset all data?'),
        content: const Text(
            'This clears your account, habits and settings from local storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _storage.clearAll();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data reset')),
                );
                setState(() {});
              }
            },
            child: const Text('Reset',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ),
      );
}
