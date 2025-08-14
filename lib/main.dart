import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:productive_u/provider/auth_service_provider.dart';
import 'package:productive_u/provider/task_provider.dart';
import 'package:productive_u/service/notification_service.dart';
import 'package:productive_u/view/screen/auth_screen.dart';
import 'package:productive_u/view/screen/calendar_screen.dart';
import 'package:productive_u/view/screen/home_screen.dart';
import 'package:productive_u/view/screen/login_screen.dart';
import 'package:productive_u/view/screen/register_screen.dart';
import 'package:productive_u/view/screen/setting_screen.dart';
import 'package:productive_u/view/screen/splash_screen.dart';
import 'package:productive_u/view/theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
      ChangeNotifierProvider(create: (context) => TaskProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
      routes: {
        'splash/': (context) => SplashScreen(),
        'login/': (context) => LoginScreen(),
        'signup/': (context) => RegisterScreen(),
        'auth/': (context) => AuthScreen(),
        'home': (context) => HomeScreen(),
        'calendar': (context) => CalendarScreen(),
        'setting': (context) => SettingScreen(),
      },
    );
  }
}
