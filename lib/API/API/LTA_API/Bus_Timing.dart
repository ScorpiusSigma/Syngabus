import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syngabus/API/API/LTA_API/Bus_Stop.dart';
import 'package:syngabus/Materials/colors.dart';

var busesETA = new List();
class BusArrivalInfo extends StatefulWidget {


  @override
  BusArrivalInfoState createState() => new BusArrivalInfoState();
}


class BusArrivalInfoState extends State<BusArrivalInfo>{
  
  
  Future<String> getBusTiming() async {
      busesETA = new List();
      var busStopData;
      var data;
      var buses;
      var busStopDatas;
      String busNo;
      int nextBus;
      int nextBus2;
      int nextBus3;
      

      String busStopCode;
      String url;
      busStopCode = '64351';
      url="http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=";
      final link = url+busStopCode;

      final response = await http.get(link,
      headers:{
        "AccountKey":"tPJI06oTRRyxxogQWmhBCg== ",
        "accept":"application/json",
      } );

      data = json.decode(response.body);
     
      busStopDatas=data['Services'];

      nextBusInfo(String nextBusTime,var nextBusOptions){
        int arrival = DateTime.parse(busStopData[nextBusTime][nextBusOptions]).minute;
        int busETA= arrival-DateTime.now().minute;
        return busETA;
      }

      for (busStopData in busStopDatas){
        busNo = busStopData['ServiceNo'];
        nextBus = nextBusInfo('NextBus', 'EstimatedArrival');
        nextBus2 = nextBusInfo('NextBus2', 'EstimatedArrival');
        nextBus3 = nextBusInfo('NextBus3', 'EstimatedArrival');

        buses=[busNo.toString(),nextBus.toString(),nextBus2.toString(),nextBus3.toString()];
        busesETA.add(buses);
      }
      busesETA.sort();
      setState(() {
        busesETA = busesETA;
      });
      
      return "success";
  }

  @override
  void initState() {
    super.initState();
    this.getBusTiming();
  }

  cardInfo(String serviceNo,String nxtBus,String nxtBus2,String nxtBus3){
    return new Card(
      color: black,
      child:new Container(
        height: 50,
        padding: EdgeInsets.all(10),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          new Text(serviceNo, style: TextStyle(color: Colors.white),),
          Container(
            width: 100,
            child:new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              new Text(nxtBus,style: TextStyle(color:turqouise)),
              new Text(nxtBus2,style: TextStyle(color:turqouise)),
              new Text(nxtBus3,style: TextStyle(color:turqouise))
              ]),
          )
        ],)
      )
    );
  }



  @override
  Widget build(BuildContext context){
    return new Container(
      child: new ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
      itemCount:busesETA==null?0:busesETA.length,
      itemBuilder:(context,index){
        return cardInfo(busesETA[index][0],busesETA[index][1],busesETA[index][2],busesETA[index][3]);
      }
      )
    );
  }
}