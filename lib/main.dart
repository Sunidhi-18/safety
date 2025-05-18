import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SafetyApp());
}

class SafetyApp extends StatefulWidget {
  const SafetyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SafetyAppState createState() => _SafetyAppState();
}

class _SafetyAppState extends State<SafetyApp> {
  bool _isLoggedIn = false;
  bool _isProfileComplete = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _isProfileComplete = prefs.getBool('isProfileComplete') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women Safety App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isLoggedIn
          ? (_isProfileComplete ? const HomeScreen() : const ProfileScreen())
          : const AuthScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}