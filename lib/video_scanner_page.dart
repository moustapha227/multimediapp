import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/providers.dart';
import 'package:multimediapp/video_player_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoScannerPage extends ConsumerWidget {
  const VideoScannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Mes vidéos")),
      body: videosAsync.when(
        data: (videos) {
          if (videos.isEmpty) {
            return const Center(child: Text("Aucune vidéo trouvée"));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return FutureBuilder<Uint8List?>(
                future: video.thumbnailDataWithSize(
                  const ThumbnailSize(200, 200),
                ),
                builder: (context, snapshot) {
                  final bytes = snapshot.data;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(video: video),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (bytes != null)
                          Image.memory(bytes, fit: BoxFit.cover)
                        else
                          Container(color: Colors.black12),
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 10),
                Text("Erreur : $err"),
                ElevatedButton(
                  onPressed: () => PhotoManager.openSetting(),
                  child: const Text("Ouvrir les paramètres"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
