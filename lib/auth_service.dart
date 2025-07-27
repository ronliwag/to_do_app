import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  DatabaseReference? _db;
  bool _initializing = false;

  Future<DatabaseReference> get _database async {
    if (_db != null) return _db!;
    if (_initializing) {
      while (_db == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _db!;
    }
    
    _initializing = true;
    try {
      final app = Firebase.app();
      final database = FirebaseDatabase.instanceFor(
        app: app,
        databaseURL: 'https://to-do-flutter-d9f58-default-rtdb.asia-southeast1.firebasedatabase.app',
      );
      _db = database.ref();
      debugPrint('✅ Database successfully initialized');
      return _db!;
    } catch (e) {
      debugPrint('❌ Database initialization failed: $e');
      _initializing = false;
      rethrow;
    } finally {
      _initializing = false;
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final db = await _database;
      final snapshot = await db.child('users')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (snapshot.snapshot.value == null) {
        throw Exception('User not found');
      }

      // Safe type conversion
      final dynamic snapshotValue = snapshot.snapshot.value;
      final Map<String, dynamic> users = {};
      
      if (snapshotValue is Map) {
        snapshotValue.forEach((key, value) {
          if (key is String && value is Map) {
            users[key] = Map<String, dynamic>.from(value);
          }
        });
      }

      if (users.isEmpty) {
        throw Exception('User not found');
      }

      final userEntry = users.entries.firstWhere(
        (entry) => entry.value['email'] == email,
        orElse: () => throw Exception('User not found'),
      );

      var userData = userEntry.value;
      final hashedPassword = _hashPassword(password);

      if (userData['password'] != hashedPassword) {
        throw Exception('Invalid password');
      }

      return {
        'uid': userEntry.key,
        'email': userData['email'],
        'name': userData['name'],
      };
    } catch (e) {
      debugPrint('❌ Login error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password, String name) async {
    try {
      final db = await _database;
      final emailCheck = await db.child('users')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (emailCheck.snapshot.value != null) {
        throw Exception('Email already in use');
      }

      final newUserRef = db.child('users').push();
      final hashedPassword = _hashPassword(password);

      await newUserRef.set({
        'email': email,
        'password': hashedPassword,
        'name': name,
        'createdAt': ServerValue.timestamp,
      });

      debugPrint('✅ User created successfully: ${newUserRef.key}');
      return {
        'uid': newUserRef.key,
        'email': email,
        'name': name,
      };
    } catch (e) {
      debugPrint('❌ Sign-up error: $e');
      rethrow;
    }
  }

  Future<void> testConnection() async {
    try {
      final db = await _database;
      await db.child('connection_test').set({
        'test': DateTime.now().toIso8601String(),
      });
      await db.child('connection_test').remove();
      debugPrint('✅ Database connection test successful');
    } catch (e) {
      debugPrint('❌ Database connection test failed: $e');
      rethrow;
    }
  }
}