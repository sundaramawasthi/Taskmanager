import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmanager/add_task_screen.dart';
import 'package:taskmanager/taskFilter.dart';
import 'package:taskmanager/taskssection.dart';
import 'TaskProviderprovider.dart';
import 'calenderscreen.dart';

class TaskHomeScreen extends ConsumerStatefulWidget {
  const TaskHomeScreen({super.key});

  @override
  ConsumerState<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends ConsumerState<TaskHomeScreen> {
  String _selectedPriorityFilter = 'All';
  String _selectedStatusFilter = 'All';
  String _selectedTagFilter = 'All';
  int _selectedIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _resetFilters() {
    setState(() {
      _selectedPriorityFilter = 'All';
      _selectedStatusFilter = 'All';
      _selectedTagFilter = 'All';
    });
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTaskView() {
    final tasksAsync = ref.watch(taskListControllerProvider);

    return tasksAsync.when(
      data: (tasks) {
        final filteredTasks = tasks.where((task) {
          final priorityMatch = _selectedPriorityFilter == 'All' || task.priority == _selectedPriorityFilter;
          final statusMatch = _selectedStatusFilter == 'All' ||
              (_selectedStatusFilter == 'Completed' && task.isDone) ||
              (_selectedStatusFilter == 'Pending' && !task.isDone);
          final tagMatch = _selectedTagFilter == 'All' || task.tag == _selectedTagFilter;
          final searchMatch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task.tag.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task.priority.toLowerCase().contains(_searchQuery.toLowerCase());

          return priorityMatch && statusMatch && tagMatch && searchMatch;
        }).toList();

        return TaskSections(tasks: filteredTasks);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildCalendarView() {
    Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TaskCalendarScreen()),
      );
    });
    return const SizedBox(); // placeholder
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(

          automaticallyImplyLeading: false, // ❌ Hides the back button



        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,

        title: const Text(
          'Task Manager',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              // Navigate to login screen after sign out
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Delete All Tasks',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete All Tasks?'),
                  content: const Text('Are you sure you want to delete all your tasks?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                // Call deleteAllTasks using Riverpod notifier
                await ref.read(taskListControllerProvider.notifier).deleteAllTasks();
              }
            },
          ),


          PopupMenuButton<int>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,

                child: SizedBox(

                  width: 80,
                  child: TaskFilter(
                    selectedPriority: _selectedPriorityFilter,
                    selectedStatus: _selectedStatusFilter,
                    selectedTag: _selectedTagFilter,
                    availableTags: const ['Work', 'Personal', 'Other'],
                    onPriorityChanged: (value) {
                      setState(() {
                        _selectedPriorityFilter = value ?? 'All';
                      });
                    },
                    onStatusChanged: (value) {
                      setState(() {
                        _selectedStatusFilter = value ?? 'All';
                      });
                    },
                    onTagChanged: (value) {
                      setState(() {
                        _selectedTagFilter = value ?? 'All';
                      });
                    },
                    onReset: _resetFilters,

                  ),
                ),
              ),
            ],
          )
        ],
        bottom: PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        padding: const EdgeInsets.symmetric(horizontal: 19),
        decoration: BoxDecoration(
          color: Colors.white,  // ✅ moved color inside decoration
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Input Search tasks...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    ),

    ),
      body: _selectedIndex == 0 ? _buildTaskView() : _buildCalendarView(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
