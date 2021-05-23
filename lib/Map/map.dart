import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const LatLng SINGAPORE=LatLng(1.290270, 103.851959);
LatLng currentPosition;
const double CAMERA_ZOOM=17.0;
Position currentLatLng;
double currentLat;
double currentLng;
String getAddress;
String currentAddress = "-";

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  //Map Style
  String mapStyle;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/mapnight.txt').then((string) {
      mapStyle = string;
    });

    Geolocator().getCurrentPosition().then((Position position){
      setState(() {
        currentLatLng = position;
        currentLat = position.latitude!=null?position.latitude:'-';
        currentLng = position.latitude!=null?position.longitude:'-';
      });
    });   

    _getAddress().then((val) => setState((){
      currentAddress = val;
    }) );
  }

  Future<String> _getAddress() async{
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(currentLat, currentLng);

      if(placemarks != null && placemarks.isNotEmpty){
        final Placemark position = placemarks[0];
        getAddress = position.country;
        return getAddress;
      }
      else{
        return '-';
      }
  }

  GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
      mapController.setMapStyle(mapStyle);
  }

  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLat + 0.25, currentLng)==null?SINGAPORE:LatLng(currentLat, currentLng),
            zoom: CAMERA_ZOOM,
          ),
          compassEnabled: true,
        ),
      )
    );
  }
}

