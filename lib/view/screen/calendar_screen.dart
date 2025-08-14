import 'package:flutter/material.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/provider/task_provider.dart';
import 'package:productive_u/service/notification_service.dart';
import 'package:productive_u/service/task_datasource.dart';
import 'package:productive_u/view/components/common_drawer.dart';
import 'package:productive_u/view/theme.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final currentUser = AuthServiceProvider().currentUser;

  @override
  void initState() {
    // TODO: implement initState
    context.read<TaskProvider>().updateAppointmentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: CommonDrawer(currentUser: currentUser!),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Timeline View",
              style: AppTheme.subheading2,
            ),
          ),
          Expanded(
            child: SfCalendar(
              view: CalendarView.timelineMonth,
              dataSource: TaskDatasource(taskProvider.appointmentList),
            ),
          ),
        ],
      ),
    );
  }
}
