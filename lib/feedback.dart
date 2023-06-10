import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FeeDBack extends StatefulWidget {
  const FeeDBack({super.key});

  @override
  State<FeeDBack> createState() => _FeeDBackState();
}

class _FeeDBackState extends State<FeeDBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Color(0xFFF7CC00),
      ),
      body: Column(),
    );
  }
}
