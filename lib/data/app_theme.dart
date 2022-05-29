import 'package:flutter/material.dart';

class AppTheme {
  static const Color brandPrimary = Color(0xFF529ffb);
  static const Color brandSecondary = Color(0xFFffc000);
  static const uiLabelSecondary = Color(0xFF808080);
  static const uiLabelDisable = Color(0xFFA3A3A3);
  static const uiGray_1 = Color(0xFFCAC5C4);
  static const uiGray_2 = Color(0xFFDCD8D6);
  static const uiGray_3 = Color(0xFFEEE9E8);
  static const uiGray_4 = Color(0xFFF9F6F5);

  static TextStyle title = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static TextStyle subGtxt =
      TextStyle(fontSize: 12, color: AppTheme.uiLabelSecondary);

  static List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      spreadRadius: 0,
      blurRadius: 10,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      spreadRadius: 0,
      blurRadius: 30,
      offset: Offset(0, 5),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      spreadRadius: 0,
      blurRadius: 100,
      offset: Offset(0, 4),
    ),
  ];

  static AppBar backTxtAppbar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: uiLabelSecondary,
      ),
      leadingWidth: double.infinity,
      leading: Container(
        padding: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios_outlined,
                ),
                Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 18,
                    color: uiLabelSecondary,
                  ),
                  textAlign: TextAlign.end,
                  // style: GoogleFonts.poppins(
                  //     color: Colors.grey[600], fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
