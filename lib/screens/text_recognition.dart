import 'package:flutter/material.dart';

class TextRecognition extends StatefulWidget{
  const TextRecognition({super.key});

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Text Recognition"),
    );
  }
}