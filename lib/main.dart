import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/player_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: const MyApp()));
}

Future<void> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    print("✅ Permission accordée");
    // Lancer ton scan audio ici
  } else {
    print("❌ Permission refusée");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PlayerPage());
  }
}
