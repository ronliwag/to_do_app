import 'package:flutter/material.dart';
import 'package:to_do_app/pages/buttons.dart';
import 'buttons.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key, 
    required this.controller, 
    required this.onSave, 
    required this.onCancel
  });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 143, 175, 145),
      content: Container(
        height: 800,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Add New Task',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            //user input for task name
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //save button
                MyButton(text: "Save ", onPressed: onSave),
                const SizedBox(width: 10), // Spacing between buttons
                //cancel button
                MyButton(text: "Cancel", onPressed: onCancel),
              ],
            ),
          ],
        ),

      ),
    );
  }
}
