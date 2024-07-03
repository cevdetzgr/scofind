import 'package:google_maps_flutter/google_maps_flutter.dart';

class Scooters {
  String id;
  String brand;
  int battery;
  LatLng location;
  double distance;

  Scooters({
    required this.id,
    required this.brand,
    required this.battery,
    required this.location,
    required this.distance,
  });

  factory Scooters.fromMap(Map<String, dynamic> map) {
    return Scooters(
      id: map['id'].toString(),
      brand: map['brand'],
      battery: map['battery'],
      location: LatLng(map['lat'],map['long']),
      distance: map['dist_meters'],
    );
  }
}



