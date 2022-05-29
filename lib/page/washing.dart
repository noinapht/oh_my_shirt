import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:oh_my_shirt/component/btn.dart';
import 'package:oh_my_shirt/component/snack_bar.dart';
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
                  style: TextStyle(color: Colors.black, fontSize: 18)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.backTxtAppbar(context),
      body: Container(
        child: Padding(
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
                              Container(
                                margin: EdgeInsets.only(top: 24),
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
                              Text("start time: $startFormat"),
                              Text("end time: $endFormat"),
                              Text(
                                  " ฿${machine["cost"]} / ${machine["time_min"]} min.  "),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  timeCount(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          return WshowDialog.showMyDialog(
                                              context: context,
                                              title: "หยุดการทำงาน",
                                              body:
                                                  "คุณแน่ใจว่าคุณต้องหยุดการทำงานของเครื่องทันที",
                                              actionLeft: 'หยุด',
                                              actionRight: 'ยกเลิก',
                                              confirm: () {
                                                context
                                                    .read<UserInfoPvd>()
                                                    .machineSuccess(
                                                        machine["id"]);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.stop_rounded,
                                              color: Colors.white,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      CircleAvatar(
                                          child: AppComponent.themeModeBtn),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 3,
                            )
                          ],
                        )
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

                          ScaffoldMessenger.of(context).showSnackBar(
                            WSnackbar.snackBar(
                              marginSnack: EdgeInsets.only(
                                  bottom: 16, left: 16, right: 16),
                              text: "ขอบคุณที่ใช้บริการ",
                              onClick: () {},
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
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
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
