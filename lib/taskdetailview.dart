// lib/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'EdittaskScreen.dart';
import 'TaskModel.dart';
import 'add_task_screen.dart'; // for navigation

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Task Details",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              _buildDetailRow("Title:", task.title),
              _buildDetailRow("Description:", task.description),
              _buildDetailRow("Date:", task.date.toString()),
              _buildDetailRow("Priority:", task.priority),
              _buildDetailRow("Tag:", task.tag),
              _buildDetailRow("Status:", task.isDone ? "Completed" : "Incomplete"),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text("Edit"),
                    onPressed: () {
                      Navigator.pop(context); // close dialog first
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(task: task),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text("Add New"),
                    onPressed: () {
                      Navigator.pop(context); // close dialog first
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddTaskScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
