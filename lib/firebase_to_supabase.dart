import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> transferData() async {
  // Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Verileri firestore'dan çek
  QuerySnapshot snapshot = await firestore.collection('scooters').get();
  List<QueryDocumentSnapshot> documents = snapshot.docs;

  // Supabase client
  final supabase = Supabase.instance.client;

  for (var doc in documents) {
    var data = doc.data() as Map<String, dynamic>;

    // Null kontrolü
    if (data['brand'] == null || data['battery'] == null || data['location'] == null) {
      print('Invalid data: $data');
      continue;
    }

    // ID harici verileri değişkenlere ata
    var brand = data['brand'];
    var battery = data['battery'];

    GeoPoint geoPoint = data['location'];
    var latitude = geoPoint.latitude;
    var longitude = geoPoint.longitude;

    // Verileri Supabase'e ekle
    await supabase.from('scooters').insert([
      {
        'brand': brand,
        'battery': battery,
        'location': 'POINT($latitude $longitude)', // PostGIS format
      }
    ]);
  }

  print('Data transfer complete.');
}

