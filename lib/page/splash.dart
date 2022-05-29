import 'package:flutter/material.dart';
import 'package:oh_my_shirt/service/authentication.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  Future autoLogin() async {
    await Future.delayed(Duration(seconds: 3));
    await Authentication.initializeFirebase(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          
           decoration: BoxDecoration(
            //  color:Colors.amber,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/bg.png"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Image.asset("assets/images/gogo.jpg"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "Wash - Dry - Iron",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
