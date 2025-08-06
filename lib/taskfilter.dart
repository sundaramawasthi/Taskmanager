// lib/widgets/task_filter.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define filter providers
final priorityFilterProvider = StateProvider<String>((ref) => 'All');
final statusFilterProvider = StateProvider<String>((ref) => 'All');
final tagFilterProvider = StateProvider<String>((ref) => 'All');

class TaskFilter extends StatelessWidget {
  final String? selectedPriority;
  final String? selectedStatus;
  final String? selectedTag;

  final List<String> availableTags;

  final ValueChanged<String?> onPriorityChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onTagChanged;

  final VoidCallback onReset;

  const TaskFilter({
    super.key,
    required this.selectedPriority,
    required this.selectedStatus,
    required this.selectedTag,
    required this.availableTags,
    required this.onPriorityChanged,
    required this.onStatusChanged,
    required this.onTagChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.filter_list),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Priority'),
              DropdownButton<String>(
                value: selectedPriority,
                items: ['All', 'Low', 'Medium', 'High']
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: onPriorityChanged,
              ),
              const SizedBox(height: 8),
              const Text('Status'),
              DropdownButton<String>(
                value: selectedStatus,
                items: ['All', 'Completed', 'Pending'] // ✅ updated here
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: onStatusChanged,
              ),
              const SizedBox(height: 8),
              const Text('Tag'),
              DropdownButton<String>(
                value: selectedTag,
                items: ['All', ...availableTags]
                    .map((tag) => DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                ))
                    .toList(),
                onChanged: onTagChanged,
              ),
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Filters'),
                onPressed: onReset,
              )
            ],
          ),
        )
      ],
    );
  }
}
