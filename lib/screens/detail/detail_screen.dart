import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../services/notification_service.dart';
import '../../services/storage_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

/// Detail screen for a single habit.
///
/// Reached by tapping a habit on the home screen. Displays the selected
/// item's information (name, status, accent colour, reminder) and lets the
/// user edit the name, toggle completion, set a per-habit reminder, or delete
/// the habit. All changes persist to local storage via [AppState].
class DetailScreen extends StatefulWidget {
  final String habitId;
  const DetailScreen({super.key, required this.habitId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController _nameController;

  Habit get _habit =>
      AppState.instance.byId(widget.habitId) ??
      Habit(id: widget.habitId, name: 'Unknown');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _habit.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final h = _habit;
    h.name = _nameController.text.trim().isEmpty
        ? h.name
        : _nameController.text.trim();
    AppState.instance.updateHabit(h);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit saved')),
    );
  }

  Future<void> _toggleReminder(bool value) async {
    final h = _habit;
    h.reminderEnabled = value;
    AppState.instance.updateHabit(h);

    if (value && StorageService.instance.remindersEnabled) {
      final parts = h.reminderTime.split(':');
      await NotificationService.instance.scheduleDailyReminder(
        id: h.id.hashCode,
        habitName: h.name,
        time: TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
        ),
      );
    } else {
      await NotificationService.instance.cancel(h.id.hashCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final habit = _habit;
        final color = AppColors
            .habitColors[habit.colorIndex % AppColors.habitColors.length];

        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: const Text('Habit Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.danger),
                tooltip: 'Delete habit',
                onPressed: () {
                  AppState.instance.deleteHabit(habit.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header card with the habit's accent colour + status.
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                      child: const Icon(Icons.flag_outlined,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            habit.completed ? 'Completed ✅' : 'In progress',
                            style: TextStyle(
                              color: habit.completed
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Editable name.
              const _Label('Habit Name'),
              TextField(controller: _nameController),
              const SizedBox(height: 20),

              // Info rows.
              _InfoRow(
                icon: Icons.palette_outlined,
                label: 'Color',
                trailing: Container(
                  width: 22,
                  height: 22,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ),
              _InfoRow(
                icon: Icons.check_circle_outline,
                label: 'Status',
                value: habit.completed ? 'Done' : 'To-Do',
              ),
              _InfoRow(
                icon: Icons.access_time,
                label: 'Reminder Time',
                value: habit.reminderTime,
              ),
              const SizedBox(height: 8),

              // Per-habit reminder toggle.
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: const Text('Daily Reminder'),
                subtitle: Text(
                  habit.reminderEnabled
                      ? 'Reminder set for ${habit.reminderTime}'
                      : 'No reminder set',
                  style: const TextStyle(fontSize: 12),
                ),
                value: habit.reminderEnabled,
                onChanged: _toggleReminder,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          AppState.instance.toggleComplete(habit.id),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                          habit.completed ? 'Mark To-Do' : 'Mark Done'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save Details'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 2),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  const _InfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (value != null)
            Text(value!,
                style: const TextStyle(color: AppColors.textSecondary)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
