// To parse this JSON data, do
//
//     final tripbyIdGetRepones = tripbyIdGetReponesFromJson(jsonString);

import 'dart:convert';

TripbyIdGetRepones tripbyIdGetReponesFromJson(String str) =>
    TripbyIdGetRepones.fromJson(json.decode(str));

String tripbyIdGetReponesToJson(TripbyIdGetRepones data) =>
    json.encode(data.toJson());

class TripbyIdGetRepones {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripbyIdGetRepones({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripbyIdGetRepones.fromJson(Map<String, dynamic> json) =>
      TripbyIdGetRepones(
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
