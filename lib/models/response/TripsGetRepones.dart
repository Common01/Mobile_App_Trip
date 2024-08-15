// To parse this JSON data, do
//
//     final tripsGetRepones = tripsGetReponesFromJson(jsonString);

import 'dart:convert';

List<TripsGetRepones> tripsGetReponesFromJson(String str) =>
    List<TripsGetRepones>.from(
        json.decode(str).map((x) => TripsGetRepones.fromJson(x)));

String tripsGetReponesToJson(List<TripsGetRepones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsGetRepones {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripsGetRepones({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripsGetRepones.fromJson(Map<String, dynamic> json) =>
      TripsGetRepones(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
      };
}
