
import 'package:flutter/material.dart';
import 'package:oh_my_shirt/page/login.dart';
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
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () async {
       
        await Authentication.signOut(context: context);
       
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LogIn()), (route) => false);
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
