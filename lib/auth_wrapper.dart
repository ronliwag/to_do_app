import 'package:flutter/material.dart';
import 'package:to_do_app/pages/login.dart';
import 'package:to_do_app/pages/landing.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Map<String, dynamic>? _currentUser;

  // In your AuthWrapper, ensure you're properly handling the auth success
  void _handleAuthSuccess(Map<String, dynamic> user) {
    if (mounted) { // Check if widget is still mounted
      setState(() {
        _currentUser = user;
      });
      // Add navigation if needed
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LandingPage(currentUser: user)),
      );
    }
  }

  // In AuthWrapper, ensure proper navigation
  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      // Use pushReplacement to prevent going back to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LandingPage(currentUser: _currentUser!),
          ),
        );
      });
      return const SizedBox.shrink(); // Temporary empty widget
    }
    return LoginPage(onAuthSuccess: _handleAuthSuccess);
  }
}