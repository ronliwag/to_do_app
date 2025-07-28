import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentDate;
    try {
      currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    } catch (e) {
      currentDate = 'Today';
    }

    return Scaffold(
      body: Container(
        color: Colors.white,  // Ensure background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Debug: Verify widgets are visible
              Text(
                currentDate,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,  // Force visibility
                ),
              ),
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Add more widgets one by one to isolate issues
            ],
          ),
        ),
      ),
    );
  }
}