import 'package:app2/screens/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import '../utilities/application_constants.dart';
import '../utilities/extensions.dart';

typedef void CustomTextFieldOnChangeCallBack(TextEditingController text);

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool isSecure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isShowCursor;
  final bool isReadOnly;
  final int maxLines;
  final double fieldWidth;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final CustomTextFieldOnChangeCallBack? onChanged;
  final bool isVisible;
  final bool enabled;
  CustomTextField(
      {this.textEditingController,
      this.hint = '',
      this.isSecure = false,
      this.prefixIcon,
      this.fieldWidth = 0.0,
      this.suffixIcon,
      this.isShowCursor = true,
      this.isReadOnly = false,
      this.onChanged,
      this.textInputType = TextInputType.text,
      this.maxLines = 1,
      this.isVisible = true,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isVisible
        ? Container(
            margin: EdgeInsets.only(bottom: width * 0.065),
            width: this.fieldWidth == 0.0 ? width * 0.9 : this.fieldWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(width * 0.01),
              ),
              boxShadow: [
                HelperFunctions.shadowEffectForFields(context),
              ],
            ),
            child: TextField(
              cursorColor: CustomColor.fromHex(ColorConstants.textField),
              style: TextStyle(
                fontSize: width * 0.045,
              ),
              enabled: this.enabled,
              showCursor: isShowCursor,
              autocorrect: false,
              controller: this.textEditingController,
              readOnly: this.isReadOnly,
              obscureText: this.isSecure,
              keyboardType: textInputType,
              maxLines: maxLines,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  top: width * 0.035,
                  bottom: width * 0.03,
                  right: 0,
                  left: width * 0.035,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    style: BorderStyle.solid,
                    color: Colors.indigo,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: textEditingController!.text == ''
                          ? Colors.indigo
                          : isReadOnly == true
                              ? Colors.black
                              : Colors.indigo),
                ),
                labelStyle: TextStyle(
                    fontSize: width * 0.04, color: Colors.indigo[900]),
                labelText: this.hint,
                prefixIcon: this.prefixIcon,
                suffixIcon: this.suffixIcon,
              ),
              // onChanged: (text) {
              //   print(text);
              //   if (text != null) {
              //     this.onChanged!(textEditingController!);
              //   }
              // }
            ),
          )
        : Container();
  }
}
