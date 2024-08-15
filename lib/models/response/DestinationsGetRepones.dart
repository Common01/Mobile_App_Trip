// To parse this JSON data, do
//
//     final destinationsGetRepones = destinationsGetReponesFromJson(jsonString);

import 'dart:convert';

List<DestinationsGetRepones> destinationsGetReponesFromJson(String str) =>
    List<DestinationsGetRepones>.from(
        json.decode(str).map((x) => DestinationsGetRepones.fromJson(x)));

String destinationsGetReponesToJson(List<DestinationsGetRepones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DestinationsGetRepones {
  int idx;
  String zone;

  DestinationsGetRepones({
    required this.idx,
    required this.zone,
  });

  factory DestinationsGetRepones.fromJson(Map<String, dynamic> json) =>
      DestinationsGetRepones(
        idx: json["idx"],
        zone: json["zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "zone": zone,
      };
}
