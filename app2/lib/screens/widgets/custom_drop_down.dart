import 'package:app2/screens/widgets/custom_text_field_nolabel.dart';
import 'package:flutter/material.dart';

import 'selection_object.dart';

typedef void SelectionCallBack(SelectionObject selectionObject);

class CustomDropDown extends StatelessWidget {
  final List<SelectionObject>? array;
  final SelectionCallBack? onClickHandler;
  final TextEditingController? textEditingController;
  final String? hint;
  final String heading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int ismaxlines;
  CustomDropDown({
    this.array,
    this.heading = '',
    this.onClickHandler,
    this.textEditingController,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.ismaxlines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomTextFieldNoLabel(
          hint: hint,
          isShowCursor: false,
          isReadOnly: true,
          heading: this.heading,
          prefixIcon: prefixIcon,
          textEditingController: textEditingController,
        ),
        Container(
          //color: Colors.grey,
          // padding: EdgeInsets.only(
          //   top: width * 0.04,
          //   bottom: width * 0.03,
          // ),
          // margin: EdgeInsets.only(
          //   top: MediaQuery.of(context).size.height * 0.02,
          // ),
          width: MediaQuery.of(context).size.width * 0.86,
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<SelectionObject>(
                isExpanded: true,
                icon: Padding(
                  padding:
                      EdgeInsets.only(top: width * 0.06, right: width * 0.01),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.indigo[900],
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                ),
                items: array?.map((obj) {
                  return DropdownMenuItem<SelectionObject>(
                    // Added this line to stop text field from fucusing again when Item is selected in drop down
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    // Ends Here // By Zameer
                    value: obj,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          "   " + obj.title.toString(),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.037),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Divider(
                          thickness: 0.7,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: ((dropitem) {
                  this.onClickHandler!(dropitem!);
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
