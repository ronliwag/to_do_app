import 'package:flutter/material.dart';
import 'todo_tile.dart';
import 'dialog_box.dart';
import '../database_service.dart';

class TasksPage extends StatefulWidget {
  final String userId;
  
  const TasksPage({super.key, required this.userId});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Save new task
  void saveNewTask() {
    if (_controller.text.trim().isNotEmpty) {
      _databaseService.addTask(_controller.text.trim(), widget.userId);
      _controller.clear();
    }
    Navigator.of(context).pop();
  }

  // Create new task dialog
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add Task',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _databaseService.getTasks(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final todoList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final task = todoList[index];
              return TodoTile(
                taskName: task['taskName'],
                isCompleted: task['isCompleted'],
                onChanged: (value) => _databaseService.updateTaskCompletion(
                  task['id'],
                  widget.userId,
                  value ?? false,
                ),
                deleteFunction: (context) => _databaseService.deleteTask(
                  task['id'],
                  widget.userId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}