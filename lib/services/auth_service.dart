import '../models/user.dart';
import 'storage_service.dart';

/// Result of an auth attempt — carries a human-readable error on failure.
class AuthResult {
  final bool success;
  final String? error;
  const AuthResult.ok()
      : success = true,
        error = null;
  const AuthResult.fail(this.error) : success = false;
}

/// Handles sign-up and login against the locally stored account.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final StorageService _storage = StorageService.instance;

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  /// Registers a new account. Validates the three required fields and stores
  /// the user in local storage. Returns an [AuthResult] describing any error
  /// (these messages drive the sign-up error evidence).
  AuthResult signUp({
    required String username,
    required String email,
    required String password,
  }) {
    if (username.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {
      return const AuthResult.fail('All fields are required.');
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return const AuthResult.fail('Please enter a valid email address.');
    }
    if (password.length < 6) {
      return const AuthResult.fail(
          'Password must be at least 6 characters long.');
    }
    if (_storage.hasAccount &&
        _storage.getUser()!.email.toLowerCase() ==
            email.trim().toLowerCase()) {
      return const AuthResult.fail(
          'An account with this email already exists.');
    }

    _storage.saveUser(User(
      username: username.trim(),
      email: email.trim(),
      password: password,
    ));
    _storage.setLoggedIn(true);
    return const AuthResult.ok();
  }

  /// Authenticates an existing account. Returns an [AuthResult] with an error
  /// message on failure (drives the login error evidence).
  AuthResult login({required String email, required String password}) {
    if (email.trim().isEmpty || password.isEmpty) {
      return const AuthResult.fail('Email and password are required.');
    }
    final user = _storage.getUser();
    if (user == null) {
      return const AuthResult.fail(
          'No account found. Please sign up first.');
    }
    if (user.email.toLowerCase() != email.trim().toLowerCase() ||
        user.password != password) {
      return const AuthResult.fail('Invalid email or password.');
    }
    _storage.setLoggedIn(true);
    return const AuthResult.ok();
  }

  void logout() => _storage.setLoggedIn(false);
}
