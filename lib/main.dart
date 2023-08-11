import 'package:app_medica/routes/routes.dart';
import 'package:app_medica/screens/home_screen.dart';
import 'package:app_medica/util/dependecias.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      getPages: RouterHelper.route,
    );
  }
}
