class RolesObject {
  RolesObject({
    this.isSuccess,
    this.message,
    this.data,
  });

  bool? isSuccess;
  String? message;
  List<Roles>? data;

  factory RolesObject.fromMap(Map<String, dynamic> json) => RolesObject(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Roles>.from(json["data"].map((x) => Roles.fromMap(x))),
      );
}

class Roles {
  Roles({
    this.id,
    this.name,
    this.createdOn,
    this.loginDetails,
  });

  int? id;
  String? name;
  DateTime? createdOn;
  List<dynamic>? loginDetails;

  factory Roles.fromMap(Map<String, dynamic> json) => Roles(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        loginDetails: json["loginDetails"] == null
            ? null
            : List<dynamic>.from(json["loginDetails"].map((x) => x)),
      );
}
