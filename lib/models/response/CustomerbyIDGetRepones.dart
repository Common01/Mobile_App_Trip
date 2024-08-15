// To parse this JSON data, do
//
//     final customerbyIdGetRepones = customerbyIdGetReponesFromJson(jsonString);

import 'dart:convert';

CustomerbyIdGetRepones customerbyIdGetReponesFromJson(String str) =>
    CustomerbyIdGetRepones.fromJson(json.decode(str));

String customerbyIdGetReponesToJson(CustomerbyIdGetRepones data) =>
    json.encode(data.toJson());

class CustomerbyIdGetRepones {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CustomerbyIdGetRepones({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CustomerbyIdGetRepones.fromJson(Map<String, dynamic> json) =>
      CustomerbyIdGetRepones(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
      };
}
