import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productive_u/model/task.dart';
import 'package:productive_u/service/db_service.dart';
import 'package:productive_u/service/notification_service.dart';
import 'package:productive_u/service/task_datasource.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_calendar/calendar.dart';

class TaskProvider extends ChangeNotifier {
  final _dbService = DbService();

  //For the whole page time filtering
  String currentTimeFilterStatus = "All";

  //for displaying tasks
  double taskCompletionPercentage = 0.0;
  int totalTask = 0;
  int completedTask = 0;
  int todoTask = 0;
  int inProgressTask = 0;

  //create a new task
  Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      await _dbService.createTask(taskData);
      updateTaskCount();
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> fetchTasks(String status) {
    return _dbService.getTasks(status, currentTimeFilterStatus);
  }

  Future<void> updateTask(Map<String, dynamic> taskData) async {
    try {
      await _dbService.updateTask(taskData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _dbService.deleteTask(taskId);
      updateTaskCount();
    } catch (e) {
      throw e.toString();
    }
  }

/*

Time Filtering Section

*/

  void updateCurrentTimeFilterStatus(String newValue) {
    currentTimeFilterStatus = newValue;
    updateTaskCount();
    notifyListeners();
  }

  void updateTaskCount() async {
    final countData = await _dbService.getTaskCounts(currentTimeFilterStatus);
    todoTask = countData['todo'] ?? 0;
    inProgressTask = countData['inProgress'] ?? 0;
    completedTask = countData['done'] ?? 0;
    totalTask = countData['total'] ?? 0;

    calculatePercentage(totalTask, completedTask);
  }

  void calculatePercentage(int totalTask, int completedTask) {
    if (totalTask == 0) {
      taskCompletionPercentage = 0;
    } else {
      double percentage = (completedTask / totalTask) * 100;
      taskCompletionPercentage = double.parse(percentage.toStringAsFixed(2));
    }
    notifyListeners();
  }

  /*
  
  Handling task in calendar view

  */

  List<Appointment> appointmentList = [];

  void updateAppointmentList() async {
    final taskList = await _dbService.getTaskForCalendarView();
    appointmentList = getAppointmentFromTasks(taskList);
    notifyListeners();
  }

  //Notification
  void scheduleNotificaiton(Task task) {
    if (task.isNotify) {
      NotificationService().scheduleTaskNotificationsForProduction(task: task);
    }
  }
}
