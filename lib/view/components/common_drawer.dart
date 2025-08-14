import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productive_u/view/theme.dart';

class CommonDrawer extends StatelessWidget {
  final User currentUser;

  const CommonDrawer({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView(
          children: [
            Center(
              child: Image.asset(
                "assets/images/anon-avater.png",
                width: 60,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "${currentUser.displayName}",
                style: AppTheme.subheading3,
              ),
            ),
            Center(
              child: Text(
                "${currentUser.email}",
                style: AppTheme.body,
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                "home",
                (Route<dynamic> route) => false,
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Calendar"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                "calendar",
                (Route<dynamic> route) => false,
              ),
            ),
            ListTile(
              leading: Icon(Icons.center_focus_strong),
              title: Text("Focus"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                "setting",
                (Route<dynamic> route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
