import 'package:flutter/material.dart';
import 'package:multimediapp/audio_scanner_page.dart';
import 'package:multimediapp/video_scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const AudioScannerPage(), const VideoScannerPage()];
    return Scaffold(
      //appBar: AppBar(),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Audio'),
          NavigationDestination(
            icon: Icon(Icons.ondemand_video),
            label: 'Vidéo',
          ),
        ],
      ),
    );
  }
}
