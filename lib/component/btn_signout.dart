import 'package:flutter/material.dart';
import 'package:oh_my_shirt/component/wc_showdialog.dart';
import 'package:oh_my_shirt/service/authentication.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({Key key}) : super(key: key);

  @override
  State<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.redAccent,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: () async {
        return WshowDialog.showMyDialog(
            context: context,
            title: "ออกจากระบบ",
            body: "คุณแน่ใจว่าคุณต้องการออกจากระบบ",
            actionLeft: 'ออกจากระบบ',
            actionRight: 'ยกเลิก',
            confirm: () async {
              await Authentication.signOut(context: context);
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
