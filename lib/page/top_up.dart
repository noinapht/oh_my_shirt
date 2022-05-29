import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oh_my_shirt/component/snack_bar.dart';
import 'package:oh_my_shirt/data/app_theme.dart';
import 'package:oh_my_shirt/provider/userinfo_pvd.dart';
import 'package:provider/provider.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key key}) : super(key: key);

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  int money;
  List<int> moneyList = [50, 100, 200, 300];

  generateTags(List<int> input) {
    return input.map((x) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            money = x;
            setState(() {});
          },
          child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        money == x ? AppTheme.brandPrimary : AppTheme.uiGray_1,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: money == x
                      ? AppTheme.brandPrimary.withOpacity(0.3)
                      : Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                  child: Text(
                "฿" + x.toString(),
                style: TextStyle(color: Colors.black),
              ))),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.backTxtAppbar(context),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top Up",
              style: AppTheme.title,
            ),
            SizedBox(
              height: 10,
            ),
            Text("เติมเหรียญสำหรับใช้บริการซักภายในแอป",
                style: AppTheme.subGtxt),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(16),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.3,
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/washing.jpg")),
                  color: AppTheme.brandPrimary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppTheme.shadowCard,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/money.png",
                            fit: BoxFit.cover,
                            width: 50,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("OH COIN",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              SizedBox(
                                height: 5,
                              ),
                              Text(context
                                      .watch<UserInfoPvd>()
                                      .userOms
                                      ?.displayName ??
                                  ""),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "฿${context.watch<UserInfoPvd>().userOms?.coin ?? 0}",
                        style: AppTheme.title,
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("เลือกจำนวนเงินที่ต้องการเติม",
                  style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                ...generateTags(moneyList),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    if (money != null) {
                      log("message");
                      context.read<UserInfoPvd>().topUp(money);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        WSnackbar.snackBar(
                          marginSnack:
                              EdgeInsets.only(bottom: 16, left: 16, right: 16),
                          text: "กรุณาเลือกจำนวนเงิน",
                          onClick: () {},
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: money == null ? AppTheme.uiGray_1 : null,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      )),
                  child: Text("เติมเงิน",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }
}
