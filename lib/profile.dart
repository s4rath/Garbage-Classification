import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_can/leaderboard.dart';
import 'package:trash_can/login.dart';

import 'points.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int totSum = 0;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future<List<DocumentSnapshot>> retrievePoints(String uid) async {
    final pointsRef = FirebaseFirestore.instance
        .collection('garbageDB')
        .doc(uid)
        .collection('points');
    final querySnapshot = await pointsRef.get();
    return querySnapshot.docs;
  }

  Future sumPoints(String uid) async {
    List<DocumentSnapshot<Object?>> documents = await retrievePoints(uid);
    int sum = 0;
    for (final doc in documents) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      sum += data['point'] as int;
    }
    print(sum);

    setState(() {
      totSum = sum;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    sumPoints(uid);
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDD0),
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Color(0xFFF7CC00),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            child: Icon(Icons.more_vert),
            onSelected: (String value) async {
              switch (value) {
                case 'logout':
                  {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    // await FirebaseAuth.instance.signOut();
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (ctx) {
                    //   return LoginScreen();
                    // }));
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((ctx) {
                        return LoginScreen();
                      })));
                    });
                  }

                  break;
                case 'points':
                  {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return Points();
                    }));
                  }
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'points',
                child: Text('Points'),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 5, 5, 0),
            child: Card(
              // elevation: 20,
              // shadowColor: Colors.black,
              color: Color(0xFFFFFDD0),
              child: SizedBox(
                width: 300,
                height: 380,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green[500],
                        radius: 108,
                        child: CircleAvatar(
                          backgroundImage: Image.network((FirebaseAuth
                                  .instance.currentUser!.photoURL)!)
                              .image,
                          radius: 106,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        (FirebaseAuth.instance.currentUser!.displayName!),
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Points: $totSum',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.green[900],
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 47, top: 50),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){return LeaderboardScreen();}));
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
                  'Leaderboard',
                  style: GoogleFonts.getFont('Didact Gothic',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
