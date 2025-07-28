import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static const String _databaseUrl = 'https://to-do-flutter-d9f58-default-rtdb.asia-southeast1.firebasedatabase.app';
  
  late final DatabaseReference _db;

  DatabaseService() {
    _db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: _databaseUrl,
    ).ref();
  }

  Future<void> addTask(String taskName, String userId, DateTime completionDate) async {
    try {
      await _db.child('tasks').child(userId).push().set({
        'taskName': taskName,
        'isCompleted': false,
        'createdAt': ServerValue.timestamp,
        'completionDate': completionDate.millisecondsSinceEpoch, // Store as int
      });
    } catch (e) {
      debugPrint('Error adding task: $e');
      throw Exception('Failed to add task: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getTasks(String userId) {
    return _db.child('tasks/$userId').onValue.map((event) {
      final snapshotValue = event.snapshot.value;

      if (snapshotValue == null) return [];

      // Handle different data types from Firebase
      final data = snapshotValue is Map ? Map<String, dynamic>.from(snapshotValue) : {};

      return data.entries.map((entry) {
        final value = entry.value;
        if (value is! Map) return null;

        final taskMap = Map<String, dynamic>.from(value);
        
        // Safely handle completionDate conversion
        dynamic completionDateMillis = taskMap['completionDate'];
        DateTime? completionDate;
        
        if (completionDateMillis != null) {
          if (completionDateMillis is int) {
            completionDate = DateTime.fromMillisecondsSinceEpoch(completionDateMillis).toLocal();
          } else if (completionDateMillis is String) {
            completionDate = DateTime.tryParse(completionDateMillis);
          }
        }

        return {
          'id': entry.key,
          'taskName': taskMap['taskName'] ?? 'Unnamed Task',
          'isCompleted': taskMap['isCompleted'] ?? false,
          'createdAt': taskMap['createdAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(taskMap['createdAt']).toLocal()
              : null,
          'completionDate': completionDate,
        };
      }).whereType<Map<String, dynamic>>().toList();
    });
  }

  Future<void> updateTaskCompletion(String taskId, String userId, bool isCompleted) async {
    try {
      await _db.child('tasks/$userId/$taskId').update({
        'isCompleted': isCompleted,
        'updatedAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId, String userId) async {
    try {
      await _db.child('tasks/$userId/$taskId').remove();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getTasksForDate(String userId, DateTime date) {
    return getTasks(userId).map((tasks) {
      return tasks.where((task) {
        if (task['completionDate'] == null) return false;
        
        // Handle both int and DateTime cases
        dynamic completionDate = task['completionDate'];
        DateTime taskDate;
        
        if (completionDate is int) {
          taskDate = DateTime.fromMillisecondsSinceEpoch(completionDate);
        } else if (completionDate is DateTime) {
          taskDate = completionDate;
        } else {
          return false;
        }

        return taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getTasksForDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) {
    return getTasks(userId).map((tasks) {
      return tasks.where((task) {
        if (task['completionDate'] == null) return false;
        final taskDate = task['completionDate'] as DateTime;
        return taskDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
              taskDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<void> testConnection() async {
    try {
      await _db.child('connection_test').set({
        'test': true,
        'timestamp': ServerValue.timestamp,
      });
      await _db.child('connection_test').remove();
    } catch (e) {
      throw Exception('Database connection test failed: $e');
    }
  }
}