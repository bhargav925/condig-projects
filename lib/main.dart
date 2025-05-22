import 'package:chatapp/Login%20Signup/login.dart';
import 'package:chatapp/PIN%20SET/setup_pin.dart';
import 'package:chatapp/PIN%20SET/verify_pin.dart';
import 'package:chatapp/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final isPinSetup = prefs.getBool('pin_setup') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn, isPinSetup: isPinSetup));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isPinSetup;

  const MyApp({super.key, required this.isLoggedIn, required this.isPinSetup});

  @override
  Widget _getInitialScreen() {
    if (!isLoggedIn) {
      return const LoginScreen();
    } else if (!isPinSetup) {
      return const SetupPinScreen();
    } else {
      return const VerifyPinScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => _getInitialScreen(),
        '/login': (context) => const LoginScreen(),
        '/verify_pin': (context) => const VerifyPinScreen(),
        '/home': (context) => const HomeScreen(isLoggedIn: true, isPinSetup: true),
      },
    );
  }
}

