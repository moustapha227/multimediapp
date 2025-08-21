import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<List<FileSystemEntity>> getAudioFiles() async {
  Directory? dir = await getExternalStorageDirectory();

  if (dir == null) {
    return [];
  }
  List<FileSystemEntity> files = dir.listSync(recursive: true);
  List<FileSystemEntity> audioFiles = files.where((file) {
    return file.path.endsWith(".mp3") ||
        file.path.endsWith(".wav") ||
        file.path.endsWith(".aac");
  }).toList();
  return audioFiles;
}
