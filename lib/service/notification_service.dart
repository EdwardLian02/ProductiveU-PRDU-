import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:productive_u/model/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes
  Future<void> initNotification() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Determine the device's current timezone.
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Define platform-specific initialization settings.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine settings for all platforms.
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Request permissions for iOS and initialize the plugin.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap events here.
        // The payload can be used to navigate to a specific task screen.
        if (response.payload != null) {
          debugPrint('Notification tapped with task ID: ${response.payload}');
        }
      },
    );
  }

  /// Schedule notificaiton function
  /// 1. At the start date of the task.
  /// 2. 30 minutes before the end date of the task.
  ///
  /// This is actually for the app scheduling logic
  Future<void> scheduleTaskNotificationsForProduction({
    required Task task,
  }) async {
    if (!task.isNotify) {
      return;
    }

    // Define notification details.
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // Schedule the start date notification, but only if it's in the future.
    final scheduledStartDate = tz.TZDateTime.from(task.startDate, tz.local);
    if (scheduledStartDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.taskId.hashCode,
        'Task Starting: ${task.name}',
        'Your task is starting now!',
        scheduledStartDate,
        notificationDetails,
        payload: task.taskId,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    // Calculate the reminder time (30 minutes before the end date).
    final reminderTime = task.endDate.subtract(const Duration(minutes: 30));
    final scheduledReminderTime = tz.TZDateTime.from(reminderTime, tz.local);

    if (scheduledReminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.taskId.hashCode + 1,
        'Task Reminder: ${task.name}',
        'This task is ending in 30 minutes!',
        scheduledReminderTime,
        notificationDetails,
        payload: task.taskId,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  /// Schedules notifications for immediate testing.
  ///
  /// This method is for development purposes only. It schedules two
  /// notifications for a few seconds in the future for quick testing.
  // Future<void> scheduleTaskNotificationsForTesting({
  //   required Task task,
  // }) async {
  //   if (!task.isNotify) {
  //     return;
  //   }

  //   // Define notification details.
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'task_channel_id',
  //     'Task Notifications',
  //     channelDescription: 'Notifications for upcoming tasks',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //     fullScreenIntent: true,
  //   );

  //   const DarwinNotificationDetails iosNotificationDetails =
  //       DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );

  //   const NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: iosNotificationDetails,
  //   );

  //   // Schedule the start notification for 5 seconds from now.
  //   final scheduledStartDate =
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     task.taskId.hashCode,
  //     'TEST: Task Starting: ${task.name}',
  //     'This is a test notification for task start!',
  //     scheduledStartDate,
  //     notificationDetails,
  //     payload: task.taskId,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );

  //   // Schedule the reminder notification for 10 seconds from now.
  //   final scheduledReminderTime =
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     task.taskId.hashCode + 1,
  //     'TEST: Task Reminder: ${task.name}',
  //     'This is a test notification for the 30-minute reminder!',
  //     scheduledReminderTime,
  //     notificationDetails,
  //     payload: task.taskId,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );
  // }

  /// Cancels both the start and reminder notifications for a given task.
  Future<void> cancelTaskNotifications(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.taskId.hashCode);
    await flutterLocalNotificationsPlugin.cancel(task.taskId.hashCode + 1);
  }
}
