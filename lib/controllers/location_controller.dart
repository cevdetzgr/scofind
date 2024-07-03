import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' hide LocationAccuracy;

class LocationController extends GetxController {
  final locationPackage = Location();
  var myLocation = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    getMyLocation();
  }

  Future<void> getMyLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationPackage.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationPackage.requestService();
      if (!serviceEnabled) {
        Get.snackbar(
          'Hata',
          'Konum servisleri etkinleştirilemedi.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
          margin: const EdgeInsets.only(top: 10),
          maxWidth: 380,
        );
        return;
      }
    }

    permissionGranted = await locationPackage.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationPackage.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Get.snackbar(
          'Hata',
          'Konum izni verilmedi.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
          margin: const EdgeInsets.only(top: 10),
          maxWidth: 380,
        );
        return;
      }
    }

    final locationData = await locationPackage.getLocation();
    myLocation.value = LatLng(locationData.latitude!, locationData.longitude!);
  }
}
