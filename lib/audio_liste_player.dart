import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/provider.dart';

class AudioListePlayer extends ConsumerWidget {
  const AudioListePlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioProvider = ref.watch(audioListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des audios locaux")),
      body: audioProvider.when(
        data: (audioFiles) {
          if (audioFiles.isEmpty) {
            return const Center(child: Text("Aucun fichier audio trouvé"));
          }
          return ListView.builder(
            itemCount: audioFiles.length,
            itemBuilder: (context, index) {
              String fileName = audioFiles[index].path.split('/').last;
              return ListTile(title: Text(fileName), onTap: () {});
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Erreur: $err")),
      ),
    );
  }
}
