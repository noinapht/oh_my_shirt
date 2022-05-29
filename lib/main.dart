import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oh_my_shirt/data/app_theme.dart';
import 'package:oh_my_shirt/page/home.dart';
import 'package:oh_my_shirt/page/login.dart';
import 'package:oh_my_shirt/page/splash.dart';
import 'package:oh_my_shirt/page/top_up.dart';
import 'package:oh_my_shirt/provider/userinfo_pvd.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final themeMode = ValueNotifier(1);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserInfoPvd())
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: AppTheme.brandPrimary,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: AppTheme.brandPrimary),
                  backwardsCompatibility: false,
                  titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  elevation: 0),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.values.toList()[value as int],
            initialRoute: '/',
            routes: {
              '/': (ctx) => SplashScreen(),
              '/login': (ctx) => LogIn(),
              '/home': (ctx) => Home(),
              '/topup': (ctx) => TopUp(),
            },
          ),
        );
      },
      valueListenable: themeMode,
    );
  }
}
