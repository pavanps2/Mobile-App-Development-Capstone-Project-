import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../detail/detail_screen.dart';
import '../settings/settings_menu_screen.dart';
import 'add_habit_sheet.dart';

/// Home screen — the main dashboard.
///
/// Shows the Habitt logo in the app header, a "To-Do" and "Done" list of
/// habits loaded from local storage, a settings-menu icon, and a floating
/// button to add a habit. Tapping a habit opens its detail screen.
class HomeScreen extends StatelessWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Scaffold(
      appBar: AppBar(
        // Settings-menu icon (leading) -> opens the settings menu.
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Settings menu',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsMenuScreen()),
          ),
        ),
        // Logo in the header.
        title: const AppLogo(size: 30),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: const Icon(Icons.person,
                  color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.textPrimary,
        onPressed: () => showAddHabitSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final todo = state.todo;
          final done = state.done;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              const _GreetingBanner(),
              const SizedBox(height: 8),
              const _Tip(),
              const SizedBox(height: 20),
              _SectionHeader('To-Do', count: todo.length),
              const SizedBox(height: 8),
              if (todo.isEmpty)
                const _EmptyHint('No habits to do — add one!'),
              ...todo.map((h) => _HabitTile(habit: h)),
              const SizedBox(height: 20),
              _SectionHeader('Done', count: done.length),
              const SizedBox(height: 8),
              if (done.isEmpty)
                const _EmptyHint('Nothing completed yet.'),
              ...done.map((h) => _HabitTile(habit: h)),
            ],
          );
        },
      ),
    );
  }
}

class _GreetingBanner extends StatelessWidget {
  const _GreetingBanner();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Hello! 👋',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Text('💡 ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              'Tip: Tap a habit to view its details. Tap the circle to mark it done.',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader(this.title, {required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 13),
        ),
      );
}

class _HabitTile extends StatelessWidget {
  final Habit habit;
  const _HabitTile({required this.habit});

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.habitColors[habit.colorIndex % AppColors.habitColors.length];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(habitId: habit.id),
          ),
        ),
        leading: GestureDetector(
          onTap: () => AppState.instance.toggleComplete(habit.id),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: habit.completed ? AppColors.success : Colors.transparent,
              border: Border.all(
                color: habit.completed ? AppColors.success : color,
                width: 2,
              ),
            ),
            child: habit.completed
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            decoration:
                habit.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.textSecondary),
      ),
    );
  }
}
