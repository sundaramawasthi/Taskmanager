import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;
  final String tag;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.tag,
    this.isDone = false,
  });

  /// Converts a Task object into a map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'priority': priority,
      'tag': tag,
      'isDone': isDone,
    };
  }

  /// Creates a Task object from Firestore data
  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : DateTime.now(),

      priority: map['priority'] ?? 'Low',
      tag: map['tag'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  /// Returns a copy of this task with overridden fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? priority,
    String? tag,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      tag: tag ?? this.tag,
      isDone: isDone ?? this.isDone,
    );
  }
}
