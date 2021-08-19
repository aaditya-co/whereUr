import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhereUr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WhereUr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  var locationMessage = '';
  Position _position;
  final YandexGeocoder geo =
      YandexGeocoder(apiKey: '67592179-a250-4b9b-ac87-30ba420de147');

  String address = "Press Button to get Location Cordinates";

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _position = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.amber,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.amber,
            title: Text(widget.title,
                style: GoogleFonts.pacifico(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.location_on_rounded),
              color: Colors.black,
            )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            child: Icon(Icons.location_searching),
            onPressed: () async {
              getCurrentLocation();
              _getCurrentLocation();
              address = 'Press Location Button to get Address';

              setState(() {});
              double lat = _position.latitude;
              double lon = _position.longitude;
              final GeocodeResponse _address =
                  await geo.getGeocode(GeocodeRequest(
                geocode: PointGeocode(latitude: lat, longitude: lon),
                lang: Lang.enEn,
              ));
              address = _address.firstAddress.formatted;
              setState(() {});
            }),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width / 0.6,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (_position != null)
              Text(
                "LAT: ${_position.latitude}, LNG: ${_position.longitude}",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
              ),
            Text(
              address,
              style: GoogleFonts.handlee(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
