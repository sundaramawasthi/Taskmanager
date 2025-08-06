import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'TaskProviderprovider.dart';
import 'TaskModel.dart'; // Make sure you import your Task model

class CreateTaskModal extends ConsumerStatefulWidget {
  const CreateTaskModal({super.key});

  @override
  ConsumerState<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends ConsumerState<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final tagController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedPriority = 'Low';

  bool _isAdding = false;

  @override
  void dispose() {
    titleController.dispose();
    tagController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    setState(() {
      _isAdding = true;
    });

    final title = titleController.text.trim();
    final tag = tagController.text.trim().isEmpty ? 'General' : tagController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      final controller = ref.read(taskListControllerProvider.notifier);

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        tag: tag,
        description: description,
        isDone: false,
        priority: selectedPriority,
        date: DateTime.now(),
      );

      await controller.addTask(newTask);

      if (mounted) {
        Navigator.of(context).pop();
      }
    }

    setState(() {
      _isAdding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    labelText: 'Tag (e.g. Urgent, Work)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedPriority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isAdding
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          _addTask();
                        }
                      },
                      child: _isAdding
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Add Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
