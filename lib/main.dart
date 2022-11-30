// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panoramic Camera',
      theme: ThemeData.dark(),
      home: PanoramicCamera(title: 'Panoramic Camera'),
    );
  }
}

class PanoramicCamera extends StatefulWidget {
  PanoramicCamera({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PanoramicCameraState createState() => _PanoramicCameraState();
}

class _PanoramicCameraState extends State<PanoramicCamera> {
  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;
  int _panoId = 0;
  List<Image> panoImages = [
    Image.asset('assets/Flower.jpg'),
    Image.asset('assets/Tiger.jpg'),
    Image.asset('assets/Maldives.jpg'),
  ];
  ImagePicker picker = ImagePicker();

  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  Widget hotspotButton({String? text, IconData? icon, VoidCallback? onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.black38),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Icon(icon),
          onPressed: onPressed,
        ),
        text != null
            ? Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Center(child: Text(text)),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget panorama;
    switch (_panoId % panoImages.length) {
      case 0:
        panorama = Panorama(
          animSpeed: 1.0,
          sensorControl: SensorControl.Orientation,
          onViewChanged: onViewChanged,
          onTap: (longitude, latitude, tilt) => print('onTap: $longitude, $latitude, $tilt'),
          onLongPressStart: (longitude, latitude, tilt) => print('onLongPressStart: $longitude, $latitude, $tilt'),
          onLongPressMoveUpdate: (longitude, latitude, tilt) => print('onLongPressMoveUpdate: $longitude, $latitude, $tilt'),
          onLongPressEnd: (longitude, latitude, tilt) => print('onLongPressEnd: $longitude, $latitude, $tilt'),
          child: Image.asset('assets/Flower.jpg'),
          hotspots: [
            Hotspot(
              latitude: -15.0,
              longitude: -129.0,
              width: 50,
              height: 50,
              widget: hotspotButton(text: "Next scene", icon: Icons.open_in_browser, onPressed: () => setState(() => _panoId++)),
            ),
            Hotspot(
              latitude: -42.0,
              longitude: -46.0,
              width: 50.0,
              height: 50.0,
              widget: hotspotButton(icon: Icons.search, onPressed: () => setState(() => _panoId = 2)),
            ),
            Hotspot(
              latitude: -33.0,
              longitude: 123.0,
              width: 50.0,
              height: 50.0,
              widget: hotspotButton(icon: Icons.arrow_upward, onPressed: () {}),
            ),
          ],
        );
        break;
      case 2:
        panorama = Panorama(
          animSpeed: 1.0,
          sensorControl: SensorControl.Orientation,
          onViewChanged: onViewChanged,
          croppedArea: Rect.fromLTWH(2533.0, 1265.0, 5065.0, 2533.0),
          croppedFullWidth: 10132.0,
          croppedFullHeight: 5066.0,
          child: Image.asset('assets/Tiger.jpg'),
          hotspots: [
            Hotspot(
              latitude: 0.0,
              longitude: -46.0,
              width: 50.0,
              height: 50.0,
              widget: hotspotButton(text: "Next scene", icon: Icons.double_arrow, onPressed: () => setState(() => _panoId++)),
            ),
          ],
        );
        break;
      default:
        panorama = Panorama(
          animSpeed: 1.0,
          sensorControl: SensorControl.Orientation,
          onViewChanged: onViewChanged,
          child: panoImages[_panoId % panoImages.length],
          hotspots: [
            Hotspot(
              latitude: 0.0,
              longitude: 160.0,
              width: 50.0,
              height: 50.0,
              widget: hotspotButton(text: "Next scene", icon: Icons.double_arrow, onPressed: () => setState(() => _panoId++)),
            ),
          ],
        );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Stack(
        children: [
          panorama,
          Text('${_lon.toStringAsFixed(3)}, ${_lat.toStringAsFixed(3)}, ${_tilt.toStringAsFixed(3)}'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          final pickedFile = await picker.getImage(source: ImageSource.camera);
          setState(() {
            if (pickedFile != null) {
              panoImages.add(Image.file(File(pickedFile.path)));
              _panoId = panoImages.length - 1;
            }
          });
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}