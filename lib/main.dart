import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_can/profile.dart';
import 'package:trash_can/detect.dart';
import 'package:trash_can/faq.dart';
import 'package:trash_can/home.dart';
import 'package:trash_can/waste.dart';

import 'onboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  print(isLoggedIn);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasNetwork = false;
  late Timer networkTimer;

  @override
  void initState() {
    super.initState();
    checkNetworkConnection();
    startNetworkTimer();
  }

  @override
  void dispose() {
    networkTimer.cancel();
    super.dispose();
  }

  void startNetworkTimer() {
    const duration = Duration(seconds: 5);
    networkTimer = Timer.periodic(duration, (Timer timer) {
      checkNetworkConnection();
    });
  }

  Future<void> checkNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasNetwork = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trash Can',
      theme: ThemeData(),
      home: hasNetwork
          ? (widget.isLoggedIn ? Nav() : OnboardScreen())
          : NoNetworkPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NoNetworkPage extends StatefulWidget {
  @override
  _NoNetworkPageState createState() => _NoNetworkPageState();
}

class _NoNetworkPageState extends State<NoNetworkPage> {
  bool hasNetwork = false;
  late Timer networkTimer;

  @override
  void initState() {
    super.initState();
    checkNetworkConnection();
    startNetworkTimer();
  }

  @override
  void dispose() {
    networkTimer.cancel();
    super.dispose();
  }

  void startNetworkTimer() {
    const duration = Duration(seconds: 5);
    networkTimer = Timer.periodic(duration, (Timer timer) {
      checkNetworkConnection();
    });
  }

  Future<void> checkNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasNetwork = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasNetwork) {
      return OnboardScreen();
    }

    return Scaffold(
      // backgroundColor: Color.fromRGBO(255,255,255,25),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/images/nonetwork1.jpg',
                fit: BoxFit.fill,
              ),
            ),
            // Text(
            //   'No Network Connection',
            //   style: TextStyle(fontSize: 20),
            // ),
          ],
        ),
      ),
    );
  }
}

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int currentIndex = 0;
  String currentTitle = '';

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
      if (index == 0)
        currentTitle = "Home";
      else if (index == 1) currentTitle = "Classify";
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final List<Widget> _pages = <Widget>[
      HomePage(),
      Waste(),
      const Predict(),
      FAQs(),
      const MyProfile()
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDD0),
      body: Stack(
        children: [
          Center(
            child: _pages[currentIndex],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Column(
                    children: [
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          onPressed: () {
                            setBottomBarIndex(2);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Text(
                        'Classify',
                        style: GoogleFonts.getFont('Didact Gothic',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.house,
                                color: currentIndex == 0
                                    ? Colors.grey
                                    : Colors.black,
                                size: 25,
                              ),
                              onPressed: () {
                                setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                            Text(
                              'Home',
                              style: GoogleFonts.getFont('Didact Gothic',
                                  color: currentIndex == 0
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.glassWater,
                                color: currentIndex == 1
                                    ? Colors.grey
                                    : Colors.black,
                                size: 25,
                              ),
                              onPressed: () {
                                setBottomBarIndex(1);
                              },
                              splashColor: Colors.white,
                            ),
                            Text(
                              'Tips',
                              style: GoogleFonts.getFont('Didact Gothic',
                                  color: currentIndex == 1
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width * 0.2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.circleInfo,
                                  color: currentIndex == 3
                                      ? Colors.grey
                                      : Colors.black,
                                  size: 25,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(3);
                                }),
                            Text(
                              '  FAQs',
                              style: GoogleFonts.getFont('Didact Gothic',
                                  color: currentIndex == 3
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.user,
                                  color: currentIndex == 4
                                      ? Colors.grey
                                      : Colors.black,
                                  size: 25,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(4);
                                }),
                            Text(
                              '  Profile',
                              style: GoogleFonts.getFont('Didact Gothic',
                                  color: currentIndex == 4
                                      ? Colors.grey
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = const Color(0xFFF7CC00)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
