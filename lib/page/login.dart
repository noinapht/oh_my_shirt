import 'package:flutter/material.dart';
import 'package:oh_my_shirt/component/btn_signIn.dart';
import 'package:oh_my_shirt/data/app_theme.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.7),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: AppTheme.uiGray_4.withOpacity(0.5),
              image: DecorationImage(
                  opacity: 0.3,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/washing.jpg"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 64),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Image.asset("assets/images/gogo.jpg"),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  width: double.infinity,
                  height: 60,
                  child: GoogleSignInButton()),
              Text(
                "Wash - Dry - Iron @Oh My Shirt",
                style: TextStyle(color: Colors.black54, fontSize: 16,),textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
