import 'package:photo_manager/photo_manager.dart';

class MediaService {
  Future<List<AssetEntity>> getVideos() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      throw Exception("Permission refusée");
    }
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
      onlyAll: true,
    );

    if (albums.isEmpty) {
      return [];
    }
    final allVideos = albums.first;
    final total = await allVideos.assetCountAsync;
    final collected = <AssetEntity>[];
    for (int page = 0; collected.length < total; page++) {
      final chunk = await allVideos.getAssetListPaged(page: page, size: 100);
      if (chunk.isEmpty) break;
      collected.addAll(chunk);
    }
    return collected;
  }

  Future<List<AssetEntity>> getAudios() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      throw Exception("Permission refusée");
    }
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.audio,
      onlyAll: true,
    );

    if (albums.isEmpty) {
      return [];
    }
    final allAudios = albums.first;
    final total = await allAudios.assetCountAsync;
    final collected = <AssetEntity>[];
    for (int page = 0; collected.length < total; page++) {
      final chunk = await allAudios.getAssetListPaged(page: page, size: 100);
      if (chunk.isEmpty) break;
      collected.addAll(chunk);
    }
    return collected;
  }
}
