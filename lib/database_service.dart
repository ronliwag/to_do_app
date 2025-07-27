import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  // Use your actual database URL from Firebase console
  static const String _databaseUrl = 'https://to-do-flutter-d9f58-default-rtdb.asia-southeast1.firebasedatabase.app';
  
  late final DatabaseReference _db;

  DatabaseService() {
    // Initialize with the correct database URL
    _db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: _databaseUrl,
    ).ref();
  }

  // Add a new task for current user
  Future<void> addTask(String taskName, String userId) async {
    try {
      await _db.child('tasks').child(userId).push().set({
        'taskName': taskName,
        'isCompleted': false,
        'createdAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  // Get all tasks for the current user
  Stream<List<Map<String, dynamic>>> getTasks(String userId) {
    return _db.child('tasks/$userId').onValue.map((event) {
      final snapshotValue = event.snapshot.value;

      if (snapshotValue == null || snapshotValue is! Map) return [];

      final data = Map<String, dynamic>.from(snapshotValue);

      return data.entries.map((entry) {
        final value = entry.value;
        if (value is! Map) return null;

        final taskMap = Map<String, dynamic>.from(value);
        return {
          'id': entry.key,
          'taskName': taskMap['taskName'] ?? 'Unnamed Task',
          'isCompleted': taskMap['isCompleted'] ?? false,
          'createdAt': taskMap['createdAt'] ?? 0,
        };
      }).whereType<Map<String, dynamic>>().toList();
    });
  }

  // Update task completion status
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

  // Delete a task
  Future<void> deleteTask(String taskId, String userId) async {
    try {
      await _db.child('tasks/$userId/$taskId').remove();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Optional: Test database connection
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