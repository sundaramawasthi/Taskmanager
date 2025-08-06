import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmanager/TaskModel.dart';

import 'TaskProviderprovider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? selectedDate;
  String? selectedPriority;
  String? selectedTag;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Select Date'),
                subtitle: Text(
                  selectedDate != null
                      ? '${selectedDate!.toLocal()}'.split(' ')[0]
                      : 'No date chosen',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select priority' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedTag,
                decoration: const InputDecoration(labelText: 'Tag'),
                items: ['Work', 'Personal', 'Urgent', 'Other']
                    .map((tag) => DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTag = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a tag' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final task = Task(
                      id: UniqueKey().toString(),
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      date: selectedDate ?? DateTime.now(),
                      priority: selectedPriority ?? 'Medium',
                      tag: selectedTag ?? 'General',
                    );

                    await ref
                        .read(taskListControllerProvider.notifier)
                        .addTask(task);

                    // ✅ Snackbar message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('✅ Task added successfully!'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(12),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
