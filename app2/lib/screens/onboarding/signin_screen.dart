import 'dart:convert';
import 'dart:developer';

import 'package:app2/screens/home/DashboardScreen.dart';
import 'package:app2/screens/managers/api_manager.dart';
import 'package:app2/screens/onboarding/forgot_password_screen.dart';
import 'package:app2/screens/onboarding/onboarding_widget.dart';
import 'package:app2/screens/onboarding/signUpScreen.dart';
import 'package:app2/screens/utilities/api_constants.dart';
import 'package:app2/screens/utilities/helper_functions.dart';
import 'package:app2/screens/widgets/custom_loader.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  _btnActionSignIn(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtUserNameController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Username is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtPasswordController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Password is required"),
        btnDoneText: "pl",
        onDone: () {},
      );
    } else {
      _callAPILogin(context);
    }
  }

  bool isLoading = false;
  _callAPILogin(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();
    body['email'] = txtUserNameController.text;
    body['password'] = txtPasswordController.text;

    log(jsonEncode(body));
    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal = ApiManager(APIConstants.login, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['isSuccess'];
      if (status == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DashBoardScreen()),
            (Route<dynamic> route) => false);
      } else {
        if (response['message'] != null) {
          HelperFunctions.showAlert(
            context: context,
            header: "App2",
            widget: Text(response["message"]),
            btnDoneText: "Ok",
            onDone: () {},
          );
        }
      }
    });
  }

  final txtUserNameController = TextEditingController();
  final txtPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
            ),
            OnboardingWidget(
              pageTitle: "Sign in",
              firstFiledTitle: "Email",
              secondFieldTitle: "Password",
              forgotPassword: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ForgotPasswordScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.indigo[900],
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              doneButton: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _btnActionSignIn(context);
                },
                child: Container(
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.indigo[900],
                    borderRadius: BorderRadius.all(
                      Radius.circular(size.width * 0.15),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.arrow_forward,
                    size: size.width * 0.085,
                    color: Colors.white,
                  )),
                ),
              ),
              passwordController: txtPasswordController,
              userNameController: txtUserNameController,
            ),
            Positioned(
                bottom: size.height * 0.08,
                left: size.width * 0.2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpScreen()));
                  },
                  child: Text(
                    "Don't have account? Sign up",
                    style: TextStyle(
                      color: Colors.indigo[900],
                      fontSize: size.width * 0.043,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
