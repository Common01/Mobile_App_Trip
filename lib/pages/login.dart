import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/request/CustomersLogingPostRes.dart';
import 'package:flutter_application_1/models/response/CustomersLogingPostRequest.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = "";
  String url = "";
  String logintext = "";
  int i = 0;
  String phonenumber = '';
  //TextEditingController phoneCtl = TextEditingController();
  var phoneCtl = TextEditingController();
  var passwd = TextEditingController();
  // Initstate คือ Function ที่ทำงานเมื่อเปิดหน้านี้
  // 1. Initstate จะทำงาน "ครั้งเดียว" เมื่อเปิดหน้านี้
  // 2. มันไม่ทำงานเมื่อเรา setState
  // 3. มันไม่สามารถทำงาน ansync function ได้

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (value) {
        log(value['apiEndpoint']);
        url = value['apiEndpoint'];
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body:
            SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                      onDoubleTap: () {
                        log('Image Processing');
                      },
                      child: Image.asset('assets/images/logo.png')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'หมายเลขโทรศัพท์',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextField(
                          // onChanged: (value) {
                          //   log(value);
                          //   phonenumber = value;
                          // }
                          controller: phoneCtl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)))),
                    ]),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'รหัสผ่าน',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextField(
                          controller: passwd,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)))),
                    ]),
              ),
              // ignore: prefer_const_constructors
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          register();
                        },
                        child: const Text('ลงทะเบียนใหม่')),
                    FilledButton(
                        onPressed: () => loging(),
                        child: const Text('เข้าสู่ระบบ'))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text, style: const TextStyle(color: Colors.red)),
                ],
              )
            ],
          ),
        ));
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

  void loging() async {
    //call login api
    //create object (request model)
    var datalogin =
        CustomersLogingPostRequest(phone: phoneCtl.text, password: passwd.text);
    try {
      var value = await http.post(Uri.parse('$url/customers/login'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customersLogingPostRequestToJson(datalogin));

      CustomersLogingPostResponse customer =
          customersLogingPostResponseFromJson(value.body);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowtripPage(idx: customer.customer.idx),
          ));
    } catch (err) {
      setState(() {
        text = 'Error Username or password';
      });
    }

    // http
    //     .post(Uri.parse('http://192.168.73.82:3000/customers/login'),
    //         headers: {"Content-Type": "application/json; charset=utf-8"},
    //         body: customersLogingPostRequestToJson(datalogin))
    //     .then(
    //   (value) {
    //     //Convert Json String to Object
    //     CustomersLogingPostResponse customer =
    //         customersLogingPostResponseFromJson(value.body);
    //     log(customer.customer.email);
    //     //convert Json to Map<String, String>
    //     // var jsonRes = jsonDecode(value.body);
    //     // log(jsonRes['customer']['email']);
    //     // log(value.body);
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const ShowtripPage(),
    //         ));
    //   },
    // ).catchError((err) {
    //   setState(() {
    //     text = 'Error Username or password';
    //   });
    //   log(err.toString());
    // });
  }
}
