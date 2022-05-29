import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:oh_my_shirt/component/circle_network_img.dart';
import 'package:oh_my_shirt/component/wc_showdialog.dart';
import 'package:oh_my_shirt/data/app_theme.dart';
import 'package:provider/provider.dart';

import '../provider/userinfo_pvd.dart';

class Washing extends StatefulWidget {
  final DocumentSnapshot model;
  final DateTime startTime;
  const Washing({Key key, this.model, this.startTime}) : super(key: key);
  @override
  State<Washing> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Washing> {
  DocumentSnapshot machine;
  int count = 0;
  DateTime startTime;
  bool sendMsg = false;
  bool end = false;
  String startFormat = "";
  String endFormat = "";

  @override
  void initState() {
    machine = widget.model;
    startTime = widget.startTime ?? DateTime.parse(machine["startTime"]);
    startFormat = DateFormat('dd/mm/yyyy kk:mm').format(startTime);
    endFormat = DateFormat('dd/mm/yyyy kk:mm')
        .format(startTime.add(Duration(minutes: machine["time_min"])));
    int diffSec;
    if (startTime
        .add(Duration(minutes: machine["time_min"]))
        .isBefore(DateTime.now())) {
      diffSec = null;
      end = true;
      log("end");
    } else {
      Duration diff = DateTime.now().difference(startTime);
      diffSec = (diff.inMinutes % 60) * 60 + (diff.inSeconds % 60);
      count = (machine["time_min"] * 60) - diffSec;
    }
    setState(() {});
    super.initState();
  }

  Widget timeCount() {
    return TweenAnimationBuilder<Duration>(
        duration: Duration(seconds: count),
        tween: Tween(begin: Duration(seconds: count), end: Duration.zero),
        onEnd: () {
          print('Timer ended');
          end = true;
          setState(() {});
        },
        builder: (BuildContext context, Duration value, Widget child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;
          if (minutes == 1 && seconds == 0) {
            if (!sendMsg) {
              context.read<UserInfoPvd>().sendMsg("Washer ${machine["id"]}");
              sendMsg = true;
              log("pewww");
            }
          }
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text('$minutes:$seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 18)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.backTxtAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Oh My Shirt",
                      style: AppTheme.title,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "model: " + machine["model"],
                      style: TextStyle(color: AppTheme.uiLabelSecondary),
                    ),
                  ],
                ),
                PopupMenuButton(
                  child: CircleNetworkImg(
                    networkImage:
                        context.watch<UserInfoPvd>().userOms?.photoURL,
                    radius: 24,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  onSelected: (value) {
                    if (value == 1) {
                      return WshowDialog.showMyDialog(
                          context: context,
                          title: "หยุดการทำงาน",
                          body: "คุณแน่ใจว่าคุณต้องหยุดการทำงานของเครื่องทันที",
                          actionLeft: 'หยุด',
                          actionRight: 'ยกเลิก',
                          confirm: () {
                            context
                                .read<UserInfoPvd>()
                                .machineSuccess(machine["id"]);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        "ยกเลิกการทำงาน",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.uiGray_3.withOpacity(0.8),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              // color: Colors.red,
                              height: 200,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Lottie.asset(
                                      'assets/lotties/washing.json',
                                    ),
                                  ),
                                  if (end)
                                    Align(
                                      alignment: Alignment.center,
                                      child: Lottie.asset(
                                        'assets/lotties/success.json',
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Text("data")
                            Text("start time: $startFormat"),
                            Text("end time: $endFormat"),
                            Text(
                                " ฿${machine["cost"]} / ${machine["time_min"]} min.  "),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: timeCount(),
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 3,
                              )
                            ],
                          ))
                    ],
                  )),
            ),

            Container(
              width: double.infinity,
              height: 50,
              child: end
                  ? ElevatedButton(
                      onPressed: () {
                        context
                            .read<UserInfoPvd>()
                            .machineSuccess(machine["id"]);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      )),
                      child: Text("นำผ้าออก",
                          style: TextStyle(fontWeight: FontWeight.bold)))
                  : ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "นำผ้าออก",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: AppTheme.uiGray_2,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                      )),
            )
          ],
        ),
      ),
    );
  }
}
