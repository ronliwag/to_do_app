import 'package:flutter/material.dart';
import 'package:to_do_app/pages/landing.dart';
import 'package:to_do_app/pages/home.dart';
import 'package:to_do_app/pages/profile.dart';
import 'package:to_do_app/pages/calendar.dart';
import 'package:to_do_app/pages/tasks.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/calendar': (context) => const CalendarPage(),
        '/tasks': (context) => const TasksPage(),
      },
    );
  }
}