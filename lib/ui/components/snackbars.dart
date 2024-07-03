import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarsController extends SnackbarController {
  SnackbarsController(super.snackbar);

  static void showSuccessfulSnackBar() {
    Get.snackbar(
      "Başarılı",
      "Konum ve scooterlar başarıyla güncellendi",
      colorText: Colors.green,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 10),
      maxWidth: 380,
      backgroundColor: Colors.white.withOpacity(0.7),
    );
  }
}
