import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/service/audio_service.dart';

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());

final audioListProvider = FutureProvider<List<FileSystemEntity>>((ref) async {
  final service = ref.read(audioServiceProvider);
  return await service.loadMusic();
});
