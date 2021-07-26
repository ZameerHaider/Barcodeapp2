import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app2/screens/home/models/GetBarcodeDataObject.dart';
import 'package:app2/screens/home/qr_create_page.dart';
import 'package:app2/screens/managers/api_manager.dart';
import 'package:app2/screens/utilities/api_constants.dart';
import 'package:app2/screens/utilities/helper_functions.dart';

import 'package:app2/screens/widgets/customButton.dart';
import 'package:app2/screens/widgets/custom_loader.dart';
import 'package:app2/screens/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String qrCode = 'Unknown';
  bool isLoading = false;
  File? _image;
  final imagePicker = ImagePicker();
  List<CustomMultipartObject> files = [];

  final txtQtyController = TextEditingController();
  final txtItemDescriptionController = TextEditingController();
  final txtItemSkuController = TextEditingController();

  final txtbarcodeController = TextEditingController();

  GetBarcodeObject? getBarcodeObject;
  BarcodeData? barcodeData;
  Future chooseImage(BuildContext context, ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.041),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QRCreatePage()));
                },
                icon: Icon(
                  Icons.add_box,
                  size: size.width * 0.065,
                ))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          children: [
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
                            size: MediaQuery.of(context).size.width * 0.085,
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
                            size: MediaQuery.of(context).size.width * 0.065,
                          ))
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                scanQRCode();
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  hint: "Scan Code",
                  textEditingController: txtbarcodeController,
                ),
              ),
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
            SizedBox(
              height: size.height * 0.01,
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
            SizedBox(height: size.height * 0.03),
            // Text(
            //   'Scan Result',
            //   style: TextStyle(
            //     fontSize: size.width * 0.039,
            //     color: Colors.indigo[900],
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: size.height * 0.01),
            // Text(
            //   '$qrCode',
            //   style: TextStyle(
            //     fontSize: size.width * 0.039,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.indigo[900],
            //   ),
            // ),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        if (qrCode != "-1") {
          txtbarcodeController.text = qrCode;
          _callAPIGetDataFromBarcode(context: context, barcode: qrCode);
        }
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
