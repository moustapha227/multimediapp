import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final AssetEntity video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadVideo() async {
    try {
      final file = await widget.video.file;
      if (file != null) {
        _controller = VideoPlayerController.file(file)
          ..addListener(() {
            if (mounted) {
              setState(() {
                _isPlaying = _controller.value.isPlaying;
              });
            }
          })
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _isPlaying = true;
                _controller.play();
              });
            }
          });
      } else {
        setState(() => _isLoading = false);
        // Gérer l'erreur: fichier non trouvé
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // Gérer l'erreur
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lecture vidéo")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _togglePlayPause,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
    );
  }
}
