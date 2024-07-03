import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Widget userBottomSheet(){
  return Container(
        height: Get.height * 0.35,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Hoşgeldiniz!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(FirebaseAuth.instance.currentUser!.email!,
                      style: const TextStyle(fontSize: 20)),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Get.offAllNamed('/sign-in');
                    },
                    child: const Text("Çıkış Yap"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
