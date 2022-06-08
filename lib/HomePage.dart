import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:dog_breed_recognizer/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorking = false;
  String result = '';
  late CameraController cameraController;
  late CameraImage imgCamera;

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      ;
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStreamFrames(),
                }
            });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognition = await Tflite.runModelOnFrame(
          bytesList: imgCamera.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: imgCamera.height,
          imageWidth: imgCamera.width,
          imageStd: 127.5,
          imageMean: 127.5,
          numResults: 2,
          threshold: 0.1,
          asynch: true);

      result = "";

      recognition?.forEach((response) {
        result += response['label'] +
            " " +
            (response['confidence'] as double).toStringAsFixed(2) +
            "\n\n";
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.fill)),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 320,
                    width: 360,
                    child: Image.asset("assets/frames.jpg"),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      initCamera();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 35),
                      height: 270,
                      width: 360,
                      child: // imgCamera == null
                          isWorking == false
                              ? Container(
                                  height: 270,
                                  width: 360,
                                  child: Icon(
                                    Icons.photo_camera_front,
                                    color: Colors.blueAccent,
                                    size: 40,
                                  ),
                                )
                              : AspectRatio(
                                  aspectRatio:
                                      cameraController.value.aspectRatio,
                                  child: CameraPreview(cameraController),
                                ),
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 55.0),
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: TextStyle(
                      backgroundColor: Colors.white54,
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    ));
  }
}
