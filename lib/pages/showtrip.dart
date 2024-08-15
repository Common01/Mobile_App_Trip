import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/models/response/DestinationsGetRepones.dart';
import 'package:flutter_application_1/models/response/TripsGetRepones.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/trip.dart';

class ShowtripPage extends StatefulWidget {
  int idx = 0;

  ShowtripPage({super.key, required this.idx});

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  late List<TripsGetRepones> tripgetrepones;
  late Future<void> loadData;
  String url = "";
  List<DestinationsGetRepones> zone = [];

  @override
  void initState() {
    super.initState();

    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx),
                    ));
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  children: [Text('ปลายทาง')],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FutureBuilder(
                      future: loadbarDataAsync(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton(
                              onPressed: () {
                                loadDataAsync();
                              },
                              child: Text("ทั้งหมด"),
                            ),
                            ...zone
                                .map((trip) => FilledButton(
                                      onPressed: () {
                                        getTrips(trip.zone);
                                      },
                                      child: Text(trip.zone),
                                    ))
                                .toList(),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: tripgetrepones
                          .map((trip) => Card(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 150,
                                          child: Image.network(
                                            trip.coverimage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(trip.name,
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                                Text(
                                                    ('ระยะเวลา ${trip.duration} วัน'),
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                                Text('ราคา ${trip.price}',
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15),
                                                  child: SizedBox(
                                                    width: 150,
                                                    height: 30,
                                                    child: FilledButton(
                                                      onPressed: () {
                                                        gotoTripPage(trip.idx);
                                                      },
                                                      child: const Text(
                                                          'รายละเอียดเพิ่มเติม',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  getTrips(String? zone) async {
    try {
      log(zone!);
      var res = await http.get(Uri.parse('$url/trips'));
      tripgetrepones = tripsGetReponesFromJson(res.body);
      List<TripsGetRepones> filteredTrid = [];
      if (zone != null) {
        for (var a in tripgetrepones) {
          if (a.destinationZone == zone) {
            filteredTrid.add(a);
          }
        }
        setState(() {
          tripgetrepones = filteredTrid;
        });
      }
      log(tripgetrepones.length.toString());
    } catch (err) {
      log(err.toString());
    }
  }

  getDestinations() async {
    try {
      var res = await http.get(Uri.parse('$url/destinations'));
      setState(() {
        zone = destinationsGetReponesFromJson(res.body);
      });
    } catch (err) {
      log(err.toString());
    }
  }

  void seletctzone(int zone) {
    log(zone.toString());
  }

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips'));
    tripgetrepones = tripsGetReponesFromJson(res.body);
    setState(() {
      tripgetrepones = tripgetrepones;
    });
  }

  Future<void> loadbarDataAsync() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/destinations'));
    zone = destinationsGetReponesFromJson(res.body);
  }

  void gotoTripPage(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }
}
