import 'package:flutter/material.dart';
import '../utilities/application_constants.dart';
import '../utilities/extensions.dart';

typedef void CustomTextFieldOnChangeCallBack(TextEditingController text);

class CustomTextFieldNoLabel extends StatelessWidget {
  final String? fieldTitle;
  final String? hint;
  final bool isSecure;
  final String heading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isShowCursor;
  final bool isReadOnly;
  final int maxLines;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final CustomTextFieldOnChangeCallBack? onChanged;

  CustomTextFieldNoLabel(
      {this.fieldTitle,
      this.heading = '',
      this.textEditingController,
      this.hint = '',
      this.isSecure = false,
      this.prefixIcon,
      this.suffixIcon,
      this.isShowCursor = true,
      this.isReadOnly = false,
      this.onChanged,
      this.textInputType = TextInputType.text,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var isMobileLayout = shortestSide < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        this.heading == ''
            ? Container(
                height: width * 0.0,
              )
            : Column(
                children: [
                  Text(
                    this.heading,
                    style: TextStyle(
                      fontSize: isMobileLayout ? width * 0.045 : width * 0.030,
                      color: Colors.indigo[900],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                ],
              ),
        Container(
          width: isMobileLayout ? width * 0.9 : width * 0.65,
          child: TextField(
            cursorColor: Colors.indigo[900],
            style: TextStyle(
              color: Colors.indigo[900],
              fontSize: isMobileLayout ? width * 0.045 : width * 0.03,
            ),
            showCursor: isShowCursor,
            autocorrect: false,
            controller: this.textEditingController,
            readOnly: this.isReadOnly,
            obscureText: this.isSecure,
            keyboardType: textInputType,
            maxLines: maxLines,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.indigo,
                ),
              ),
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.indigo[900],
                fontWeight: FontWeight.w300,
              ),
              prefixIcon: this.prefixIcon,
              suffixIcon: this.suffixIcon,
            ),
            onChanged: (text) => this.onChanged!(textEditingController!),
          ),
        ),
      ],
    );
  }
}
