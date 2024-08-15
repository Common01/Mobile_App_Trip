import 'dart:developer';

import 'package:flutter_application_1/models/request/CustomersCreatePostRequest.dart';
import 'package:flutter_application_1/models/response/CustomersCreatePostRepones.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
// import 'dart:convert';
import 'package:flutter_application_1/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
bool b = true;

class _RegisterPageState extends State<RegisterPage> {
  @override
  var nameusr = TextEditingController();
  var phoneusr = TextEditingController();
  var emailusr = TextEditingController();
  var passwordusr = TextEditingController();
  var confirmusr = TextEditingController();
  String url = "";
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ชื่อ-นาสกุล',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextField(
                        controller: nameusr,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))))
                  ]),
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
                      controller: phoneusr,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'อีเมล์',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextField(
                      controller: emailusr,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))))
                ],
              ),
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
                      
                      controller: passwordusr,
                      obscureText: b,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: () {setState(() {
                            b =! b ;
                          });}, icon: Icon( b ? Icons.visibility_off : Icons.visibility,),),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ยืนยันรหัสผ่าน',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextField(
                      controller: confirmusr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))))
                ],
              ),
            ),
            Column(
              children: [
                FilledButton(
                    onPressed: () {
                      newuser();
                    },
                    child: const Text('สมัครสมาชิก'))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text('ลงทะเบียนใหม่',
                          style: TextStyle(color: Colors.black))),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: const Text('เข้าสู่ระบบ'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void newuser() async {
    if (passwordusr.text == confirmusr.text &&
        passwordusr.text.isNotEmpty &&
        confirmusr.text.isNotEmpty &&
        nameusr.text.isNotEmpty &&
        phoneusr.text.isNotEmpty &&
        emailusr.text.isNotEmpty) {
      var datacreate = CustomersCreatePostRequest(
          fullname: nameusr.text,
          phone: phoneusr.text,
          email: emailusr.text,
          password: passwordusr.text,
          image:
              "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png");

      try {
        var check = await http.get(Uri.parse('$url/customers'));
        var databaseusr = customersCreatePostReponesFromJson(check.body);
        bool x = true;
        for (var a in databaseusr) {
          if (a.email == emailusr.text ||
              a.phone == passwordusr.text ||
              a.fullname == nameusr.text) {
            x = false;
            break;
          }
        }
        if (x) {
          var value = await http.post(Uri.parse('$url/customers'),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: customersCreatePostRequestToJson(datacreate));
          log(value.body);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
        } else {
          log('have user ');
        }
      } catch (err) {
        log(err.toString());
      }
    }
  }
}
