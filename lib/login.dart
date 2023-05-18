import 'package:flutter/material.dart';
import 'package:trash_can/main.dart';

import 'firebase_services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF7CC00),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgrouond_image.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Positioned(
              bottom: 150,
              left: 10,
              right: 10,
              child: GestureDetector(
  onTap: () async {
    await FirebaseServices().signInWithGoogle();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Nav();
    }));
  },
  child: Container(
   width: 300,
    decoration: BoxDecoration(
      // border: Border.all(width: 1.0, color: Colors.black),
    ),
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage("assets/google.png"),
          height: 35.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    ),
  ),
)

            ),
          ],
        ),
      ),
    );
  }
}
