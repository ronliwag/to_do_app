import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDateTime = DateTime.now();
  final PageController _pageController = PageController(initialPage: 1);
  List<DateTime> _dateRange = [];
  @override
  void initState() {
    super.initState();
    _initializeDateRange();
  }

  void _initializeDateRange() {
    setState(() {
      _dateRange = List.generate(7, (index) => 
        DateTime.now().add(Duration(days: index - 1)));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentDate = _dateRange[index];
    });
  }

  void saveNewTask() {
    if (_controller.text.trim().isNotEmpty) {
      final taskDate = _selectedDateTime;
      
      _databaseService.addTask(
        _controller.text.trim(), 
        widget.userId,
        taskDate,
      ).then((_) {
        _controller.clear();
        setState(() => _selectedDateTime = _currentDate);
      });
    }
    Navigator.of(context).pop();
  }

  void createNewTask() {
    setState(() {
      _selectedDateTime = _currentDate;
    });

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          onDateTimeSelected: (dateTime) {
            setState(() => _selectedDateTime = dateTime);
          },
          initialDate: _currentDate,
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
        backgroundColor: const Color(0xFFF6AE2D),
        foregroundColor: const Color(0xFF070A0D),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _dateRange.length,
              itemBuilder: (context, index) {
                final date = _dateRange[index];
                final isToday = isSameDay(date, DateTime.now());
                
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isToday 
                          ? const Color(0xFFF26419).withOpacity(0.5) 
                          : const Color(0xFFF26419).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _databaseService.getTasksForDate(widget.userId, _currentDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
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
                          'No tasks for ${DateFormat('MMM d').format(_currentDate)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
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
                      completionDate: task['completionDate'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}