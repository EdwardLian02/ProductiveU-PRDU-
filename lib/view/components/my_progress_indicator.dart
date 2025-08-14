import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productive_u/view/theme.dart';

class MyProgressIndicator extends StatelessWidget {
  final double percent;
  const MyProgressIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 20,
      percent: percent / 100,
      progressColor: AppTheme.boldbackground,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        '$percent %',
        style: AppTheme.subheading3,
      ),
    );
  }
}
