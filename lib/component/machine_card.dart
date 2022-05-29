import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oh_my_shirt/component/snack_bar.dart';
import 'package:oh_my_shirt/component/wc_showdialog.dart';
import 'package:oh_my_shirt/data/app_theme.dart';
import 'package:oh_my_shirt/page/washing.dart';
import 'package:oh_my_shirt/provider/userinfo_pvd.dart';
import 'package:provider/provider.dart';

class MachineCard extends StatefulWidget {
  final DocumentSnapshot machine;
  const MachineCard({Key key, this.machine}) : super(key: key);

  @override
  State<MachineCard> createState() => _MachineCardState();
}

class _MachineCardState extends State<MachineCard> {
  Map<String, Color> colorStatus = {
    "available": Colors.green,
    "using": Colors.redAccent
  };
  void alert(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      WSnackbar.snackBar(
        marginSnack: EdgeInsets.only(bottom: 16, left: 16, right: 16),
        text: txt,
        onClick: () {},
      ),
    );
  }

  Widget errorCase() {
    return Icon(Icons.image, color: AppTheme.uiGray_3);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.machine["status"] == "available") {
          WshowDialog.showMyDialog(
              context: context,
              title: "ชำระด้วย OhMyShirt credith?",
              body: "ระบบจะตัดเงินจากเครดิตของคุณ ",
              actionLeft: 'ยืนยัน',
              confirm: () {
                Navigator.pop(context);
                context
                    .read<UserInfoPvd>()
                    .payCredit(widget.machine["cost"])
                    .then((value) async {
                  if (value == null) {
                    alert("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง");
                  } else if (value) {
                    context
                        .read<UserInfoPvd>()
                        .startMachine(widget.machine["id"])
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => Washing(
                                startTime: value,
                                model: widget.machine,
                              )),
                        ),
                      );
                    });
                  } else {
                    alert("เงินไม่พอจ้า เติมเงินก่อนนะ");
                  }
                });
              });
        } else {
          if (widget.machine["lastUser"] ==
              context.read<UserInfoPvd>().userOms.uid) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => Washing(
                      model: widget.machine,
                    )),
              ),
            );
          } else {
            alert("Washer" +
                widget.machine["id"] +
                " กำลังถูกใช้งานจากผู้ใช้อื่น");
          }
        }
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: widget.machine["lastUser"] ==
                    context.read<UserInfoPvd>().userOms.uid
                ? Border.all(
                    color: AppTheme.brandPrimary.withOpacity(0.5),
                    width: 4,
                  )
                : Border.all(
                    color: AppTheme.uiGray_4,
                    width: 0.5,
                  ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppTheme.shadowCard,
            color: Colors.white,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12),
                  width: 50,
                  child: CachedNetworkImage(
                      imageUrl: widget.machine["img"],
                      placeholder: (context, url) => Stack(
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.brandPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      imageBuilder: (context, image) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: image, fit: BoxFit.cover)),
                          ),
                      errorWidget: (context, url, error) => errorCase()),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Washer" + widget.machine["id"],
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(widget.machine["model"], style: AppTheme.subGtxt),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                colorStatus[widget.machine["status"]],
                            radius: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              widget.machine["status"],
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: widget.machine["status"] != "available"
                              ? Border.all(
                                  color: AppTheme.uiGray_1,
                                  width: 0.5,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          color: widget.machine["status"] != "available"
                              ? Colors.white
                              : AppTheme.uiGray_3,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text("฿" + widget.machine["cost"].toString(), style: TextStyle(color: Colors.black),)),
                    Text(
                      widget.machine["time_min"].toString() + " min.",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
