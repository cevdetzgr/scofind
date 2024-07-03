import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/scooter_controller.dart';

Widget filterBottomSheet() {
  final scooterController = Get.find<ScooterController>();
  final scootersList = scooterController.scootersList.value;

  // Unique brands list
  final brands = scootersList.map((scooter) => scooter.brand).toSet().toList();

  return Container(
    padding: const EdgeInsets.all(20.0),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Markalar"),
        Expanded(
          child: ListView(
            children: brands.map((brand) {
              return Obx(() => CheckboxListTile(
                    secondary: Image.asset('assets/${brand}.png', height: 20, width: 20),
                    title: Text(brand),
                    value: scooterController.selectedBrands.contains(brand),
                    onChanged: (bool? value) {
                      if (value == true) {
                        scooterController.selectedBrands.add(brand);
                      } else {
                        scooterController.selectedBrands.remove(brand);
                      }
                    },
                  ));
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Minimum Batarya Seviyesi"),
        Obx(
          () => Slider(
            value: scooterController.minBattery.value.toDouble(),
            min: 0,
            max: 80,
            divisions: 8,
            label: scooterController.minBattery.value.toString(),
            onChanged: (value) {
              scooterController.minBattery.value = value.toInt();
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text("Maksimum Mesafe"),
        Obx(
          () => Slider(
            value: scooterController.maxDistance.value.toDouble(),
            min: 500,
            max: 1500,
            divisions: 10,
            autofocus: true,
            label: scooterController.maxDistance.value.toString(),
            onChanged: (value) {
              scooterController.maxDistance.value = value.toInt();
            },
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
              onPressed: () {
                scooterController.filterScooters();
                Get.back();
              },
              child: const Text("Filrele")),
        ),
      ],
    ),
  );
}
