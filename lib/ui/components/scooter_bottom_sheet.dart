import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scofind/models/entities/scooter.dart';

import '../../controllers/scooter_controller.dart';
import '../../models/entities/scooter_directions.dart';

Widget scooterBottomSheet(
    Scooters scooter, ScootersDirections scooterDirections) {
  final scooterController = Get.find<ScooterController>();

  return Container(
    height: 250,
    padding: const EdgeInsets.all(20.0),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    child: Column(
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
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/${scooter.brand}.png',
                width: 90,
                height: 90,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    scooter.brand,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: scooter.battery > 50
                            ? Colors.green
                            : scooter.battery > 20
                                ? Colors.orange
                                : Colors.red,
                      ),
                      const SizedBox(width: 1),
                      Text('${scooter.battery}%'),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on),
                      const SizedBox(width: 1),
                      Text('${scooter.distance.toInt()}m'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Başlangıç: ${scooterController.scooterFees.where((scooterFee) =>
                          scooterFee.brand.contains(scooter.brand)).first.startFee} ₺"),
                      const SizedBox(
                        width: 20,
                      ),
                      Text("Dakika: ${scooterController.scooterFees.where((scooterFee) =>
                          scooterFee.brand.contains(scooter.brand)).first.minuteFee} ₺"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      final locat = scooterDirections.directions;
                      scooterController.addPolyline(locat);
                    },
                    child: const Text(
                      "Rota Oluştur",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
