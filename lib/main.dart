import 'package:flutter/material.dart';
import './navigation/tab_controller.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Permission.camera.request();
   await Permission.microphone.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TabControllerScreen(),
    );
  }
}