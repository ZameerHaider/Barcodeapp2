class GetBarcodeObject {
  GetBarcodeObject({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  bool isSuccess;
  String message;
  BarcodeData? data;

  factory GetBarcodeObject.fromMap(Map<String, dynamic> json) =>
      GetBarcodeObject(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : BarcodeData.fromMap(json["data"]),
      );
}

class BarcodeData {
  BarcodeData({
    this.item,
    this.barcode,
    this.scannedOn,
    this.qty,
    this.itemDescription,
    this.itemSku,
    this.itemPhoto,
    this.sacnType,
  });

  int? item;
  String? barcode;
  DateTime? scannedOn;
  int? qty;
  String? itemDescription;
  String? itemSku;
  dynamic itemPhoto;
  dynamic sacnType;

  factory BarcodeData.fromMap(Map<String, dynamic> json) => BarcodeData(
        item: json["item"] == null ? null : json["item"],
        barcode: json["barcode"] == null ? null : json["barcode"],
        scannedOn: json["scannedOn"] == null
            ? null
            : DateTime.parse(json["scannedOn"]),
        qty: json["qty"] == null ? null : json["qty"],
        itemDescription:
            json["itemDescription"] == null ? null : json["itemDescription"],
        itemSku: json["itemSku"] == null ? null : json["itemSku"],
        itemPhoto: json["itemPhoto"],
        sacnType: json["sacnType"],
      );
}
