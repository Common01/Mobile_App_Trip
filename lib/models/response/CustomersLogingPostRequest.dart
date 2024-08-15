// To parse this JSON data, do
//
//     final customersLogingPostRequest = customersLogingPostRequestFromJson(jsonString);

import 'dart:convert';

CustomersLogingPostRequest customersLogingPostRequestFromJson(String str) =>
    CustomersLogingPostRequest.fromJson(json.decode(str));

String customersLogingPostRequestToJson(CustomersLogingPostRequest data) =>
    json.encode(data.toJson());

class CustomersLogingPostRequest {
  String phone;
  String password;

  CustomersLogingPostRequest({
    required this.phone,
    required this.password,
  });

  factory CustomersLogingPostRequest.fromJson(Map<String, dynamic> json) =>
      CustomersLogingPostRequest(
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
      };
}
