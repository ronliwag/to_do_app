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

  void _handleAuthSuccess(Map<String, dynamic> user) {
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LandingPage(currentUser: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LandingPage(currentUser: _currentUser!),
          ),
        );
      });
      return const SizedBox.shrink();
    }
    return LoginPage(onAuthSuccess: _handleAuthSuccess);
  }
}