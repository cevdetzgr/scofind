import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scofind/models/entities/scooter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/entities/scooter_directions.dart';
import '../models/entities/scooter_fees.dart';
import '../ui/components/scooter_bottom_sheet.dart';
import 'location_controller.dart';

class ScooterController extends GetxController {
  final _locationController = Get.find<LocationController>();
  final _scooterIcon = Rx<BitmapDescriptor?>(null);
  var markers = Rx<Set<Marker>>({});
  var points = <LatLng>[];
  final supabase = Supabase.instance.client;
  LatLng currentLocation = const LatLng(0, 0);
  List<ScooterFees> scooterFees = <ScooterFees>[];
  var scootersList = <Scooters>[].obs;
  var filteredScooterList = <Scooters>[].obs;

  var selectedBrands = <String>[].obs;
  var minBattery = 30.obs;
  var maxDistance = 800.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCustomIcon();
    _locationController.getMyLocation().then((_) {
      currentLocation = _locationController.myLocation.value!;
      fetchScootersFeesFromSupabase();
      fetchScootersFromSupabase();
    });
  }


  void fetchScootersFromSupabase() async {

    scootersList.clear();
    final response = await supabase.rpc('nearby_scooters', params: {
      'lat': currentLocation.latitude,
      'long': currentLocation.longitude,
      'maxdistance': 1500,
    });
    final scooters = response.map((item) => Scooters.fromMap(item)).toList();
    for (final scooter in scooters) {
      scootersList.add(scooter);
    }
    mapScooterFeesByBrand();
    filterScooters();
  }

  void fetchScootersFeesFromSupabase() async {
    final feeResponse = await supabase.rpc('get_scooter_fees');
    final scooterFees =
        feeResponse.map((item) => ScooterFees.fromMap(item)).toList();
    for (final fee in scooterFees) {
      this.scooterFees.add(fee);
    }
    debugPrint('Fees: ${this.scooterFees[0].startFee} - ${this.scooterFees[0].minuteFee}');
  }

  var scooterFeesMap = <String, ScooterFees>{}.obs;
  void mapScooterFeesByBrand() {
    scooterFeesMap.value.clear();
    var tempScooterFeesMap = <String, ScooterFees>{};

    for (var fee in scooterFees) {
      tempScooterFeesMap[fee.brand] = fee;
    }
    scooterFeesMap.value = tempScooterFeesMap;
  }

  void filterScooters() {
    filteredScooterList.value.clear();
    debugPrint('Filtering scooters ${scootersList.value.length}');
    var filteredScooters = scootersList.value.where((scooter) {
      final matchesBrand =
          selectedBrands.isEmpty || selectedBrands.contains(scooter.brand);
      final matchesBattery = scooter.battery >= minBattery.value;
      final matchesDistance = scooter.distance <= maxDistance.value;
      return matchesBrand && matchesBattery && matchesDistance;
    }).toList();
    filteredScooterList.value = filteredScooters;
    filteredScooterList.sort((a, b) => a.distance.compareTo(b.distance));
    createMarkers(filteredScooters);
  }

  void createMarkers(List<Scooters> scooters) async {
    var tempMarkers = <Marker>{};
    final directionsService = DirectionsService();

    // Get directions for all scooters in parallel
    var directionsFutures = scooters
        .map((scooter) =>
            getDirections(currentLocation, scooter.location, directionsService))
        .toList();
    var routes = await Future.wait(directionsFutures);

    for (var i = 0; i < scooters.length; i++) {
      final scooter = scooters[i];
      final route = routes[i];
      final marker = Marker(
        markerId: MarkerId(scooter.id.toString()),
        position: scooter.location,
        icon: _scooterIcon.value!,
        onTap: () {
          Get.bottomSheet(
            scooterBottomSheet(
              scooter,
              ScootersDirections(
                directions: route ?? const DirectionsRoute(),
              ),
            ),
          );
        },
      );
      tempMarkers.add(marker);
    }
    markers.value = tempMarkers;
  }

  Future<void> _loadCustomIcon() async {
    _scooterIcon.value = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/scooter.png");
  }

  final polylines = <Polyline>{}.obs;

  void addPolyline(DirectionsRoute location) {
    points = location.overviewPath
        ?.map((latLngLiteral) =>
        LatLng(latLngLiteral.latitude, latLngLiteral.longitude))
        .toList() ??
        <LatLng>[];
    if (points.isNotEmpty) {
      polylines.clear();
      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 4,
      );
      polylines.add(polyline);
      updatePolylines();
    }
  }

  void updatePolylines() {
    polylines.value = Set<Polyline>.from(polylines.value);
  }

  Future<DirectionsRoute?> getDirections(LatLng origin, LatLng destination,
      DirectionsService directionsService) async {
    final request = DirectionsRequest(
      origin: '${origin.latitude},${origin.longitude}',
      destination: '${destination.latitude},${destination.longitude}',
      travelMode: TravelMode.walking,
    );

    final completer = Completer<DirectionsRoute?>();
    directionsService.route(request, (response, status) {
      if (status == DirectionsStatus.ok &&
          response.routes != null &&
          response.routes!.isNotEmpty) {
        completer.complete(response.routes!.first);
      } else {
        completer.complete(null);
        debugPrint('Error: $status');
      }
    });
    return completer.future;
  }
}
