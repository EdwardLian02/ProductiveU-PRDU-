import 'package:cloud_firestore/cloud_firestore.dart';

Timestamp dateTimeToTimestamp(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

DateTime timestampToDateTime(Timestamp timestamp) {
  return timestamp.toDate();
}

bool checkIsSameDay(
    {required DateTime startDateTime, required DateTime endDateTime}) {
  return endDateTime.year == startDateTime.year &&
      endDateTime.month == startDateTime.month &&
      endDateTime.day == startDateTime.day;
}

// For Time filter
DateTime now = DateTime.now();
DateTime startOfToday = DateTime(now.year, now.month, now.day);
DateTime endOfToday = startOfToday.add(Duration(days: 1));

DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
DateTime endOfWeek = startOfWeek.add(Duration(days: 7));

DateTime startOfMonth = DateTime(now.year, now.month, 1);
DateTime endOfMonth = DateTime(
  now.year,
  now.month + 1,
  1,
).subtract(Duration(seconds: 1)); // Last day of month
