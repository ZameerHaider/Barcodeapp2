import 'package:flutter/material.dart';

class OnBoardingTextField extends StatelessWidget {
  bool isSecure = false;
  String? lableText = "";
  var texteditingController;
  OnBoardingTextField(
      {this.isSecure = false, this.lableText, this.texteditingController});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return TextField(
      controller: texteditingController,
      cursorColor: Colors.indigo[900],
      obscureText: isSecure,
      style: TextStyle(
        color: Colors.indigo[900],
        fontSize: size.width * 0.05,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.only(bottom: 10),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.indigo,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.indigo,
          ),
        ),
        hintText: this.lableText,
        hintStyle: TextStyle(
          color: Colors.indigo[900],
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
