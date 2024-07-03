import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scofind/controllers/location_controller.dart';
import 'package:scofind/controllers/scooter_controller.dart';
import 'package:scofind/ui/components/filter_bottom_sheet.dart';
import '../components/scooterList_bottom_sheet.dart';
import '../components/snackbars.dart';
import '../components/user_bottom_sheet.dart';

class Anasayfa extends GetWidget {
  const Anasayfa({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final scooterController = Get.find<ScooterController>();

    return Scaffold(
      body: Obx(() => Stack(children: [
            locationController.myLocation.value == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: locationController.myLocation.value!,
                      zoom: 15,
                    ),
                    markers: scooterController.markers.value,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    polylines: scooterController.polylines.value,
                    minMaxZoomPreference: const MinMaxZoomPreference(13, 19),
                  ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 5,
                          child: Image.asset("assets/logo.png"),
                        ),
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.filter_alt_rounded,
                              size: 30,
                            ),
                            onPressed: () {
                              Get.bottomSheet(
                                filterBottomSheet(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  userBottomSheet(),
                                );
                              },
                              child: const Icon(Icons.menu)),
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.bottomSheet(
                                scooterListBottomSheet(),
                              );
                            },
                            child: const Text("Scooterlar"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {
                                locationController.getMyLocation().then((_) {
                                  scooterController.fetchScootersFromSupabase();
                                  scooterController.filterScooters();
                                  SnackbarsController.showSuccessfulSnackBar();
                                });
                              },
                              child: const Icon(Icons.radar_rounded)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
