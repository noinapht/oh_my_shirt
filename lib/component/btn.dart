import 'package:flutter/material.dart';
import 'package:oh_my_shirt/main.dart';

class AppComponent {
 static Widget themeModeBtn = GestureDetector(
    onTap: () {
      themeMode.value = themeMode.value == 1 ? 2 : 1;
    },
    child:  
         Container(
          //  width: double.infinity,
           color: Colors.transparent,
           child: Icon(Icons.wb_incandescent)),
  );

  static Widget largebtnNavigate(
      {BuildContext context,
      String pathImg,
      String txt,
      String pageRoute,
      Function func}) {
    return GestureDetector(
      onTap: () {
        if (pageRoute == null) {
          func();
        } else {
          try {
            Navigator.pushNamed(context, pageRoute);
          } catch (e) {
            print("patn error");
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 100,
                color: Colors.black.withOpacity(0.03),
                offset: Offset(0, 4),
              ),
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 30,
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
              ),
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 10,
                color: Colors.black.withOpacity(0.03),
                offset: Offset(0, 10),
              ),
            ]),
      // color: Colors.amber,
        child: Container(
          // color: a,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Image.asset(
                    pathImg,
                    fit: BoxFit.cover,
                    width: 50,
                  ),
                ),
                Text(
                  txt,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
