import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app2/screens/home/models/GetBarcodeDataObject.dart';
import 'package:app2/screens/managers/api_manager.dart';
import 'package:app2/screens/utilities/api_constants.dart';
import 'package:app2/screens/utilities/helper_functions.dart';
import 'package:app2/screens/widgets/customButton.dart';
import 'package:app2/screens/widgets/custom_loader.dart';
import 'package:app2/screens/widgets/custom_textfield.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QRCreatePage extends StatefulWidget {
  @override
  _QRCreatePageState createState() => _QRCreatePageState();
}

class _QRCreatePageState extends State<QRCreatePage> {
  final txtQtyController = TextEditingController();
  final txtItemDescriptionController = TextEditingController();
  final txtItemSkuController = TextEditingController();

  final txtbarcodeController = TextEditingController();
  File? _image;
  final imagePicker = ImagePicker();
  List<CustomMultipartObject> files = [];
  Future chooseImage(BuildContext context, ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  // _getFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     _image = File(result.files.single.path.toString());
  //   } else {
  //     // User canceled the picker
  //   }
  //   Navigator.pop(context);
  //   setState(() {
  //     this._image = _image;
  //   });
  // }
  GetBarcodeObject? getBarcodeObject;
  BarcodeData? barcodeData;
  _callAPIGetDataFromBarcode(
      {required BuildContext context, required String barcode}) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();
    body['barCode'] = barcode;

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getDataFromBarCode, body, false, header);
    networkCal.callPostAPI(context).then((response) async {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['isSuccess'];

      if (status == true) {
        getBarcodeObject = GetBarcodeObject.fromMap(response);
        if (response['data'] != null) {
          barcodeData = getBarcodeObject?.data;
          HelperFunctions.showAlert(
            context: context,
            header: "App2",
            widget: Text(response['message']),
            btnDoneText: "Ok",
            onDone: () {},
          );
          txtItemSkuController.text = barcodeData!.item.toString();
          txtItemDescriptionController.text = barcodeData!.itemDescription!;
        } else {
          txtItemDescriptionController.clear();
          txtItemSkuController.clear();
          HelperFunctions.showAlert(
              context: context,
              header: "App2",
              widget: Text(response['message']),
              btnDoneText: "Ok",
              onDone: () {});
        }
      } else {
        if (response['message'] != null) {
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

  bool isLoading = false;
  _btnActionCreateBarCode(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtbarcodeController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Barcode is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtItemDescriptionController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Item description is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtItemSkuController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Item sku is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (txtQtyController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Item Qty is required"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else if (_radioValue1 == "0") {
      HelperFunctions.showAlert(
        context: context,
        header: "App2",
        widget: Text("Please select scaned type"),
        btnDoneText: "ok",
        onDone: () {},
      );
    } else {
      _callGenrateBarCodeApi(context);
    }
  }

  _callGenrateBarCodeApi(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, String> body = Map<String, String>();

    // body['Item'] = txtItemSkuController.text;
    body['Barcode'] = txtbarcodeController.text;
    body['Qty'] = txtQtyController.text;
    body['ItemDescription'] = txtItemDescriptionController.text;
    body['ItemSku'] = txtItemSkuController.text;
    if (_radioValue1 == "1") {
      body['SacnType'] = "Scanned in";
    } else if (_radioValue1 == "2") {
      body['SacnType'] = "Scanned out";
    }

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    if (_image != null) {
      CustomMultipartObject obj =
          CustomMultipartObject(file: _image, param: "ItemPhoto");
      files.add(obj);
    }

    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.genrateBarcode, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['isSuccess'];
      if (status == true) {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {
              setState(() {
                _image = null;
                txtbarcodeController.clear();
                txtItemDescriptionController.clear();
                txtItemSkuController.clear();
                txtQtyController.clear();
                _radioValue1 = "0";
              });
            },
            onCancel: () {});
      } else {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {},
            onCancel: () {});
      }
    });
  }

  String _radioValue1 = "0";

  @override
  Widget build(BuildContext context) => CustomLoader(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Create Bar Code",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.041)),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    color: Colors.black,
                    data: txtbarcodeController.text,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  GestureDetector(
                    onTap: () {
                      chooseImage(context, ImageSource.camera);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05)),
                          child: _image == null
                              ? Icon(
                                  Icons.add_a_photo,
                                  size:
                                      MediaQuery.of(context).size.width * 0.085,
                                  color: Colors.indigo[900],
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        _image == null
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[200],
                                  size:
                                      MediaQuery.of(context).size.width * 0.065,
                                ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "Enter Code",
                          textEditingController: txtbarcodeController,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.05),
                        child: IconButton(
                            onPressed: () {
                              this.setState(() {
                                if (txtbarcodeController.text != null &&
                                    txtbarcodeController.text != "") {
                                  _callAPIGetDataFromBarcode(
                                      context: context,
                                      barcode: txtbarcodeController.text);
                                }
                              });
                            },
                            icon: Icon(
                              Icons.check_circle_outline,
                              color: Colors.indigo[900],
                              size: MediaQuery.of(context).size.width * 0.085,
                            )),
                      )
                    ],
                  ),
                  CustomTextField(
                    hint: "Item Description",
                    textEditingController: txtItemDescriptionController,
                  ),
                  CustomTextField(
                    hint: "Item Sku",
                    textEditingController: txtItemSkuController,
                  ),
                  CustomTextField(
                    hint: "Qty",
                    textEditingController: txtQtyController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: "1",
                        groupValue: _radioValue1,
                        onChanged: (val) {
                          setState(() {
                            _radioValue1 = val.toString();
                          });
                        },
                      ),
                      Text(
                        'Scaned in',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        value: "2",
                        groupValue: _radioValue1,
                        onChanged: (val) {
                          setState(() {
                            _radioValue1 = val.toString();
                          });
                        },
                      ),
                      new Text(
                        'Scaned out',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Custombutton(
                    backgroundColor: Colors.indigo[900],
                    isTitleBold: true,
                    title: "Save",
                    titleColor: Colors.white,
                    onPress: () {
                      _btnActionCreateBarCode(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  // Widget buildTextField(BuildContext context) => TextField(
  //       controller: controller,
  //       style: TextStyle(
  //         color: Colors.indigo[900],
  //         fontWeight: FontWeight.bold,
  //         fontSize: MediaQuery.of(context).size.width * 0.043,
  //       ),
  //       decoration: InputDecoration(
  //         hintText: 'Enter the data',
  //         hintStyle: TextStyle(
  //             color: Colors.grey,
  //             fontSize: MediaQuery.of(context).size.width * 0.043),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius:
  //               BorderRadius.circular(MediaQuery.of(context).size.width * 0.04),
  //           borderSide: BorderSide(color: Colors.grey),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius:
  //               BorderRadius.circular(MediaQuery.of(context).size.width * 0.04),
  //           borderSide: BorderSide(
  //             color: Theme.of(context).primaryColor,
  //           ),
  //         ),
  //       ),
  //     );
}
