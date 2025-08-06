import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/TaskModel.dart';
import 'package:taskmanager/TaskProviderprovider.dart';
import 'package:taskmanager/taskdetailview.dart';
import 'EdittaskScreen.dart';

class TaskSections extends ConsumerWidget {
  final List<Task> tasks;

  const TaskSections({super.key, required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final thisWeekEnd = thisWeekStart.add(const Duration(days: 6));

    final Map<String, List<Task>> groupedTasks = {
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Upcoming': [],
    };

    for (var task in tasks) {
      final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
      if (taskDate == today) {
        groupedTasks['Today']!.add(task);
      } else if (taskDate == tomorrow) {
        groupedTasks['Tomorrow']!.add(task);
      } else if (taskDate.isAfter(today) && taskDate.isBefore(thisWeekEnd)) {
        groupedTasks['This Week']!.add(task);
      } else {
        groupedTasks['Upcoming']!.add(task);
      }
    }

    return ListView(
      children: groupedTasks.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(entry.key, style: Theme.of(context).textTheme.titleLarge),
          ),
          ...entry.value.map((task) => Dismissible(
            key: Key(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              ref.read(taskListControllerProvider.notifier).deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted Successfully')),
              );
            },
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.3),
                  builder: (_) => TaskDetailScreen(task: task),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + status + edit icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              /// ✅ Toggle complete/incomplete button
                              IconButton(
                                icon: Icon(
                                  task.isDone
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: task.isDone ? Colors.green : Colors.grey,
                                ),
                                onPressed: () {
                                  ref.read(taskListControllerProvider.notifier).toggleTaskStatus(task);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditTaskScreen(task: task),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// Priority & Date + Tag Chip (horizontal)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Left: Priority + Date (vertically stacked)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Priority: ${task.priority}"),
                              Text("Date: ${DateFormat('yyyy-MM-dd').format(task.date)}"),
                            ],
                          ),

                          /// Right: Tag chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getTagColor(task.tag),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              task.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),


          )),
        ],
      ))
          .toList(),
    );
  }
}

Color _getTagColor(String tag) {
  switch (tag.toLowerCase()) {
    case 'work':
      return Colors.deepPurple;
    case 'personal':
      return Colors.teal;
    case 'urgent':
      return Colors.red;
    case 'other':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
