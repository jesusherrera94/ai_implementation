import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../utils/camera_image.dart';

class FaceDetection extends StatefulWidget{
  const FaceDetection({super.key});

  @override
  State<FaceDetection> createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  Future<void> _initializeControllerFuture = Future.value();
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions(
    enableContours: false,
    enableClassification: false,
    enableLandmarks: false,
    enableTracking: false,
  ));

  List<Face> _faces = [];
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _loadCameraController();
  }

  void _loadCameraController() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max, imageFormatGroup: Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21);
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      if (!mounted) return;
      _cameraController.startImageStream(_processCameraImage);
    });
  }

   _processCameraImage(CameraImage image) async {
    if (busy) return;
    final inputImage = inputImageFromCameraImage(image, cameras, 0, _cameraController);
    if (inputImage == null) return;
    busy = true;
    final List<Face> faces = await _faceDetector.processImage(inputImage);
    setState(() {
      _faces = faces;
      busy = false;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_cameraController),
                ..._faces.map((face) {
                  final padding = MediaQuery.of(context).padding;
                  return Positioned(
                    left: face.boundingBox.right - face.boundingBox.width - padding.left,
                    top: face.boundingBox.top - kToolbarHeight - padding.top,
                    width: face.boundingBox.width,
                    height: face.boundingBox.height,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
  }
}