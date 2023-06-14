import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ruvu/auth/login.dart';
import 'package:ruvu/screens/admin/admin.dart';
import 'package:ruvu/screens/complaints_page.dart';
import 'package:ruvu/screens/profile.dart';
import 'package:ruvu/screens/report_page.dart';
import 'package:ruvu/screens/rulesPage.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _controller;
  final LatLng _initialLocation = const LatLng(-6.3833, 38.8667); // Ruvu coordinates
  late String? mapLocation = "-6.3833, 38.8667";

  Set<Marker> markers = {};

  String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  User? user = FirebaseAuth.instance.currentUser;

  

  @override
  Widget build(BuildContext context) {
    String? userId = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/Ruvu_River.jpg'),
                      fit: BoxFit.fitWidth)),
              child: Center(
                child: Text(
                  'Ruvu Tracking App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Report a problem'),
              onTap: () {
                // Navigate to the report screen
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ReportPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('My complaints'),
              onTap: () {
                // Navigate to the my Complaints screen
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ComplaintsPage(userId: getUserId())));
              },
            ),
            // const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.credit_card),
            //   title: const Text('Admin Panel'),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const Admin()));
            //   },
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My account'),
              onTap: () {
                // Navigate to profile screen
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: getUserId(), )));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.handyman),
              title: const Text('Rules'),
              onTap: () {
                // Navigate to rules screen
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => RulesPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () async {
                // Perform logout action
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            const Divider(),
          ],
        ),
      ),
      body: GoogleMap(
        markers: markers,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: () async{
      //     Position position = await _determineLocation();
      //     _controller.animateCamera(CameraUpdate.newCameraPosition(
      //         CameraPosition(
      //             target: LatLng(position.latitude, position.longitude),
      //             zoom: 14)));
      //     markers.add(Marker(markerId: const MarkerId('User Location'), position: LatLng(position.latitude, position.longitude)));

      //     setState(() {
      //       mapLocation = "${position.latitude},${position.longitude}";
      //       print('current location $mapLocation');
      //     });
      //   },
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButton: SizedBox(
      //   width: 200,
      //   child: Padding(
      //     padding: const EdgeInsets.all(0.0),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.circular(20.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const SizedBox(
      //             height: 600,
      //           ),
      //           ElevatedButton(
      //             onPressed: () async {
      //               Position position = await _determineLocation();
      //               _controller.animateCamera(CameraUpdate.newCameraPosition(
      //                   CameraPosition(
      //                       target: LatLng(position.latitude, position.longitude),
      //                       zoom: 14)));
      //               markers.add(Marker(markerId: const MarkerId('User Location'), position: LatLng(position.latitude, position.longitude)));
      //
      //               setState(() {
      //                 mapLocation = "${position.latitude},${position.longitude}";
      //                 print('current location $mapLocation');
      //               });
      //             },
      //             style: ElevatedButton.styleFrom(
      //                 padding:
      //                 const EdgeInsets.symmetric(horizontal: 5, vertical: 15)),
      //             child: const Text('View location'),
      //           ),
      //           const SizedBox(height: 10,),
      //           ElevatedButton(
      //             onPressed: () {
      //               Navigator.of(context).push(
      //                   MaterialPageRoute(builder: (context) => ReportPage(address: mapLocation)));
      //             },
      //             style: ElevatedButton.styleFrom(
      //                 padding:
      //                     const EdgeInsets.symmetric(horizontal: 5, vertical: 15)),
      //             child: const Text('Report Problem'),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<Position> _determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location Services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return Future.error('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
