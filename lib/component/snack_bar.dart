import 'package:flutter/material.dart';
import 'package:oh_my_shirt/data/app_theme.dart';

class WSnackbar {
  static SnackBar snackBar(
      {String text,
      String actionLabel = "",
      Function onClick ,
      EdgeInsets marginSnack}) {
    return SnackBar(
      backgroundColor: AppTheme.uiLabelSecondary,
      margin: marginSnack,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Text(
        text,
        style: TextStyle(fontSize: 16, fontFamily: 'NotoSans'),
      ),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: actionLabel,
        textColor: Colors.white,
        onPressed: onClick,
      ),
    );
  }
}
