
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/individual_model.dart';
import 'package:user/app/backend/models/salon_model.dart';
import 'package:user/app/backend/parse/near_parse.dart';
import 'package:user/app/controller/services_controller.dart';
import 'package:user/app/controller/specialist_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import '../env.dart';

const double cameraZoom = 16;
const double cameraTilt = 80;
const double cameraBearing = 30;

class NearController extends GetxController implements GetxService {
  final NearParser parser;
  bool apiCalled = false;

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<IndividualModel> _individualList = <IndividualModel>[];
  List<IndividualModel> get individualList => _individualList;

  final Set<Marker> markers = {};
  late CameraPosition initialCameraPosition;
  final Completer<GoogleMapController> googleMapsController = Completer();

  bool haveData = false;

  NearController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    getHomeData();
  }

  Future<void> getHomeData() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getHomeData(param);
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonData = myMap['salon'];
      var individualData = myMap['individual'];
      _salonList = [];
      _individualList = [];
      salonData.forEach((data) {
        SalonModel salon = SalonModel.fromJson(data);
        _salonList.add(salon);
      });
      debugPrint(salonList.length.toString());

      individualData.forEach((data) {
        IndividualModel individual = IndividualModel.fromJson(data);
        _individualList.add(individual);
      });
      var destPosition = LatLng(parser.getLat(), parser.getLng());
      initialCameraPosition = CameraPosition(zoom: cameraZoom, tilt: cameraTilt, bearing: cameraBearing, target: destPosition);
      debugPrint(individualList.length.toString());

      for (var element in _salonList) {
        final Uint8List markerIcon = await _getBytesFromUrl('${Environments.apiBaseURL}storage/images/'+element.cover.toString(), 100);

        markers.add(
          Marker(
            markerId: MarkerId('${element.id}salon'),
            position: LatLng(element.salonLat as double, element.salonLng as double), //position of marker
            infoWindow: InfoWindow(title: element.name, snippet: element.totalRating.toString()),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      }

      for (var element in _individualList) {
        final Uint8List markerIcon = await _getBytesFromUrl('${Environments.apiBaseURL}storage/images/'+element.userInfo!.cover.toString(), 100);

        markers.add(
          Marker(
            markerId: MarkerId('${element.uid}freelancer'),
            position: LatLng(element.lat as double, element.lng as double), //position of marker
            infoWindow: InfoWindow(
              title: '${element.userInfo!.firstName} ${element.userInfo!.lastName}',
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      }

      if (salonList.isEmpty && individualList.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onFilter() {
    Get.toNamed(AppRouter.getFilterRoutes(), arguments: ['']);
  }

  void onServices(int uid) {
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
  }

  void onSpecialist(int uid) {
    Get.delete<SpecialistController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
  }


  Future<Uint8List> _getBytesFromUrl(String url, int width) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await _circleCrop(fi.image, width);
    return byteData!.buffer.asUint8List();
  }
/*
  Future<Uint8List> _getBytesFromUrl(String url, int width) async {

    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;
    final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }*/

  Future<ByteData?> _circleCrop(ui.Image image, int size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint();
    final double radius = size / 2;

    paint.isAntiAlias = true;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    paint.shader = ImageShader(
      image,
      TileMode.clamp,
      TileMode.clamp,
      Matrix4.identity().scaled(size / image.width, size / image.height).storage,
    );

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    final ui.Image circularImage = await pictureRecorder
        .endRecording()
        .toImage(size, size);

    return circularImage.toByteData(format: ui.ImageByteFormat.png);
  }
}
