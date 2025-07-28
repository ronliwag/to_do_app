import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;
  
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Color(0xFFF26419)),
                title: const Text("Name", style: TextStyle(color: Color(0xFF070A0D))),
                subtitle: Text(user['name'] ?? 'No name set', 
                          style: TextStyle(color: Color(0xFF070A0D))),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              color: Colors.white, // Background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.email, color: Color(0xFFF26419)), // Secondary
                title: Text("Email", style: TextStyle(color: Color(0xFF070A0D))), // Text
                subtitle: Text(user['email'] ?? 'No email', 
                          style: TextStyle(color: Color(0xFF070A0D))), // Text
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.verified_user, color: Color(0xFFF26419)),
                title: const Text("User ID", style: TextStyle(color: Color(0xFF070A0D))),
                subtitle: Text(user['uid'], 
                          style: TextStyle(color: Color(0xFF070A0D))),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout),
              label: const Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF26419), // Secondary
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}