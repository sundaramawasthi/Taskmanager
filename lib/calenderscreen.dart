import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanager/taskhome.dart';
import 'TaskModel.dart';
import 'TaskProviderprovider.dart';
import 'add_task_screen.dart';

class TaskCalendarScreen extends ConsumerStatefulWidget {
  const TaskCalendarScreen({super.key});

  @override
  ConsumerState<TaskCalendarScreen> createState() => _TaskCalendarScreenState();
}

class _TaskCalendarScreenState extends ConsumerState<TaskCalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskListControllerProvider);

    return Scaffold(
      appBar: AppBar(
    title: const Text('Task Calendar'),
    leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const TaskHomeScreen()),
    );
    },
    ),
    actions: [
    IconButton(
    icon: const Icon(Icons.add),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    },
    ),
    ],
    ),

    body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: allTasks.when(
              data: (tasks) {
                final tasksForSelectedDay = tasks.where((task) {
                  return task.date.year == _selectedDate.year &&
                      task.date.month == _selectedDate.month &&
                      task.date.day == _selectedDate.day;
                }).toList();

                if (tasksForSelectedDay.isEmpty) {
                  return const Center(child: Text("No tasks on this day"));
                }

                return ListView.builder(
                  itemCount: tasksForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final task = tasksForSelectedDay[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Priority: ${task.priority}'),
                      trailing: Icon(
                        task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task.isDone ? Colors.green : Colors.grey,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
