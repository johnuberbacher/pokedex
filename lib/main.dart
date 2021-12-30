import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Pokedex/routes/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // Android System bar
    statusBarBrightness: Brightness.light, // iOS System Bar
    systemNavigationBarDividerColor:
        Colors.black.withOpacity(0.075), // Android Navigation Bar Divider
    systemNavigationBarColor: Colors.white, // Android Navigation Bar
    systemNavigationBarIconBrightness: Brightness.dark, // Android Navigation Bar Icons
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
            // side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.black,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          unselectedLabelColor: Colors.grey,
        ),
        primarySwatch: Colors.red,
        accentColor: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}
