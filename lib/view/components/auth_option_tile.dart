import 'package:flutter/material.dart';
import 'package:productive_u/view/theme.dart';

class AuthOptionTile extends StatelessWidget {
  final String title;
  final String logo;
  final void Function()? onTap;
  const AuthOptionTile(
      {super.key,
      required this.title,
      required this.logo,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              style: BorderStyle.solid,
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Image.asset(
                  logo,
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: AppTheme.body,
                )
              ],
            ),
          )),
    );
  }
}
