// To parse this JSON data, do
//
//     final customersCreatePostRepones = customersCreatePostReponesFromJson(jsonString);

import 'dart:convert';

List<CustomersCreatePostRepones> customersCreatePostReponesFromJson(
        String str) =>
    List<CustomersCreatePostRepones>.from(
        json.decode(str).map((x) => CustomersCreatePostRepones.fromJson(x)));

String customersCreatePostReponesToJson(
        List<CustomersCreatePostRepones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomersCreatePostRepones {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CustomersCreatePostRepones({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CustomersCreatePostRepones.fromJson(Map<String, dynamic> json) =>
      CustomersCreatePostRepones(
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
