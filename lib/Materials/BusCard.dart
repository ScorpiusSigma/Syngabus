import 'package:flutter/material.dart';
import 'package:syngabus/API/API/LTA_API/Bus_Stop.dart';
import 'package:syngabus/Materials/colors.dart';
import 'package:syngabus/API/API/LTA_API/Bus_Timing.dart';

class BusCard extends StatefulWidget{
  @override
  BusCardState createState()=>BusCardState();
}

class BusCardState extends State<BusCard>{
  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        color: black,
        margin: EdgeInsets.all(10),
        child: Container(
          height:280,
          width:double.infinity,
          padding: EdgeInsets.only(bottom: 15),
          child: Stack(children: <Widget>[
            BusStopInfo(),
            _tabBarView(),
          ],)
        ),
        )
      );
  }


  _tabBarView(){
    return Container(
      decoration: BoxDecoration( color: black, borderRadius: BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: DefaultTabController(
          length: 5,
          child:
          TabBar(
            labelPadding: EdgeInsets.only(bottom: 5, top: 5),
            indicatorColor: turqouise,
            unselectedLabelColor: arsenic,
            labelColor: turqouise,
            tabs:[
              Icon(Icons.near_me),
              Icon(Icons.favorite_border),
              Icon(Icons.alarm),
              Icon(Icons.search),
              Icon(Icons.train)
            ]
          )
        )
    );
  }
}