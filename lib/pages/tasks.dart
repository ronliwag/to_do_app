import 'package:flutter/material.dart';
import 'todo_tile.dart';
import 'dialog_box.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  //text controller
  final _controller = TextEditingController();
  
  //list of todo items
  List todoList = [
    ["Task 1", false],
    ["Task 2", false],
    ["Task 3", true],
  ];
  //checkbox state
  void checkboxChanged(bool? value, int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }
  //save new task
  void saveNewTask() {
    setState(() {
      todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop(); // Close the dialog
  }
  //create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => {Navigator.of(context).pop(), _controller.clear()},
        );
      },
    );
  }
  //delete task
  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: createNewTask,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add Task',
        shape: const CircleBorder(),
      child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: todoList[index][0],
            isCompleted: todoList[index][1],
            onChanged: (value) => checkboxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}