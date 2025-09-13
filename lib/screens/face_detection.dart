import 'package:flutter/material.dart';

class FaceDetection extends StatefulWidget{
  const FaceDetection({super.key});

  @override
  State<FaceDetection> createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Face detection"),
    );
  }
}