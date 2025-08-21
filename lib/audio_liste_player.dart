import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/provider.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioFilesAsync = ref.watch(audioFilesProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final refreshCount = ref.watch(refreshProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(isLoadingProvider.notifier).state = true;
              ref.read(refreshProvider.notifier).state++;
              Future.delayed(const Duration(milliseconds: 100), () {
                ref.read(isLoadingProvider.notifier).state = false;
              });
            },
          ),
        ],
      ),
      body: audioFilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(audioFilesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (audioFiles) {
          if (audioFiles.isEmpty) {
            return const Center(
              child: Text(
                'No audio files found\nCheck storage permissions',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: audioFiles.length,
            itemBuilder: (context, index) {
              final file = audioFiles[index];
              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(file.path.split('/').last),
                subtitle: Text(file.path),
                onTap: () {
                  print('Selected: ${file.path}');
                  // Just_audio viendra ici
                },
              );
            },
          );
        },
      ),
    );
  }
}
