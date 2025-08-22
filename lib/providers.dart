import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multimediapp/media_service.dart';
import 'package:photo_manager/photo_manager.dart';

final mediaServiceProvider = Provider((ref) => MediaService());
final videosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final service = ref.watch(mediaServiceProvider);
  return service.getVideos();
});
final audiosProvider = FutureProvider<List<AssetEntity>>((ref) async {
  final service = ref.watch(mediaServiceProvider);
  return service.getAudios();
});
