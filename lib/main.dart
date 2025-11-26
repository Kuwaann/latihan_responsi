import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_responsi/models/amiibo_model.dart';
import 'package:latihan_responsi/screens/detail_screen.dart';
import 'package:latihan_responsi/screens/favorite_screen.dart';
import 'package:latihan_responsi/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AmiiboModelAdapter());
  Hive.registerAdapter(AmiiboReleaseAdapter());
  await Hive.openBox<AmiiboModel>('amiiboBox');
  await Hive.openBox<AmiiboModel>('favoriteBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nitendo Amiibo',
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {
        '/': (context) => HomeScreen(),
        '/detail': (context) => DetailScreen(),
        '/favorite': (context) => FavoriteScreen(),
      },
      initialRoute: '/',
    );
  }
}
