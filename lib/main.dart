import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:scofind/controllers/scooter_controller.dart';
import 'package:scofind/ui/views/anasayfa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/location_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DirectionsService.init(googleApiKey);
  await Supabase.initialize(
    url: 'https://zsjrrddlpzlnmguzbtam.supabase.co',
    anonKey: supabaseAnonKey,
  );
  Get.put(LocationController());
  Get.put(ScooterController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider(), GoogleAuthProvider()];
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          // Genel tonu belirler
          primary: Colors.indigo[800],
          // Ana renk
          secondary: Colors.indigo[200],
          // İkincil renk
          surface: Colors.grey[200],
          // Yüzey rengi
          error: Colors.red[700],
          // Hata rengi
          onPrimary: Colors.white,
          // Ana rengin üzerindeki renk
          onSecondary: Colors.black,
          // İkincil rengin üzerindeki renk
          onSurface: Colors.black,
          // Yüzey renginin üzerindeki renk
          onError: Colors.black,
          // Hata renginin üzerindeki renk
        ),
        useMaterial3: true,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser != null ? '/anasayfa' : '/sign-in',
      getPages: [
        GetPage(
          name: '/anasayfa',
          page: () => const Anasayfa(),
        ),
        GetPage(
          name: '/sign-in',
          page: () {
            return SignInScreen(providers: [
              EmailAuthProvider()
            ], actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/anasayfa');
              }),
            ],
              showPasswordVisibilityToggle: true,
            );
          },
        )
      ],
    );
  }
}
