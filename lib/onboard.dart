import 'package:flutter/material.dart';
import 'package:trash_can/model/allinoneboard.dart';



import 'constant/constant.dart';
import 'login.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;
  final _pageController = PageController();

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel(
        "assets/images/designf.jpg",
        "Welcome to Waste Wizard! Join us in our mission to protect the environment and promote sustainable waste management.",
        "Welcome to Waste Wizard"),
    AllinOnboardModel(
        "assets/images/designs.jpg",
        "Our feedback system allows you to share your thoughts, suggestions, and concerns directly with us.",
        "Feedback System"),
    AllinOnboardModel(
        "assets/images/designt.jpg",
        "Get ready to compete and climb the ranks with our interactive leaderboard!",
        "Interactive Leaderboard"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   // title: Text(
      //   //   "Food Express",
      //   //   style: TextStyle(color: primarygreen),
      //   // ),
      //   backgroundColor: Colors.white,
      // ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: allinonboardlist.length,
              itemBuilder: (context, index) {
                return PageBuilderWidget(
                    title: allinonboardlist[index].titlestr,
                    description: allinonboardlist[index].description,
                    imgurl: allinonboardlist[index].imgStr);
              }),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.14,
            left: MediaQuery.of(context).size.width * 0.44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allinonboardlist.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
          currentIndex < allinonboardlist.length - 1
              ? Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      currentIndex == 0
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _pageController.animateToPage(
                                      allinonboardlist.length - 1,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                });
                              },
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 18, color: primarygreen),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: lightgreenshede1,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0))),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentIndex--;
                                  _pageController.animateToPage(currentIndex,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                });
                              },
                              child: Text(
                                "Previous",
                                style: TextStyle(
                                    fontSize: 18, color: primarygreen),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: lightgreenshede1,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0))),
                              ),
                            ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex++;
                            _pageController.animateToPage(currentIndex,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: primarygreen),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: lightgreenshede1,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0))),
                        ),
                      )
                    ],
                  ),
                )
              : Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.width * 0.36,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return LoginScreen();
                      }));
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(fontSize: 18, color: primarygreen),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: lightgreenshede1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? primarygreen : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  String title;
  String description;
  String imgurl;
  PageBuilderWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.imgurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
      // color: Colors.amberAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100,),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Image.asset(imgurl),
          ),
          const SizedBox(
            height: 20,
          ),
          //Tite Text
          Text(title,
              style: TextStyle(
                  color: primarygreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 40,
          ),
          
          //discription
          Text(description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primarygreen,
                fontSize: 18,
              ))
        ],
      ),
    );
  }
}
