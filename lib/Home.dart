import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_sorting_app/Destination.dart';
import 'package:location_sorting_app/Utils.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position _currentPosition;
  List<Destination> destinationlist = List<Destination>();

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location sorting from current location"),
      ),
      body: Container(
        child: destinationlist.length>0?
        ListView.builder(
            itemCount: destinationlist.length,
            itemBuilder: (context, index){
              return Card(
                margin: EdgeInsets.all(5),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    height: 40,
                    color:Colors.white,
                    child: Column(
                      children: [
                        Text("${destinationlist[index].name}"),
                        Text("${destinationlist[index].distance.toStringAsFixed(2)} km"),
                      ],
                    ),
                  ),
                ),
              );
            }
        ):
        Center(child: CircularProgressIndicator(),)
      )
    );
  }

  // get Current Location
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      distanceCalculation(position);
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  distanceCalculation(Position position) {
    for(var d in destinations){
      var km = getDistanceFromLatLonInKm(position.latitude,position.longitude, d.lat,d.lng);
      // var m = Geolocator.distanceBetween(position.latitude,position.longitude, d.lat,d.lng);
      // d.distance = m/1000;
      d.distance = km;
      destinationlist.add(d);
      // print(getDistanceFromLatLonInKm(position.latitude,position.longitude, d.lat,d.lng));
    }
    setState(() {
      destinationlist.sort((a, b) {
        return a.distance.compareTo(b.distance);
      });
    });
  }
}
