import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/service/audio_service.dart';

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());

final audioListProvider = FutureProvider<List<FileSystemEntity>>((ref) async {
  final service = ref.read(audioServiceProvider);
  return await service.loadMusic();
});

// Provider pour les fichiers audio
final audioFilesProvider = FutureProvider<List<File>>((ref) async {
  return await AudioService.findAllAudioFiles();
});

// Provider pour l'état de chargement
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Provider pour rafraîchir la liste
final refreshProvider = StateProvider<int>((ref) => 0);
