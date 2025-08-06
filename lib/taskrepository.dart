import 'package:cloud_firestore/cloud_firestore.dart';
import 'TaskModel.dart';

class TaskRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String USERID; // Add this at top of the class
  TaskRepository(this.USERID); // Add a constructor

  CollectionReference get _taskCollection =>
      _firestore.collection('User').doc(USERID).collection('tasks');

  Future<List<Task>> fetchTasks({
    String? priority,
    String? status,
    String? tag,
  })

  async {
    Query query = _taskCollection;

    if (priority != null && priority != 'All') {
      query = query.where('priority', isEqualTo: priority);
    }

    if (status != null && status != 'All') {
      final bool isDone = status == 'Completed';
      query = query.where('isDone', isEqualTo: isDone);
    }

    if (tag != null && tag != 'All') {
      query = query.where('tag', isEqualTo: tag);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }


  Future<void> addTask(Task task) async {
    await _taskCollection.add(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _taskCollection.doc(taskId).delete();
  }

  // ✅ Add this method for deleting all tasks
  Future<void> deleteAllTasks() async {
    final snapshot = await _taskCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }


  Future<void> updateTask(Task task) async {
    await _taskCollection.doc(task.id).update(task.toMap());
  }
}
