// Bota: main app entry
import 'package:flutter/material.dart';

import 'core/app_state.dart';
import 'core/app_strings.dart';
import 'screens/auth_screen.dart';
import 'widgets/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LifeTrackerApp());
}

class LifeTrackerApp extends StatefulWidget {
  const LifeTrackerApp({super.key});

  @override
  State<LifeTrackerApp> createState() => _LifeTrackerAppState();
}

class _LifeTrackerAppState extends State<LifeTrackerApp> {
  late final AppState state;

  @override
  void initState() {
    super.initState();
    state = AppState()..addListener(_update);
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    state.removeListener(_update);
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppText.of(state.language, 'appTitle'),
      themeMode: state.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7C8CF8), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          filled: true,
        ),
        cardTheme: const CardThemeData(elevation: 0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF97A3FF), brightness: Brightness.dark),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          filled: true,
        ),
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.isLoggedIn
            ? AppShell(state: state)
            : AuthScreen(state: state),
      ),
    );
  }
}
