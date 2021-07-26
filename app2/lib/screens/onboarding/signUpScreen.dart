import 'dart:convert';
import 'dart:developer';

import 'package:app2/screens/managers/api_manager.dart';
import 'package:app2/screens/onboarding/models/getDepartmentObject.dart';
import 'package:app2/screens/onboarding/models/getRolesObject.dart';
import 'package:app2/screens/onboarding/onboarding_widget.dart';
import 'package:app2/screens/onboarding/signin_screen.dart';
import 'package:app2/screens/utilities/api_constants.dart';
import 'package:app2/screens/utilities/helper_functions.dart';
import 'package:app2/screens/widgets/customButton.dart';
import 'package:app2/screens/widgets/custom_drop_down.dart';
import 'package:app2/screens/widgets/custom_loader.dart';
import 'package:app2/screens/widgets/custom_onbording_textfield.dart';
import 'package:app2/screens/widgets/selection_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SignUpScreen extends StatefulWidget {
  // ChangePassword({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetRoles(context);
      _callAPIGetDEpartment(context);
    });
  }

  final txtuserNameController = TextEditingController();
  final txtpasswordController = TextEditingController();
  final txtemailController = TextEditingController();
  final txtDepartmentController = TextEditingController();
  final txtRolesController = TextEditingController();
  List<SelectionObject> arrayRolesList = [];
  List<SelectionObject> arrayDepartmentList = [];
  bool isLoading = false;

  _btnActionSignUp(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtuserNameController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Username is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtemailController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Email is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (!HelperFunctions.isValidEmail(txtemailController.text)) {
      HelperFunctions.showAlert(
        context: context,
        header: "Attention",
        widget: Text("Email Should be of format example@example.com"),
        btnDoneText: "Ok",
        onDone: () {},
      );
    } else if (txtpasswordController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Password is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtRolesController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Please select role"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtDepartmentController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Please select department"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else {
      _callAPISignUp(context);
    }
  }

  RolesObject? rolesObject;
  List<Roles>? roles;

  _callAPIGetRoles(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getRolesList, body, false, header);
    networkCal.callGetAPI(context).then((response) async {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['isSuccess'];
      if (status == true) {
        rolesObject = RolesObject.fromMap(response);
        if (rolesObject != null) {
          roles = rolesObject?.data;
          roles?.forEach((element) {
            SelectionObject selectionObj = SelectionObject(
                id: element.id.toString(),
                title: element.name,
                value: element.name);
            arrayRolesList.add(selectionObj);
          });
          print("printing roles " + roles!.length.toString());
        }
      } else {
        if (response['msg'] != null) {
          HelperFunctions.showAlert(
            context: context,
            header: "App2",
            widget: Text(response['message']),
            btnDoneText: "Ok",
            onDone: () {},
          );
        }
      }
    });
  }

  DepartmentObject? departmentObject;
  List<Department>? department;
  _callAPIGetDEpartment(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getDepartmentList, body, false, header);
    networkCal.callGetAPI(context).then((response) async {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['isSuccess'];
      if (status == true) {
        departmentObject = DepartmentObject.fromMap(response);
        if (departmentObject != null) {
          department = departmentObject?.data;
          department?.forEach((element) {
            SelectionObject selectionObject = SelectionObject(
                id: element.id.toString(),
                title: element.name,
                value: element.name);
            arrayDepartmentList.add(selectionObject);
          });
          print("printing department" + department!.length.toString());
        }
      } else {
        if (response['msg'] != null) {
          HelperFunctions.showAlert(
            context: context,
            header: "App2",
            widget: Text(response['message']),
            btnDoneText: "Ok",
            onDone: () {},
          );
        }
      }
    });
  }

  late int _selectedRole;
  late int _selectedDeparment;

  _callAPISignUp(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();
    body['Email'] = txtemailController.text;
    body['UserName'] = txtuserNameController.text;
    body['Role'] = _selectedRole;
    body['Department'] = _selectedDeparment;

    body['Password'] = txtpasswordController.text;
    log(jsonEncode(body));
    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.register, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['isSuccess'];
      if (status == true) {
        HelperFunctions.showAlert(
          context: context,
          header: "App2",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignInScreen()));
          },
        );
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Sign up"),
        ),
        body: ListView(
          padding: EdgeInsets.all(size.width * 0.05),
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            // Positioned(
            //   right: size.width * 0.0,
            //   bottom: size.height * 0.0,
            //   child: Container(
            //     width: size.height * 0.285,
            //     height: size.height * 0.285,
            //     child: Image.asset(
            //       "resources/images/signinLogo.png",
            //     ),
            //   ),
            // ),
            OnBoardingTextField(
              lableText: "Username",
              texteditingController: txtuserNameController,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),

            OnBoardingTextField(
              lableText: "Email",
              texteditingController: txtemailController,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            OnBoardingTextField(
              lableText: "Password",
              texteditingController: txtpasswordController,
              isSecure: true,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            CustomDropDown(
              array: arrayRolesList,
              hint: "Role",
              textEditingController: txtRolesController,
              onClickHandler: (val) {
                txtRolesController.text = val.title.toString();
                _selectedRole = int.parse(val.id.toString());
              },
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            CustomDropDown(
              array: arrayDepartmentList,
              hint: "Department",
              textEditingController: txtDepartmentController,
              onClickHandler: (value) {
                txtDepartmentController.text = value.title.toString();
                _selectedDeparment = int.parse(value.id.toString());
              },
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Custombutton(
              backgroundColor: Colors.indigo[900],
              isTitleBold: true,
              title: "Sign up",
              onPress: () {
                _btnActionSignUp(context);
              },
              titleColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
