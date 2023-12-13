import 'package:akij_project/app/modules/google_map/controller/cubit/geo_punch_cubit.dart';
import 'package:akij_project/app/modules/google_map/geo_punch_list/controller/cubit/geo_punch_list_cubit.dart';
import 'package:akij_project/app/modules/google_map/geo_punch_list/geo_punch_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapScreen extends StatefulWidget {
  static String routeName = '/map-screen';

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  ValueNotifier<LatLng?> currentLocationNotifier = ValueNotifier<LatLng?>(null);
  LatLng akijHouseLocation = LatLng(23.848207768277575, 90.25479520273554);
  final double radius = 100.0;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    if (await Permission.location.isGranted) {
      _getLocation();
    } else {
      await _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      _getLocation();
    } else {
      print("User denied location permission");
    }
  }

  void _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocationNotifier.value =
          LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  bool isWithinRadius() {
    if (currentLocationNotifier.value != null) {
      double distance = Geolocator.distanceBetween(
        currentLocationNotifier.value!.latitude,
        currentLocationNotifier.value!.longitude,
        akijHouseLocation.latitude,
        akijHouseLocation.longitude,
      );

      return distance <= radius;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GeoPunchCubit geoPunchCubit = BlocProvider.of<GeoPunchCubit>(context);
    final GeoPunchListCubit geoPunchListCubit =
        BlocProvider.of<GeoPunchListCubit>(context);

    Widget _buildLoadingFab() {
      return Container(
        width: 200,
        child: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {},
          tooltip: "Submitting Punch",
          mini: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Submitting Punch",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSubmitPunchFab(LatLng currentLocation) {
      return Container(
        width: 180,
        child: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            geoPunchCubit.hitGeoPunch(currentLocation);
          },
          tooltip: "Submit Punch",
          mini: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Submit Punch",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.check,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    }

    return BlocConsumer<GeoPunchCubit, GeoPunchState>(
      listener: (context, state) {
        if (state is GeoPunchDone) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Geo Punch Sumitted successfully")));
        } else if (state is GeoPunchError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(166, 255, 64, 128),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: const Text(
              "Location and Punch",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                fontFamily: 'Roboto',
                shadows: [
                  Shadow(
                    color: Colors.pink,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          body: ValueListenableBuilder<LatLng?>(
            valueListenable: currentLocationNotifier,
            builder: (context, LatLng? currentLocation, _) {
              return (currentLocation == null)
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: currentLocation,
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId("Current Location"),
                                position: currentLocation,
                                infoWindow: InfoWindow(title: "You are here"),
                              ),
                              Marker(
                                markerId: MarkerId("Akij House"),
                                position: akijHouseLocation,
                                infoWindow: InfoWindow(title: "Akij House"),
                              ),
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<LatLng?>(
                valueListenable: currentLocationNotifier,
                builder: (context, LatLng? currentLocation, _) {
                  return (isWithinRadius())
                      ? (state is GeoPunchLoading)
                          ? _buildLoadingFab()
                          : _buildSubmitPunchFab(currentLocation!)
                      : Container();
                },
              ),
              SizedBox(height: 10),
              Container(
                width: 180,
                child: FloatingActionButton(
                  backgroundColor: Colors.pinkAccent,
                  onPressed: () {
                    geoPunchListCubit.fetchGeoPunchList("399").whenComplete(() {
                      Navigator.of(context)
                          .pushNamed(GeoPunchListScreen.routeName);
                    });
                  },
                  tooltip: "Get Punch List",
                  mini: false,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Punch List",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.view_list,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
