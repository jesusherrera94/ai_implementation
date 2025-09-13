import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../utils/camera_image.dart';

class TextRecognition extends StatefulWidget{
  const TextRecognition({super.key});

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition>  {

  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  Future<void> _initializeControllerFuture = Future.value();
   final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  String _recognizedText = '';
  bool _isBusy = false;


  @override
  void initState() {
    super.initState();
    _loadCameraController();
  }

  void _loadCameraController() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max, imageFormatGroup: Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21);
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      if(!mounted) return;
      _cameraController.startImageStream(_processCameraImage);
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isBusy) return;
    _isBusy = true;
    final inputImage = inputImageFromCameraImage(image, cameras, 0, _cameraController);
    if (inputImage == null) return;
    try {

      final RecognizedText recognisedText = await _textRecognizer.processImage(inputImage);
      setState(() {
        _isBusy = false;
        _recognizedText = recognisedText.text;
      });
    } catch (e) {
      print('Error occured during recognition: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CameraPreview(_cameraController),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.black.withAlpha(100),
                          child: Text(
                            _recognizedText,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                 else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      );
  }
}