import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oh_my_shirt/model.dart/userInfo.dart';

class UserInfoPvd extends ChangeNotifier {
  OmsUser userOms;

  Future getUserInfo(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      Map<String, dynamic> data = {};
      for (var element in value.data().entries) {
        if (!(element.value is Timestamp)) {
          data[element.key] = element.value;
        }
      }
      userOms = omsUserFromJson(jsonEncode(data));
      notifyListeners();
    });
  }

  Future<DateTime> startMachine(String id) async {
    DateTime startTime = DateTime.now();
    await FirebaseFirestore.instance.collection("machines").doc(id).update({
      "status": "using",
      "startTime": startTime.toString(),
      "lastUser": userOms.uid
    }).then((value) async {
      print("DocumentSnapshot successfully updated!");
    }, onError: (e) {
      print("Error updating document $e");
    });
    return startTime;
  }

  Future<void> topUp(int money) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userOms.uid)
        .update({"coin": userOms.coin + money}).then((value) async {
      print("DocumentSnapshot successfully updated!");

      getUserInfo(userOms.uid);
    }, onError: (e) {
      print("Error updating document $e");
    });
  }

  Future machineSuccess(String id) async {
    await FirebaseFirestore.instance
        .collection("machines")
        .doc(id)
        .update({"status": "available", "lastUser": null}).then((value) async {
      print("DocumentSnapshot successfully updated!");
    }, onError: (e) {
      print("Error updating document $e");
    });
  }

  Future<void> sendMsg(String washer) async {
    String url = 'https://api.line.me/v2/bot/message/push';
    print(url);
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer KCJFn1olnH2t5ogrrQWVwdJt5umKF7vSqJxwjENcBnSWvuEbw5x3uhQ3t9Mie+gUZBKKVnt3oP5D8g3nicde6h5ycHNv/pzcEi2kLpvlnZGrONBm7/ZTBXFYbqi21GzlSIA6Iem35HN63O5pQE7L2wdB04t89/1O/w1cDnyilFU='
      },
      body: jsonEncode(<String, dynamic>{
        "to": "Ca981a22765880479f59a97be55818a17",
        "messages": [
          {
            "type": "text",
            "text": "$washer ใกล้เสร็จแล้วนะ เตรียมผ้ามาซักกันต่อได้เลยยย"
          }
        ]
      }),
    );

    int status = response.statusCode;
    if (status == 200) {}
  }

  Future<bool> payCredit(int cost) async {
    bool pass;
    if (userOms.coin >= cost) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userOms.uid)
          .update({"coin": userOms.coin - cost}).then((value) async {
        print("DocumentSnapshot successfully updated!");
        getUserInfo(userOms.uid);
        pass = true;
      }, onError: (e) {
        print("Error updating document $e");
      });
    } else {
      pass = false;
    }

    return pass;
  }
}
