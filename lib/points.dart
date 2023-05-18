import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Points extends StatefulWidget {
  const Points({super.key});

  @override
  State<Points> createState() => _PointsState();
}

class _PointsState extends State<Points> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          
          child: ListView.builder(
            itemCount: materialsPoints.length,
            itemBuilder: (context, index) {
          final material = materialsPoints.keys.elementAt(index);
          final points = materialsPoints[material];
          return Card(
            child: ListTile(tileColor: Color(0xFFF7CC00),
              title: Text(material),
              subtitle: Text('$points points'),
            ),
          );
            },
          ),
        ),
      ),
    );
  }
}