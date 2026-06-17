import 'dart:convert';

/// Represents a registered user of the Habitt app.
class User {
  final String username;
  final String email;
  final String password;

  const User({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
        'password': password,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        username: map['username'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
      );

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
