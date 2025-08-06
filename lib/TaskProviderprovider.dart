import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'TaskModel.dart';
import 'TaskRepository.dart';

final userIdProvider = StateProvider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid ?? '';
});

/// ✅ Main task list controller provider
final taskListControllerProvider =
AsyncNotifierProvider<TaskListController, List<Task>>(TaskListController.new);

final filteredTasksProvider = Provider.family.autoDispose<List<Task>, Tuple2<String, String>>(
      (ref, filters) {
    final priority = filters.item1;
    final status = filters.item2;

    final taskList = ref.watch(taskListControllerProvider).value ?? [];

    return taskList.where((task) {
      final matchesPriority = priority == 'All' || task.priority == priority;
      final matchesStatus = status == 'All' ||
          (status == 'Completed' && task.isDone) ||
          (status == 'Incomplete' && !task.isDone);

      return matchesPriority && matchesStatus;
    }).toList();
  },
);

/// ✅ TaskListController class
class TaskListController extends AsyncNotifier<List<Task>> {
  TaskRepository? _repository;

  TaskRepository get repository {
    _repository ??= TaskRepository(ref.read(userIdProvider));
    return _repository!;
  }

  @override
  Future<List<Task>> build() async {
    final uid = ref.watch(userIdProvider);

    if (uid.isEmpty) return [];

    _repository = TaskRepository(uid);
    return await _repository!.fetchTasks();
  }

  Future<void> addTask(Task task) async {
    await repository.addTask(task);
    state = AsyncValue.data(await repository.fetchTasks());
  }

  Future<void> deleteTask(String taskId) async {
    await repository.deleteTask(taskId);
    state = AsyncValue.data(await repository.fetchTasks());
  }

  Future<void> updateTask(Task updatedTask) async {
    await repository.updateTask(updatedTask);
    state = AsyncValue.data(await repository.fetchTasks());
  }

  Future<void> deleteAllTasks() async {
    await repository.deleteAllTasks();
    state = const AsyncLoading();
    state = AsyncValue.data(await repository.fetchTasks());
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await repository.updateTask(updatedTask);
    state = AsyncValue.data(await repository.fetchTasks());
  }
}
