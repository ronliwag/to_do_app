import 'package:flutter/material.dart';
import 'package:to_do_app/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAuthSuccess;
  
  const LoginPage({super.key, required this.onAuthSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLogin = true;
  String? errorMessage;
  bool _isLoading = false;

  void toggleForm() => setState(() {
    isLogin = !isLogin;
    errorMessage = null;
  });

  void handleAuth() async {
    try {
      setState(() => _isLoading = true);
      
      final user = isLogin
        ? await _authService.login(emailController.text, passwordController.text)
        : await _authService.signUp(
            emailController.text,
            passwordController.text,
            nameController.text,
          );
      if (user != null) {
        widget.onAuthSuccess(user);
      } else {
        setState(() => errorMessage = 'Authentication failed');
      }
    } catch (e) {
      debugPrint('Auth error: $e');
      setState(() => errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (!isLogin)
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : handleAuth,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isLogin ? 'Login' : 'Sign Up'),
              ),
            ),
            TextButton(
              onPressed: _isLoading ? null : toggleForm,
              child: Text(isLogin
                  ? 'Don\'t have an account? Sign Up'
                  : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
