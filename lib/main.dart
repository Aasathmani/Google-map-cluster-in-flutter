import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


GlobalKey<NavigatorState>? navigatorKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const GoogleMapClustering(),
    );
  }
}

class GoogleMapClustering extends StatefulWidget {
  const GoogleMapClustering({super.key});

  @override
  State<StatefulWidget> createState() => GoogleMapClusteringState();
}

class GoogleMapClusteringState extends State<GoogleMapClustering> {

  static const LatLng center = LatLng(20.5937, 78.9629);

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4.0,
  );

  static const double _markerOffsetFactor = 15;

  static const double _clusterManagerLongitudeOffset = 3;

  GoogleMapController? controller;

  late ClusterManager clusterManagers;

  Set<Marker> markers = {};

  final List<Marker> marker = [
    Marker(
      markerId: MarkerId('117901'),
      position: LatLng(8.5547675, 76.8883324),
      infoWindow: InfoWindow(title: 'zz'),
    ),
    Marker(
      markerId: MarkerId('118356'),
      position: LatLng(22.5544069, 72.8286535),
      infoWindow: InfoWindow(title: 'Testing13'),
    ),
    Marker(
      markerId: MarkerId('117902'),
      position: LatLng(13.0134383, 80.1899459),
      infoWindow: InfoWindow(title: 'Testing'),
    ),
    Marker(
      markerId: MarkerId('118351'),
      position: LatLng(25.7616798, -80.1917902),
      infoWindow: InfoWindow(title: 'Testing8'),
    ),
    Marker(
      markerId: MarkerId('117903'),
      position: LatLng(8.5547675, 76.8883324),
      infoWindow: InfoWindow(title: 'Elep'),
    ),
    Marker(
      markerId: MarkerId('113851'),
      position: LatLng(8.5557122, 76.8836975),
      infoWindow: InfoWindow(title: 'Farmland (SMM)'),
    ),
    Marker(
      markerId: MarkerId('117904'),
      position: LatLng(8.6127082, 76.808719),
      infoWindow: InfoWindow(title: 'ss'),
    ),
    Marker(
      markerId: MarkerId('118352'),
      position: LatLng(35.9551753, 139.8741905),
      infoWindow: InfoWindow(title: 'Testing9'),
    ),
    Marker(
      markerId: MarkerId('117905'),
      position: LatLng(12.6819372, 79.9888413),
      infoWindow: InfoWindow(title: 'Testing3'),
    ),
    Marker(
      markerId: MarkerId('117906'),
      position: LatLng(10.9571032, 76.922014),
      infoWindow: InfoWindow(title: 'Testing4'),
    ),
    Marker(
      markerId: MarkerId('118357'),
      position: LatLng(44.7626133, 18.2954221),
      infoWindow: InfoWindow(title: 'Testing14'),
    ),
    Marker(
      markerId: MarkerId('118353'),
      position: LatLng(39.074208, 21.824312),
      infoWindow: InfoWindow(title: 'Testing10'),
    ),
    Marker(
      markerId: MarkerId('117352'),
      position: LatLng(9.5783454, 76.5068215),
      infoWindow: InfoWindow(title: 'Tiger'),
    ),
    Marker(
      markerId: MarkerId('118354'),
      position: LatLng(44.8128212, 20.3667696),
      infoWindow: InfoWindow(title: 'Testing11'),
    ),
    Marker(
      markerId: MarkerId('118355'),
      position: LatLng(52.9119516, 19.1199145),
      infoWindow: InfoWindow(title: 'Testing12'),
    ),
    Marker(
      markerId: MarkerId('118358'),
      position: LatLng(15.2993265, 74.123996),
      infoWindow: InfoWindow(title: 'Testing12'),
    ),
    Marker(
      markerId: MarkerId('115702'),
      position: LatLng(8.5557122, 76.8836975),
      infoWindow: InfoWindow(title: 'd'),
    ),
    // Add more markers as needed
  ];


  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _addClusterManager() {
    _addMarkersToCluster();
  }

  void _addMarkersToCluster() {
    for (var asset in marker) {
      final MarkerId markerId = MarkerId(asset.markerId.toString());
      const double clusterManagerLongitudeOffset =  _clusterManagerLongitudeOffset;
      final Marker marker = Marker(
        anchor: const Offset(.5,.5),
        clusterManagerId: clusterManagers.clusterManagerId,
        markerId: markerId,
        position: asset.position,
      );
      markers.add(marker

      );
      print(marker);
      print(clusterManagers.clusterManagerId);

    }
    setState(() {});
  }

  double _getRandomOffset() {
    return (Random().nextDouble() - 0.5) * _markerOffsetFactor;
  }

  @override
  void initState() {
    super.initState();
    clusterManagers = ClusterManager(
      clusterManagerId: const ClusterManagerId("clusterManagerId"),
      onClusterTap: (Cluster cluster) => setState(() {
        controller?.animateCamera(CameraUpdate.newLatLngBounds(cluster.bounds, 50));
      }),
    );
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        _addClusterManager();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            clusterManagers: {clusterManagers},
          ),
        ),
      ],
    );
  }
}