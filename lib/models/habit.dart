import 'dart:convert';

/// A single habit tracked by the user.
class Habit {
  final String id;
  String name;
  String description;
  int colorIndex;
  bool completed;
  bool reminderEnabled;
  String reminderTime; // "HH:mm"

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.colorIndex = 0,
    this.completed = false,
    this.reminderEnabled = false,
    this.reminderTime = '08:00',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'colorIndex': colorIndex,
        'completed': completed,
        'reminderEnabled': reminderEnabled,
        'reminderTime': reminderTime,
      };

  factory Habit.fromMap(Map<String, dynamic> map) => Habit(
        id: map['id'] as String,
        name: map['name'] as String,
        description: (map['description'] ?? '') as String,
        colorIndex: (map['colorIndex'] ?? 0) as int,
        completed: (map['completed'] ?? false) as bool,
        reminderEnabled: (map['reminderEnabled'] ?? false) as bool,
        reminderTime: (map['reminderTime'] ?? '08:00') as String,
      );

  static String encodeList(List<Habit> habits) =>
      jsonEncode(habits.map((h) => h.toMap()).toList());

  static List<Habit> decodeList(String source) =>
      (jsonDecode(source) as List<dynamic>)
          .map((e) => Habit.fromMap(e as Map<String, dynamic>))
          .toList();
}
