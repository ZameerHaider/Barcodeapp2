import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application_constants.dart';
import 'extensions.dart';

class HelperFunctions {
  static String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  static saveInPreference(String preName, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(preName, value);
    print('Bismillah: In save preference function');
  }

  static clearAllPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String> getFromPreference(String preName) async {
    String returnValue = "";

    final prefs = await SharedPreferences.getInstance();
    returnValue = prefs.getString(preName) ?? "";
    return returnValue;
  }

  static checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true; //connected to mobile data
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true; // connected to a wifi network.
    } else {
      return false;
    }
  }

  static showMessageWithImage(
      BuildContext context, String message, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.width * 0.025),
            ),
          ),
          title: Container(
            height: MediaQuery.of(context).size.width * 0.17,
            width: MediaQuery.of(context).size.width * 0.17,
            child: Image(
              image: AssetImage(image),
            ),
          ),
          content: Text(
            message,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.037),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  static showAlert({
    required BuildContext context,
    String? header,
    Widget? widget,
    String btnDoneText = "",
    String btnCancelText = "",
    bool isDissmissOnTapAround = false,
    VoidCallback? onDone,
    VoidCallback? onCancel,
  }) {
    Widget doneButton = FlatButton(
      child: Text(
        btnDoneText,
        style: TextStyle(
          color: Colors.indigo[900],
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        onDone!();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text(
        btnCancelText,
        style: TextStyle(color: Colors.indigo[900]),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        onCancel!();
      },
    );

    showDialog(
      barrierDismissible: isDissmissOnTapAround,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.02),
              ),
            ),
            title: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    header!,
                    style: TextStyle(
                      color: Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
            content: widget,
            actions: <Widget>[
              btnCancelText == "" ? Container() : cancelButton,
              btnDoneText == "" ? Container() : doneButton,
            ],
          ),
        );
      },
    );
  }

  static showCustomAlert({
    required BuildContext context,
    String? header,
    Widget? widget,
    String btnDoneText = "",
    String btnCancelText = "",
    bool isDissmissOnTapAround = false,
    VoidCallback? onDone,
    VoidCallback? onCancel,
  }) {
    Widget doneButton = FlatButton(
      child: Text(
        btnDoneText,
        style: TextStyle(
          color: CustomColor.fromHex(ColorConstants.orange),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        onDone!();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text(
        btnCancelText,
        style: TextStyle(color: CustomColor.fromHex(ColorConstants.orange)),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        onCancel!();
      },
    );

    showDialog(
      barrierDismissible: isDissmissOnTapAround,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          child: AlertDialog(
            scrollable: true,
            // backgroundColor: Theme.of(context).primaryColor,
            insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: MediaQuery.of(context).size.width * 0.001,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.02),
              ),
            ),

            content: widget,
            actions: <Widget>[
              btnCancelText == "" ? Container() : cancelButton,
              btnDoneText == "" ? Container() : doneButton,
            ],
          ),
        );
      },
    );
  }

  static bool isValidPassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$';
    //r"^(?-i)(?=^.{8,}$)((?!.*\s)(?=.*[A-Z])(?=.*[a-z]))((?=(.*\d){1,})|(?=(.*\W){1,}))^.*$";
    // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!(value.contains(regex))) {
      return false;
    } else {
      return true;
    }
  }

  static bool isValidEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

    RegExp regex = new RegExp(pattern.toString());
    if (!(value.contains(regex))) {
      return false;
    } else {
      return true;
    }
  }

  static BoxShadow shadowEffect(BuildContext context) {
    return BoxShadow(
        color: Colors.grey,
        offset: Offset(4, 4),
        blurRadius: 8,
        spreadRadius: 0.1);
  }

  static BoxShadow shadowEffectForFields(BuildContext context) {
    return BoxShadow(
        offset: Offset(0, 2),
        spreadRadius: 1,
        blurRadius: 10,
        color: Colors.black38);
  }

  static BoxShadow lighterShadowEffectForFields(BuildContext context) {
    return BoxShadow(
        offset: Offset(0, 2),
        spreadRadius: MediaQuery.of(context).size.width * 0.001,
        blurRadius: MediaQuery.of(context).size.width * 0.01,
        color: Colors.black.withOpacity(0.15));
  }

  static convertHtmlToString(String htmlString) {
    //here goes the function
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static MaterialColor getColorValue(String newsType) {
    switch (newsType) {
      case "Rot":
        return Colors.red;
        break;

      case "Gelb":
        return Colors.yellow;
        break;

      case "Grün":
        return Colors.green;
        break;

      case "Grau":
        return Colors.grey;
        break;

      default:
        return Colors.red;
        break;
    }
  }
}
