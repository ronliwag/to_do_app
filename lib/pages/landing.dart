import 'package:flutter/material.dart';
import 'package:to_do_app/pages/home.dart';
import 'package:to_do_app/pages/profile.dart';
import 'package:to_do_app/pages/calendar.dart';
import 'package:to_do_app/pages/tasks.dart';

class LandingPage extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  
  const LandingPage({super.key, required this.currentUser});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      TasksPage(userId: widget.currentUser['uid']),
      CalendarPage(),
      ProfilePage(user: widget.currentUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}