import 'package:flutter/material.dart';
import 'Map/map.dart';
import 'Materials/colors.dart';
import 'Materials/BusCard.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYNGABUS',
      home: Scaffold(
        backgroundColor: black,
        body: Stack(
          children:<Widget> [
            Map(),
            BusCard(),
          ]
        ),
      ),
    );
  }
}