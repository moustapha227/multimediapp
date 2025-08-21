import 'package:flutter/material.dart';
import 'package:multimediapp/audio_screen.dart';
import 'package:multimediapp/main.dart';
import 'package:multimediapp/models/audio.dart';
import 'package:multimediapp/service/music_service.dart';
import 'package:multimediapp/widgets/audio_tile.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final MusicService _musicService = MusicService();
  List<Audio> _audios = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    _loadAudio();
  }

  Future<void> _loadAudio() async {
    setState(() {
      _isLoading = true;
    });

    _audios = await _musicService.scanForAudios();

    setState(() {
      _isLoading = false;
    });
  }

  void _onAudioTap(int index) async {
    await _musicService.playAudio(index);
    setState(() {});
  }

  void _openAudioScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AudioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MULTIMEDIA PALYER AUDIO & VIDEO"),
        actions: [
          IconButton(onPressed: _loadAudio, icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () => _openAudioScreen(context),
            icon: Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.purpleAccent),
                        SizedBox(height: 20),
                        Text(
                          "Scannages des fichiers Audios....",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : _audios.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_off,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Pas de Audio",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAudio,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Scanner encore"),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _audios.length,
                    itemBuilder: (context, index) {
                      return AudioTile(
                        audio: _audios[index],
                        isPlaying: _musicService.currentIndex == index,
                        onTap: () => _onAudioTap(index),
                      );
                    },
                  ),
          ),
          // if (_musicService.currentAudio != null)
          //   Miniplayer(
          //     onTap: _openAudioScreen,
          //     onPlayPause: () async {
          //       await _musicService.playPause();
          //       setState(() {});
          //     },
          //   ),
        ],
      ),
    );
  }
}
