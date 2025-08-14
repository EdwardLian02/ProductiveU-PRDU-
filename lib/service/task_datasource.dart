import 'package:flutter/material.dart';
import 'package:productive_u/model/task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

List<Appointment> getAppointmentFromTasks(List<Task> tasks) {
  return tasks.map((task) {
    return Appointment(
      startTime: task.startDate,
      endTime: task.endDate,
      subject: task.name,
      color: _getStatusColorForCalendar(task.status),
    );
  }).toList();
}

Color _getStatusColorForCalendar(String status) {
  switch (status) {
    case 'Done':
      return Colors.green;
    case 'In-Progress':
      return Colors.blue;
    case 'Todo':
    default:
      return Colors.grey;
  }
}

class TaskDatasource extends CalendarDataSource {
  TaskDatasource(List<Appointment> source) {
    appointments = source;
  }
}
