import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trash_can/wasteinfo.dart';
import 'package:lottie/lottie.dart';

class Predict extends StatefulWidget {
  const Predict({Key? key}) : super(key: key);
  @override
  _PredictState createState() => _PredictState();
}

class _PredictState extends State<Predict> with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool _undetected = false;
  String x = '';
  late int y;
  bool loading = false;
  late File _image;
  List _output = [];
  final imagepicker = ImagePicker();
  String _confidence = "";
  String _name = "";
  String numbers = "";
  Map<String, int> materialsPoints = {
    'battery': 10,
    'biological': 5,
    'brown-glass': 3,
    'cardboard': 5,
    'clothes': 15,
    'green-glass': 3,
    'metal': 10,
    'paper': 5,
    'plastic': 10,
    'shoes': 10,
    'trash': 2,
    'white-glass': 3
  };

  @override
  void initState() {
    super.initState();
    loading = true;
    loadmodel().then((value) {
      print(value);
      print('on the detect page');
      setState(() {});
    });
    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
  }

  detectimage(File image) async {
    print(image.path);
    var prediction = await Tflite.runModelOnImage(
        path: image.path, numResults: 12, threshold: 0.45);
    print("predictions are $prediction");
    setState(() {
      _output = prediction!;
      print(_output);
      loading = false;
    });
    isNotempty();
  }

  void isNotempty() {
    if (_output.isNotEmpty) {
      String gname = _output[0]['label'];
      int? points = materialsPoints[gname];
      // Future.delayed(Duration(milliseconds: 600), () {
      showSuccessfulDialog(gname, points!);
      
// });
      addPointDocument(gname, points!);
    }
  }



  Future<void> addPointDocument(String garbageName, int point) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final pointsRef = FirebaseFirestore.instance
        .collection('garbageDB')
        .doc(uid)
        .collection('points');
    final documentRef = pointsRef.doc(timestamp.toString());
    await documentRef.set({
      'garbageName': garbageName,
      'point': point,
      'scanningTime': FieldValue.serverTimestamp(),
    });
  }

  loadmodel() async {
    var res = await Tflite.loadModel(
      model: 'assets/model/unquantized.tflite',
      labels: 'assets/model/labels.txt',
    );
    print("Result after loading the model: $res");
  }

  @override
  void dispose() {
    Tflite.close();
    lottieController.dispose();
    super.dispose();
  }

  pickimage_camera() async {
    var image = await imagepicker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  pickimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    print("here");
    detectimage(_image);
  }
    void showSuccessfulDialog(String name, int points) =>
      // Future.delayed(Duration(milliseconds: 500), () {
        showDialog(
          context: context,
          builder: (context) =>
           Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/images/congratulations.json",
                  repeat: false,
                  controller: lottieController,
                  onLoaded: (composition) {
                    lottieController.duration = composition.duration*3;
                    lottieController.forward();
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "You have earned $points points for $name",
                    style: TextStyle(fontSize: 21),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ). then((value) => lottieController.reset());
// });

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFFFFDD0),
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Container(
                child: Text(
              'Garbage Segregator',
              style: GoogleFonts.getFont('Didact Gothic',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              //color: Colors.black,
              padding: EdgeInsets.all(10),
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(height: 30),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Capture',
                          style: GoogleFonts.getFont('Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        onPressed: () async {
                          pickimage_camera();
                        }),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Gallery',
                          style: GoogleFonts.getFont('Didact Gothic',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        onPressed: () async {
                          pickimage_gallery();
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loading != true
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFF7CC00),
                          ),
                          // width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Image.file(
                            _image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _output.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Classified as : ${_output[0]['label'].toString()}',
                                    style: GoogleFonts.getFont('Didact Gothic',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              )
                            : Text(
                                'Image cannot be detected',
                                style: GoogleFonts.getFont('Didact Gothic',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                        _output.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_output.isNotEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Info(_output[0]['index'])));
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Know more',
                                      style: GoogleFonts.getFont(
                                          'Didact Gothic',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26),
                                    )),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
