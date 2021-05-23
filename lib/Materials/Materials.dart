import 'package:flutter/material.dart';
import 'package:syngabus/Map/map.dart';
import 'package:syngabus/Materials/colors.dart';

class NavCard extends StatefulWidget{
  @override
  NavCardState createState()=>NavCardState();
}

class NavCardState extends State<NavCard>{
  @override

  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        color: arsenic,
        margin: EdgeInsets.all(10),
        child: Container(
          height:280,
          width:double.infinity,
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(currentLat.toString(),style: TextStyle(color:turqouise),),
              Text(currentAddress),
            ],
          ),
        ),
        )
      );
  }
}

class LocationPanel extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){
    return Container(

    );
  }
}