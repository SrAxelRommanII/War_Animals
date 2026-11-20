import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/download_screen.dart';
import 'screens/intro_assistant_screen.dart';
import 'screens/avatar_customization_screen.dart';
import 'screens/starter_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/story_map_screen.dart';

void main() {
  runApp(const WarAnimalsApp());
}

class WarAnimalsApp extends StatelessWidget {
  const WarAnimalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'War Animals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D14),
        primaryColor: Colors.amber,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/download': (context) => const DownloadScreen(),
        '/assistant_intro': (context) => const IntroAssistantScreen(),
        '/avatar_customization': (context) => const AvatarCustomizationScreen(),
        '/starter_selection': (context) => const StarterSelectionScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/story_map': (context) => const StoryMapScreen(),
      },
    );
  }
}