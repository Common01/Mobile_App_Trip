import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/response/CustomerbyIDGetRepones.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  int idx = 0;

  ProfilePage({super.key, required this.idx});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = "";
  late Future<void> loadData;
  var fullnameCtl = TextEditingController();
  var phoneCtl = TextEditingController();
  var emailCtl = TextEditingController();
  var imageCtl = TextEditingController();
  late CustomerbyIdGetRepones data;
  @override
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ปิด')),
                          FilledButton(
                              onPressed: () {
                                delete();
                              },
                              child: const Text('ยืนยัน'))
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            fullnameCtl.text = data.fullname;
            phoneCtl.text = data.phone;
            emailCtl.text = data.email;
            imageCtl.text = data.image;
            return SingleChildScrollView(
                child: Column(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 150, // กำหนดความกว้างของภาพ
                          height: 150, // กำหนดความสูงของภาพ
                          child: Image.network(
                            data.image,
                            fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
                          ),
                        ),
                      ],
                    ),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("ชื่อ-นามสกุล"),
                            // ignore: prefer_const_constructors
                            TextField(
                                controller: fullnameCtl,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(width: 1))))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("หมายเลขโทรศัพท์"),
                            // ignore: prefer_const_constructors
                            TextField(
                                controller: phoneCtl,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(width: 1))))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Email"),
                            // ignore: prefer_const_constructors
                            TextField(
                                controller: emailCtl,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(width: 1))))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("รูปภาพ"),
                            // ignore: prefer_const_constructors
                            TextField(
                                controller: imageCtl,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(width: 1))))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            FilledButton(
                                onPressed: () {
                                  updatedata();
                                },
                                child: const Text('บันทึกข้อมูล'))
                          ],
                        ),
                      )
                    ])
                  ],
                ),
              ],
            ));
          }),
    );
  }

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    var res =
        await http.get(Uri.parse('$url/customers/${widget.idx.toString()}'));
    data = customerbyIdGetReponesFromJson(res.body);
  }

  void updatedata() async {
    var json = {
      "fullname": fullnameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text
    };
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    try {
      var res = await http.put(
          Uri.parse('$url/customers/${widget.idx.toString()}'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(json));
      log(res.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + err.toString()),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }

  void delete() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    try {
      var res = await http
          .delete(Uri.parse('$url/customers/${widget.idx.toString()}'));
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('สำเร็จ'),
                  content: Text('ลบข้อมูลสำเร็จ'),
                  actions: [
                    FilledButton(
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                        },
                        child: const Text('ปิด'))
                  ]));
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('ผิดพลาด'),
                  content: Text('ลบข้อมูลไม่สำเร็จ'),
                  actions: [
                    FilledButton(
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                        },
                        child: const Text('ปิด'))
                  ]));
    }
  }
}
