import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/scooter_controller.dart';

Widget scooterListBottomSheet(){
  final scooterController = Get.find<ScooterController>();
  return Obx(() =>
    Container(
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
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: scooterController.filteredScooterList.length,
              itemBuilder: (context, index) {
                final scooter = scooterController.filteredScooterList[index];
                return ListTile(
                  title: Text(scooter.brand, style: const TextStyle(fontStyle: FontStyle.italic)),
                  subtitle: Text(
                      'Batarya: ${scooter.battery}%, Mesafe: ${scooter.distance.toInt()}m'),
                  leading: Image.asset('assets/${scooter.brand}.png',
                      height: 50, width: 50),
                  trailing: Text(
                      '${scooterController.scooterFeesMap[scooter.brand]?.startFee}₺ - ${scooterController.scooterFeesMap[scooter.brand]?.minuteFee}₺'),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
