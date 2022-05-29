import 'package:flutter/material.dart';
import 'package:oh_my_shirt/data/app_theme.dart';

class WshowDialog {
  static Future<void> showMyDialog(
      {BuildContext context,
      String title,
      String body,
      String actionLeft,
      String actionRight = "ยกเลิก",
      Function confirm,
      Function cancel,
      Color actionLeftColor}) async {
    bool click = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              )),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  body,
                  style: TextStyle(color: AppTheme.uiLabelSecondary),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            actionLeft != null
                ? TextButton(
                    child: Text(
                      actionLeft,
                      style: TextStyle(
                          color: actionLeftColor ?? Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (!click) {
                        confirm();
                      }
                    },
                  )
                : Container(),
            TextButton(
              child: Text(
                actionRight,
                style: TextStyle(
                    color: AppTheme.uiLabelSecondary, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                if (cancel != null) {
                  cancel();
                } else {
                  cancel ?? Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}