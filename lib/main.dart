import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_app/auth_service.dart';
import 'package:to_do_app/pages/landing.dart';
import 'package:to_do_app/pages/login.dart';
import 'firebase_options.dart';
import 'auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Test database connection
    await AuthService().testConnection();
    
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Fatal initialization error: $e');
    // Show error UI or exit
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        // Handle routes with arguments
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => LoginPage(onAuthSuccess: (user) {
                // This will be handled by AuthWrapper
              }),
            );
          case '/landing':
            final user = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => LandingPage(currentUser: user),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const AuthWrapper(),
            );
        }
      },
    );
  }
}