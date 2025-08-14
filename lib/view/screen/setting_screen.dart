import 'package:flutter/material.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/view/components/common_drawer.dart';
import 'package:productive_u/view/components/custom_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final currentUser = AuthServiceProvider().currentUser;

  void _displayConfirmation() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("Are you sure you want to log out?"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomButton(
                    text: "Cancel",
                    backgroundColor: Colors.transparent,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CustomButton(
                  text: "Sure",
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    await AuthServiceProvider().logoutUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'auth/', (Route<dynamic> route) => false);
                  },
                )
              ],
            ));
  }

  void _showProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: CommonDrawer(currentUser: currentUser!),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              CustomButton(
                text: "Logout",
                icon: Icon(Icons.logout),
                backgroundColor: Colors.redAccent,
                onPressed: _displayConfirmation,
              )
            ],
          ),
        ));
  }
}
