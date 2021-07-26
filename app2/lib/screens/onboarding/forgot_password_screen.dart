import 'dart:convert';
import 'dart:developer';

import 'package:app2/screens/onboarding/onboarding_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  // ChangePassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final txtEmailController = TextEditingController();
  final txtconfirmPasswordController = TextEditingController();
  bool isLoading = false;

  // _btnActionSignIn(BuildContext context) {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   if (txtEmailController.text == '') {
  //     HelperFunctions.showAlert(
  //       context: context,
  //       header: StringConstants.DIALOG_TITLE,
  //       widget: Text(
  //           LocalizationManager.of(context).localize(key: 'email_required')),
  //       btnDoneText: "Ok",
  //       onDone: () {},
  //     );
  //   } else if (!HelperFunctions.isValidEmail(txtEmailController.text)) {
  //     HelperFunctions.showAlert(
  //       context: context,
  //       header: StringConstants.DIALOG_TITLE,
  //       widget:
  //           Text(LocalizationManager.of(context).localize(key: 'email_format')),
  //       btnDoneText: "OK",
  //       onDone: () {},
  //     );
  //   } else {
  //     _callAPIForgotPassword(context);
  //   }
  // }

  // _callAPIForgotPassword(BuildContext context) {
  //   this.setState(() {
  //     isLoading = true;
  //   });

  //   Map<String, dynamic> body = Map<String, dynamic>();
  //   body['Email'] = txtEmailController.text;

  //   print(txtconfirmPasswordController.text);

  //   log(jsonEncode(body));

  //   Map<String, dynamic> header = Map<String, String>();

  //   FocusScope.of(context).requestFocus(FocusNode());

  //   ApiManager networkCal =
  //       ApiManager(APIConstants.FORGOT_PASSWORD, body, false, header);
  //   networkCal.callPostAPI().then((response) async {
  //     print('Back from api');

  //     this.setState(() {
  //       isLoading = false;
  //     });

  //     bool status = response['status'];

  //     if (status == true) {
  //       String data = response['data'];

  //       HelperFunctions.showAlert(
  //         context: context,
  //         header: StringConstants.DIALOG_TITLE,
  //         widget: Text(data),
  //         btnDoneText: "Ok",
  //         onDone: () {
  //           Navigator.of(context).pop();
  //         },
  //       );
  //     } else {
  //       if (response['msg'] != null) {
  //         HelperFunctions.showAlert(
  //           context: context,
  //           header: StringConstants.DIALOG_TITLE,
  //           widget: Text(response["msg"]),
  //           btnDoneText: "Ok",
  //           onDone: () {},
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            right: size.width * 0.0,
            bottom: size.height * 0.0,
            child: Container(
                width: size.height * 0.285,
                height: size.height * 0.285,
                child: Icon(
                  Icons.qr_code_2,
                  size: size.width * 0.3,
                )),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
          ),
          OnboardingWidget(
            isNotForgotPasswordScreen: false,
            pageTitle: 'Forgot Password',
            firstFiledTitle: 'Email',
            secondFieldTitle: "",
            forgotPassword: Container(),
            doneButton: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                // _btnActionSignIn(context);
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
            passwordController: txtEmailController,
            userNameController: txtEmailController,
          ),
        ],
      ),
    );
  }
}
