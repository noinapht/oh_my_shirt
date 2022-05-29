import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oh_my_shirt/component/btn.dart';
import 'package:oh_my_shirt/component/btn_signout.dart';
import 'package:oh_my_shirt/component/carosel.dart';
import 'package:oh_my_shirt/component/circle_network_img.dart';
import 'package:oh_my_shirt/component/machine_card.dart';
import 'package:oh_my_shirt/component/wc_showdialog.dart';
import 'package:oh_my_shirt/data/app_theme.dart';
import 'package:oh_my_shirt/provider/userinfo_pvd.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic ss = 0;
  dynamic machines;

  Widget mycoin() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/topup');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.uiGray_3,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppTheme.shadowCard,
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
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
                    Text(
                      "OH COIN",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      context.watch<UserInfoPvd>().userOms?.displayName ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "฿${context.watch<UserInfoPvd>().userOms?.coin ?? 0}",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(top: 16, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Oh My Shirt",
            style: AppTheme.title,
          ),
          PopupMenuButton(
            child: CircleNetworkImg(
              networkImage: context.watch<UserInfoPvd>().userOms?.photoURL,
              radius: 24,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            onSelected: (value) {
              if (value == 2) {
                return WshowDialog.showMyDialog(
                    context: context,
                    title: "ออกจากระบบ",
                    body: "คุณแน่ใจว่าคุณต้องการออกจากระบบ? ",
                    actionLeft: 'ออกจากระบบ',
                    actionRight: 'ยกเลิก',
                    confirm: () {
                      Navigator.pop(context);
                    });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: AppComponent().themeModeBtn,
              ),
              PopupMenuItem(value: 2, child: SignOutButton()),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 5),
                    //   child: Text("บริการซักล้างทุกระดับประทับใจ",
                    //       style: AppTheme.subGtxt),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AdvApp(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    mycoin(),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        // crossAxisAlignment:CrossAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose a Mashine",
                            style: TextStyle(fontSize: 24),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("บริการซักล้างทุกระดับประทับใจ",
                                style: AppTheme.subGtxt),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('machines')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("no");
                                } else {
                                  machines = snapshot.data.docs;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: machines.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot bb = machines[index];
                                        return MachineCard(machine: bb);
                                      },
                                    ),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
