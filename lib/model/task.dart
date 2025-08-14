import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productive_u/globel.dart';

class Task {
  String taskId;
  String userId;
  final String name;
  final String note;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String priority;
  final bool isNotify;

  Task({
    this.taskId = "",
    this.userId = "",
    required this.name,
    required this.note,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.priority,
    required this.isNotify,
  });

// Convert the Firestore data (Map) to Task obj
  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      taskId: data['taskId'],
      userId: data['userId'],
      name: data['name'],
      note: data['note'],
      startDate: timestampToDateTime(data['startDate']),
      endDate: timestampToDateTime(data['endDate']),
      status: data['status'],
      priority: data['priority'],
      isNotify: data['isNotify'],
    );
  }

  //Convert the task obj to Map (to store in firestore)
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'userId': userId,
      'name': name,
      'note': note,
      'startDate': dateTimeToTimestamp(startDate),
      'endDate': dateTimeToTimestamp(endDate),
      'status': status,
      'priority': priority,
      'isNotify': isNotify,
    };
  }
}
