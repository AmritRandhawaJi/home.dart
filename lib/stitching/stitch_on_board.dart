import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StitchOnBoard extends StatefulWidget {
  const StitchOnBoard({super.key});

  @override
  State<StitchOnBoard> createState() => _StitchOnBoardState();
}

class _StitchOnBoardState extends State<StitchOnBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    rootBundle.loadString('assets/mapStyle.json').then((string) {
      _mapStyle = string;
    });
    getUserCurrentLocation();
    super.initState();
  }

  bool loadDestinationData = false;
  bool calculating = false;
  List<LatLng> pLineCoordinates = [];
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationLocationIcon = BitmapDescriptor.defaultMarker;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 0.0;
  bool addressUpdated = false;

  late GoogleMapController refController;

  late String updated;
  var yourLocationController = TextEditingController();
  var dropLocationController = TextEditingController();
  bool showModalImageLoad = false;
  late String _mapStyle;

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.593683, 78.962883),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
  _panelHeightOpen = MediaQuery.of(context).size.height;
    _panelHeightClosed = MediaQuery.of(context).size.height/3;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: _kGoogle,
          mapType: MapType.normal,

          scrollGesturesEnabled: true,
          zoomControlsEnabled: false,
          buildingsEnabled: false,
          tiltGesturesEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            controller.setMapStyle(_mapStyle);
          },
        ),
        Positioned(
          right: 20.0,
          bottom: 50,
          child: FloatingActionButton(
            onPressed: () {
              getUserCurrentLocation();
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.gps_fixed,
              color: Colors.blueGrey,
            ),
          ),
        ),
        SlidingUpPanel(
          controller: pc,
          defaultPanelState: PanelState.CLOSED,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panelBuilder: (sc) => _panel(sc),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (data) {
            _panelHeightClosed = MediaQuery.of(context).size.height / 3;
          },
        ),
      ],
    );
  }

  void getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );

    final GoogleMapController controller = await _controller.future;
    refController = controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  PanelController pc = PanelController();

  Future<void> updateMarkerLocation(LatLng position) async {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
        child: Scaffold(
   body: ListView(children: [
     Text(
       "We're searching best tailor near you",
       style: TextStyle(fontFamily: "Mukta",fontSize: MediaQuery.of(context).size.width/20),
     ),
     SizedBox(
       width: MediaQuery.of(context).size.width / 1.2,
       height: MediaQuery.of(context).size.height / 3,
       child: Lottie.asset(
         "assets/search.json",
         controller: _animationController,
         onLoaded: (composition) {
           _animationController
             ..duration = composition.duration
             ..repeat();
         },
       ),
     ),
   ],),
    ));
  }
}
