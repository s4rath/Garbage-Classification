import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class FeeDBack extends StatefulWidget {

  FeeDBack({Key? key, });
  // final String scannedItem;
  @override
  State<FeeDBack> createState() => _FeeDBackState();
}

class _FeeDBackState extends State<FeeDBack> {
  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final List<String> wasteItems = [
    'battery',
    'biological',
    'brown-glass',
    'cardboard',
    'clothes',
    'green-glass',
    'metal',
    'paper',
    'plastic',
    'shoes',
    'trash',
    'white-glass',
  ];
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
  String? originalWaste;
  String? classifiedWaste;
  String? feedback;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveFeedbackToFirestore();
      int points = materialsPoints[classifiedWaste]!;
      int subpoint = -points;
      addPointDocument(classifiedWaste!, subpoint!);
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

  Future<void> _saveFeedbackToFirestore() async {
    try {
      final feedbackData = {
        'original_waste': originalWaste,
        'classified_waste': classifiedWaste,
        'feedback': feedback,
      };

      await FirebaseFirestore.instance.collection('feedback').add(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback saved successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save feedback. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDD0),
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Color(0xFFF7CC00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: originalWaste,
                decoration: InputDecoration(
                  labelText: 'Original Waste Type',
                ),
                items: wasteItems.map((wasteItem) {
                  return DropdownMenuItem<String>(
                    value: wasteItem,
                    child: Text(wasteItem),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    originalWaste = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
               DropdownButtonFormField<String>(
                value: classifiedWaste,
                decoration: InputDecoration(
                  labelText: 'Classified Result Type',
                ),
                items: wasteItems.map((wasteItem) {
                  return DropdownMenuItem<String>(
                    value: wasteItem,
                    child: Text(wasteItem),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    classifiedWaste = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Feedback',
                ),
                onSaved: (value) {
                  feedback = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide feedback';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    _submitForm();
                  },
                  child: Container(
                    height: 60,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Center(
                        child: Text(
                      'Submit',
                      style: GoogleFonts.getFont('Didact Gothic',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    )),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: _submitForm,
              //   child: Text('Submit'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
