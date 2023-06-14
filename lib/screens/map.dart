import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMap extends StatefulWidget {
  final data;
  const ViewMap({super.key, this.data});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  late LatLng location;
  @override

  void initState() {
    List<String> latLngValues = widget.data['mapLocation'].split(',');
    double latitude = double.tryParse(latLngValues[0].trim()) ?? 0.0;
    double longitude = double.tryParse(latLngValues[1].trim()) ?? 0.0;
    location = LatLng(latitude, longitude);
    print('location is $location');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['category']),
      ),
      body: GoogleMap(
        markers: markers,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 10,
        ),
      ),
    );
  }
}
