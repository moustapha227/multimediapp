import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photo_manager/photo_manager.dart';

class AudioPlayerScreen extends StatefulWidget {
  final AssetEntity audio;

  const AudioPlayerScreen({super.key, required this.audio});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    final file = await widget.audio.file;
    if (file != null) {
      await player.setFilePath(file.path);
      player.play();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.audio.title ?? "Lecture")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.playing == true) {
                  return IconButton(
                    icon: Icon(Icons.pause, size: 50),
                    onPressed: () => player.pause(),
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.play_arrow, size: 50),
                    onPressed: () => player.play(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
