import 'package:flutter/material.dart';
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
  int _selectedIndex = 0; // Start with Tasks page (index 0)

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
      TasksPage(userId: widget.currentUser['uid']), // Tasks page is now first
      CalendarPage(userId: widget.currentUser['uid']),
      ProfilePage(user: widget.currentUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -2), // Shadow on top of the bar
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFF26419), // Your secondary color
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
        ),
      ),
    );
  }
}