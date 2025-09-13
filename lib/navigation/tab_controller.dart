import 'package:flutter/material.dart';
import '../screens/face_detection.dart';
import '../screens/text_recognition.dart';

class TabControllerScreen extends StatelessWidget {
  
  @override
  Widget build(Object context) {
   return DefaultTabController(length: 2, 
   child: Scaffold(
      appBar: AppBar(
        title: const Text("My AI super app!"),
        bottom: TabBar(tabs: [
          Tab(icon: Icon(Icons.message),),
          Tab(icon: Icon(Icons.person_outlined),),
        ]),
      ),
      body: TabBarView(children: [
        TextRecognition(),
        FaceDetection()
      ]),
   )); 
  }
  
}
