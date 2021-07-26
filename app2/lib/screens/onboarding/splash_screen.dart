import 'dart:developer';

import 'package:app2/screens/home/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:async';

import 'signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  String? userId;
  void moveToNextScreen(BuildContext ctx) {
    print('In Next Screen');
    print(userId);
    if (userId != null && userId != "") {
      _moveToHomeVC(context);
    } else {
      _moveToLoginVC(context);
    }
  }

  _moveToHomeVC(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return DashBoardScreen();
        },
      ),
    );
  }

  _moveToLoginVC(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return SignInScreen();
        },
      ),
    );
  }

  _startTimer() {
    Timer(Duration(seconds: 3, milliseconds: 500), () {
      moveToNextScreen(context);
    });
  }

  void printScreenSize(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    log("width = $width and height = $height");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    printScreenSize(context);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code,
            size: size.width * 0.25,
            color: Colors.indigo[900],
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          Container(
            height: size.width * 0.09,
            width: size.width * 0.09,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.5),
            ),
            child: LoadingIndicator(
                colors: [Colors.indigo],
                indicatorType: Indicator.ballRotateChase),
          ),
        ],
      ),
    ));
  }
}
