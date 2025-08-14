import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productive_u/globel.dart';
import 'package:productive_u/model/task.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/provider/task_provider.dart';

class DbService {
  final AuthServiceProvider authService = AuthServiceProvider();
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  String idGenerator() {
    return tasks.doc().id;
  }

  //Fetch tasks [With Filtering Logic]
  Stream<QuerySnapshot> getTasks(String status, String timeFilter) {
    Query query = tasks.orderBy('endDate', descending: true);

    //First filter time
    switch (timeFilter) {
      case "Today":
        query = query
            .where('endDate', isGreaterThanOrEqualTo: startOfToday)
            .where('endDate', isLessThan: endOfToday);
        break;
      case "Weekly":
        query = query
            .where('endDate', isGreaterThanOrEqualTo: startOfWeek)
            .where('endDate', isLessThan: endOfWeek);
        break;
      case "Monthly":
        query = query
            .where('endDate', isGreaterThanOrEqualTo: startOfMonth)
            .where('endDate', isLessThanOrEqualTo: endOfMonth);
        break;
    }

    // Status filter
    switch (status) {
      case "Todo":
        query = query.where("status", isEqualTo: "Todo");
        break;
      case "In-Progress":
        query = query.where("status", isEqualTo: "In-Progress");
        break;
      case "Done":
        query = query.where("status", isEqualTo: "Done");
        break;
    }

    return query.snapshots();
  }

  Future<List<Task>> getTaskForCalendarView() async {
    final snapshot = await tasks.get();
    return snapshot.docs.map((doc) {
      return Task.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<Map<String, int>> getTaskCounts(String timeFilter) async {
    Query query = tasks;

    // Time filter
    switch (timeFilter) {
      case "Today":
        query = query
            .where('endDate', isGreaterThanOrEqualTo: startOfToday)
            .where('endDate', isLessThan: endOfToday);
        break;
      case "Weekly":
        query = query
            .where('endDate', isGreaterThanOrEqualTo: startOfWeek)
            .where('endDate', isLessThan: endOfWeek);
        break;
      case "Monthly":
        query = query
            .where('endDate', isGreaterThanOrEqualTo: startOfMonth)
            .where('endDate', isLessThanOrEqualTo: endOfMonth);
        break;
    }

    QuerySnapshot snapshot = await query.get();

    int total = snapshot.size;
    int todo = 0;
    int inProgress = 0;
    int done = 0;

    for (var doc in snapshot.docs) {
      String status = doc['status'];
      if (status == "Todo") {
        todo++;
      } else if (status == "In-Progress") {
        inProgress++;
      } else if (status == "Done") {
        done++;
      }
    }

    return {
      "total": total,
      "todo": todo,
      "inProgress": inProgress,
      "done": done
    };
  }

  //create task
  Future<void> createTask(Map<String, dynamic> task) async {
    try {
      final taskId = idGenerator();
      task['taskId'] = taskId; //Assign taskID
      task['userId'] = authService.currentUser!.uid; //Assign created User

      //Set the task to firestore
      await tasks.doc(taskId).set(task);
    } on FirebaseException catch (e) {
      throw e.message ?? "Something went wrong while creating a task";
    } catch (e) {
      throw e.toString();
    }
  }

  //update task
  Future<void> updateTask(Map<String, dynamic> task) async {
    try {
      await tasks.doc(task['taskId']).update(task);
    } on FirebaseException catch (e) {
      throw e.message ?? "Something went wrong while updating task";
    } catch (e) {
      throw e.toString();
    }
  }

  //delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await tasks.doc(taskId).delete();
    } on FirebaseException catch (e) {
      throw e.message ?? "Something went wrong while deleting a task";
    }
  }
}
