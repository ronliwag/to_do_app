import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool isCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  TodoTile({
    super.key,
    required this.taskName,
    required this.isCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Slidable(
          closeOnScroll: true,
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.22,
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.blue.shade300,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    taskName,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                      color: isCompleted 
                          ? Colors.grey.shade600 
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}