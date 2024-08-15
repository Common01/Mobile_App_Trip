import 'dart:developer';
import 'package:flutter_application_1/models/response/TripbyIDGetRepones.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';


class TripPage extends StatefulWidget {
  int idx = 0;

  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = "";
  late TripbyIdGetRepones data;
  late Future<void> loadData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData = loadDataAsync();

    // ไปดู attribute ที่ class แม่
    log(widget.idx.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายละเอียดทริป")),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w800),
                        data.name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data.country),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(data.coverimage),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ราคา ${data.price} บาท'),
                          Text('โซน${data.destinationZone}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data.detail),
                    ),
                    Center(
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text("จองเลย"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx.toString()}'));
    data = tripbyIdGetReponesFromJson(res.body);
  }
}
