class DepartmentObject {
  DepartmentObject({
    this.isSuccess,
    this.message,
    this.data,
  });

  bool? isSuccess;
  String? message;
  List<Department>? data;

  factory DepartmentObject.fromMap(Map<String, dynamic> json) =>
      DepartmentObject(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Department>.from(
                json["data"].map((x) => Department.fromMap(x))),
      );
}

class Department {
  Department({
    this.id,
    this.name,
    this.createdOn,
    this.loginDetails,
  });

  int? id;
  String? name;
  DateTime? createdOn;
  List<dynamic>? loginDetails;

  factory Department.fromMap(Map<String, dynamic> json) => Department(
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
