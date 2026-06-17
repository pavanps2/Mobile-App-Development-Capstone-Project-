import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise the local-storage and notification layers before the UI loads.
  await StorageService.instance.init();
  await NotificationService.instance.init();
  AppState.instance.load();

  runApp(const HabittApp());
}

class HabittApp extends StatelessWidget {
  const HabittApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = StorageService.instance.isLoggedIn;

    return MaterialApp(
      title: 'Habitt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: loggedIn ? HomeScreen.route : LoginScreen.route,
      routes: {
        LoginScreen.route: (_) => const LoginScreen(),
        SignupScreen.route: (_) => const SignupScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
      },
    );
  }
}
