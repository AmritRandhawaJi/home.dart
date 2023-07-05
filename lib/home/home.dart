import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:okstitch/assistants/request_api.dart';
import 'package:okstitch/profile.dart';
import 'package:okstitch/stitching/stitch_on_board.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late GoogleMapController refController;
  late String address;
  late String dayTime;

  bool dayLoading = false;

  var pc = PanelController();

  Future<void> getPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // if (Platform.isAndroid) {
      //   showDialog(
      //     context: context,
      //     builder: (ctx) =>  AlertDialog(
      //       actions: [
      //         TextButton(onPressed: (){
      //
      //         }, child: Text("Allow")),
      //         TextButton(onPressed: (){
      //           Navigator.pop(ctx);
      //         }, child: Text("Cancel")),
      //
      //       ],
      //       title: Text("Permission Denied"),
      //         content: Text("Permission Denied please allow permission to get nearby available services ")),
      //   );
      // }
      if (permission == LocationPermission.deniedForever) {
        showLocationError();
        return Future.error('Location Not Available');
      }
    } else {
      getUserCurrentLocation();
    }
  }

  void getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    address = await RequestMethods.searchCoordinateRequests(position);

    setState(() {
      locating = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    getPermission();
    var hour = DateTime.now().hour;
    if (hour <= 12) {
      dayTime = "Good Morning, ";
    } else if ((hour > 12) && (hour <= 16)) {
      dayTime = "Good Afternoon, ";
    } else if ((hour > 16) && (hour < 20)) {
      dayTime = "Good Evening, ";
    } else {
      dayTime = "Good Night, ";
    }
    setState(() {
      dayLoading = true;
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool locating = true;

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height / 1.2;
    double minHeight = 0;
    return Scaffold(
        backgroundColor: const Color(0XFFf0f0f0),
        key: _key,
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        )),
        body: Stack(alignment: Alignment.topCenter, children: [
          SlidingUpPanel(
            maxHeight: maxHeight,
            minHeight: minHeight,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            controller: pc,
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              minHeight = maxHeight;
            }),
          ),
        ]));
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.width / 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      _key.currentState!.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      size: MediaQuery.of(context).size.width / 15,
                      color: Colors.black,
                    )),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.notifications_none,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.fiber_manual_record_rounded,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.width / 25,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (Platform.isAndroid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Profile(),
                                ));
                          }
                          if (Platform.isIOS) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const Profile(),
                                ));
                          }
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline_sharp,
                            color: Colors.black,
                            size: MediaQuery.of(context).size.width / 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
            child: Row(
              children: [
                dayLoading
                    ? DelayedDisplay(
                        child: Text(
                          dayTime,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Nunito",
                              fontSize: MediaQuery.of(context).size.width / 22),
                        ),
                      )
                    : const Text(""),
                Text(
                  "Amrit",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Nunito",
                      fontSize: MediaQuery.of(context).size.width / 22),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 20,
                top: MediaQuery.of(context).size.width / 20),
            child: Row(
              children: [
                DelayedDisplay(
                  child: Text(
                    'What you gonna\nget stitched today?',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: const Color(0xff29294a),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        maxRadius: MediaQuery.of(context).size.height / 35,
                        backgroundColor: const Color(0xfff7834d),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height / 30,
                        ),
                      ),
                    ),
                    locating
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 7,
                            child: Lottie.asset(
                              "assets/loading-bars.json",
                              controller: _controller,
                              onLoaded: (composition) {
                                _controller
                                  ..duration = composition.duration
                                  ..repeat();
                              },
                            ),
                          )
                        : Expanded(
                            child: Text(
                              address,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 75),
                              softWrap: false,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          CarouselSlider(
            items: [
              //1st Image of Slider
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/okstitch-3a3ca.appspot.com/o/50%25OFF-3.png?alt=media&token=aa389447-979b-48d6-aaef-d0808c21076b"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //2nd Image of Slider
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/okstitch-3a3ca.appspot.com/o/50%25OFF-3.png?alt=media&token=aa389447-979b-48d6-aaef-d0808c21076b"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //3rd Image of Slider
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/okstitch-3a3ca.appspot.com/o/50%25OFF-3.png?alt=media&token=aa389447-979b-48d6-aaef-d0808c21076b"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],

            //Slider Container properties
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width / 3,
              enlargeCenterPage: true,
              autoPlay: false,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 2000),
              viewportFraction: 0.8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Find Services",
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: MediaQuery.of(context).size.width / 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.width / 2.2,
                child: GestureDetector(
                  onTap: () {
                    if (Platform.isAndroid) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StitchOnBoard(),
                          ));
                    }
                    if (Platform.isIOS) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const StitchOnBoard(),
                          ));
                    }
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Image.asset(
                            "assets/machine.png",
                          ),
                        ),
                        Text(
                          "Stitching",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Nunito",
                              fontSize: MediaQuery.of(context).size.width / 28),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.width / 2.2,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Image.asset(
                          "assets/drycleaner.png",
                        ),
                      ),
                      Text(
                        "Dry Cleaner",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Nunito",
                            fontSize: MediaQuery.of(context).size.width / 28),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CupertinoButton(
                color: const Color(0xff29294a),
                onPressed: () {
                  pc.open();
                },
                child: const Text("Buy Cloths")),
          )
        ],
      ),
    );
  }

  _panel(ScrollController sc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showLocationError() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SafeArea(
          child: Column(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              Text("Permission Denied"),
              Text(
                  "Permission Denied forever without permission we are not able to assist you better please go to settings to enable app location ")
            ],
          ),
        );
      },
    );
  }
}
