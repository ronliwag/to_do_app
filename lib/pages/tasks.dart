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

  void saveNewTask() {
    if (_controller.text.trim().isNotEmpty) {
      _databaseService.addTask(_controller.text.trim(), widget.userId);
      _controller.clear();
    }
    Navigator.of(context).pop();
  }

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
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _databaseService.getTasks(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final todoList = snapshot.data ?? [];

            if (todoList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add a task',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

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
      ),
    );
  }
}