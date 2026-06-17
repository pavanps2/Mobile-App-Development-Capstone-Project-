import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

/// Settings menu (the profile/drawer-style screen).
///
/// Opened from the menu icon on the home app-bar. Shows the user's profile
/// header, the menu items (Personal Info, Notifications, Settings), a
/// "Daily Quote" pulled from the external API, and Sign Out.
class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = StorageService.instance.getUser();
    final username = user?.username ?? 'Guest';
    final email = user?.email ?? '';
    final initials = username.isNotEmpty
        ? username.trim().substring(0, 1).toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Profile header with gradient ---
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Settings Menu',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 1.2),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),

            // --- Menu items ---
            _MenuItem(
              icon: Icons.person_outline,
              label: 'Personal Info',
              onTap: () => _showProfile(context, username, email),
            ),
            _MenuItem(
              icon: Icons.notifications_none,
              label: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationsScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),

            const SizedBox(height: 8),

            // --- Daily Quote (fetched from the external API) ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _DailyQuoteCard(),
            ),

            const Spacer(),

            // --- Sign out ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () {
                  AuthService.instance.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.route,
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.danger),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile(BuildContext context, String username, String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Personal Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username'),
            const SizedBox(height: 8),
            Text('Email: $email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

/// Shows a motivational quote fetched from the external API.
class _DailyQuoteCard extends StatefulWidget {
  const _DailyQuoteCard();

  @override
  State<_DailyQuoteCard> createState() => _DailyQuoteCardState();
}

class _DailyQuoteCardState extends State<_DailyQuoteCard> {
  late Future<Quote> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.instance.fetchRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: FutureBuilder<Quote>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Loading daily quote…'),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Text(
              'Could not load the daily quote. Check your connection.',
              style: TextStyle(color: AppColors.textSecondary),
            );
          }
          final quote = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔖 Daily Quote',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"${quote.text}"',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '— ${quote.author}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }
}
