import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syngabus/API/API/LTA_API/Bus_Timing.dart';
import 'package:syngabus/Map/map.dart';
import 'package:syngabus/Materials/colors.dart';

var busStops= new List();

class BusStopInfo extends StatefulWidget{
    @override
    BusStopInfoState createState() => BusStopInfoState();
}

class BusStopInfoState extends State<BusStopInfo>{
  
  bool boolBusStopExpandTile = false;
  
  var data;
  var busStopDatas;
  var busStopInfo;

  Future<String> getBusStop() async{
    int skipNo;
    busStops = new List();
    for(skipNo = 0; skipNo <= 6000; skipNo += 500){
      String link = r"http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=" + skipNo.toString();

      final response = await http.get(link,
      headers:{
        "AccountKey":"tPJI06oTRRyxxogQWmhBCg==",
        "accept":"application/json",
      });
      data = json.decode(response.body);
      busStopDatas = data['value'];
      
      for(var busStopData in busStopDatas){
        String busStopCode = busStopData['BusStopCode'];
        String roadName = busStopData['RoadName'];
        String description = busStopData['Description'];
        double lat = busStopData['Latitude'];
        double lng = busStopData['Longitude'];
        
        double totalDistance= calculateDistance(currentLat, currentLng, lat, lng).abs();

        if(totalDistance <= 0.5 && totalDistance >= 0){
          busStopInfo=[busStopCode,roadName,description,totalDistance];
          busStops.add(busStopInfo);
        }
      }
    }
    busStops.sort((a,b) => a[3].compareTo(b[3]));
    setState(() {
      busStops = busStops;
    });
    
    return 'Success';
  }
  void initState() {
    super.initState();
    this.getBusStop();
  }

  double calculateDistance(lat1,lng1,lat2,lng2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    double distance = 12742 * asin(sqrt(a));
    return distance;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top: 10),
      margin:EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
      itemCount:busStops.length==null?0:busStops.length,
      itemBuilder:(context,index){
        return cardInfo(busStops[index][2],busStops[index][0],busStops[index][1]);
      }
      )
    );
  }

  Widget cardInfo(String description,String busStopCode,String roadName){
    return Card(
      color: arsenic,
      child: Column(children: <Widget>[
        Container(
          height: 60,
          padding: EdgeInsets.all(5),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child:Row(children: <Widget>[
                  busStopIcon(description),
                  busStopInfoBox(description, busStopCode, roadName),
                ],)
              ),
              IconButton(
                disabledColor: turqouise,
                color: turqouise,
                icon: Icon( 
                  boolBusStopExpandTile == false ? Icons.keyboard_arrow_down:Icons.keyboard_arrow_up
                ),
                onPressed: () {
                  setState(() {
                  boolBusStopExpandTile =!boolBusStopExpandTile;
                  });
                }
              )
            ],)
        ),
        ExpandedTileBusTiming(
          expanded: boolBusStopExpandTile,
          child: BusArrivalInfo(),
        )
      ],)
      );
  }

  busStopIcon(String description){
    return CircleAvatar(
      backgroundColor: turqouise26,
      maxRadius: 30,
      child: Text(desInitials(description), style: TextStyle( color: turqouise),),
    );
  }

  desInitials(String description){
    return description.substring(0,1).toUpperCase() + description.split(' ')[1].substring(0,1).toUpperCase();
  }

  busStopInfoBox(String description,String busStopCode,String roadName){
    return Container(
      width: 220,
      padding:EdgeInsets.all(5),
      child: Center(
        child:Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child:Text(description,style: TextStyle(color: turqouise, fontSize: 18),)
            ),
            busStopSubtitle(busStopCode, roadName)
          ],
        )
      )
    );
  }

  busStopSubtitle(String busStopCode,String roadName){
    return Row(
      children: <Widget>[
        Text(busStopCode,style: TextStyle(color:turqouise45, fontSize: 15)),
        Text('   ',style: TextStyle(color:turqouise45, fontSize: 12.5)),
        Text(roadName,style: TextStyle(color:turqouise45, fontSize: 12.5)),
      ]
    );
  }
}

class ExpandedTileBusTiming extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandedTileBusTiming({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 0),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
      ),
    );
  }
}