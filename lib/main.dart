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
        primaryColor: const Color(0xFFF6AE2D), // Primary
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFF6AE2D), // Primary
          secondary: const Color(0xFFF26419), // Secondary
          background: Colors.white, // Background
          onBackground: const Color(0xFF070A0D), // Text
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6AE2D), // Primary
          foregroundColor: Color(0xFF070A0D), // Text
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF070A0D)), // Text
          bodyMedium: TextStyle(color: Color(0xFF070A0D)), // Text
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white, // Background
        ),
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