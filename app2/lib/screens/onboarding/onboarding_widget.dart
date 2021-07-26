import 'package:app2/screens/widgets/custom_onbording_textfield.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  var userNameController;
  var passwordController;
  String? pageTitle;
  String? firstFiledTitle;
  String? secondFieldTitle;
  Widget forgotPassword;
  Widget doneButton;
  bool isNotForgotPasswordScreen;
  bool isChangePassword;

  OnboardingWidget(
      {this.userNameController,
      this.passwordController,
      this.pageTitle,
      this.firstFiledTitle,
      this.secondFieldTitle,
      required this.forgotPassword,
      required this.doneButton,
      this.isNotForgotPasswordScreen = true,
      this.isChangePassword = false});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.23,
              ),
              Text(
                pageTitle!,
                style: TextStyle(
                  fontSize: size.height * 0.04,
                  color: Colors.indigo[900],
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              OnBoardingTextField(
                lableText: firstFiledTitle,
                isSecure: isChangePassword ? true : false,
                texteditingController: userNameController,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Visibility(
                visible: isNotForgotPasswordScreen,
                child: OnBoardingTextField(
                  lableText: secondFieldTitle,
                  texteditingController: passwordController,
                  isSecure: true,
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Row(
                children: [Expanded(child: forgotPassword), doneButton],
              ),
              SizedBox(
                height: size.height * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }
}
