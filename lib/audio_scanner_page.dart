import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/audio_player_screen.dart';
import 'package:multimediapp/providers.dart';
import 'package:photo_manager/photo_manager.dart';

class AudioScannerPage extends ConsumerWidget {
  const AudioScannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audiosAsync = ref.watch(audiosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Mes audios")),
      body: audiosAsync.when(
        data: (audios) {
          if (audios.isEmpty) {
            return const Center(child: Text("Aucun audio trouvé"));
          }
          return ListView.builder(
            itemCount: audios.length,
            itemBuilder: (context, index) {
              final audio = audios[index];
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioPlayerScreen(audio: audio),
                  ),
                ),
                title: Text(audio.title ?? "Sans titre"),
                subtitle: Text(audio.duration.toString()),
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
