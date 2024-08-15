// To parse this JSON data, do
//
//     final customersCreatePostRequest = customersCreatePostRequestFromJson(jsonString);

import 'dart:convert';

CustomersCreatePostRequest customersCreatePostRequestFromJson(String str) =>
    CustomersCreatePostRequest.fromJson(json.decode(str));

String customersCreatePostRequestToJson(CustomersCreatePostRequest data) =>
    json.encode(data.toJson());

class CustomersCreatePostRequest {
  String fullname;
  String phone;
  String email;
  String image;
  String password;

  CustomersCreatePostRequest({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.password,
  });

  factory CustomersCreatePostRequest.fromJson(Map<String, dynamic> json) =>
      CustomersCreatePostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
      };
}
