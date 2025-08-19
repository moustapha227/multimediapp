import 'dart:io';

import 'package:multimediapp/path_provider.dart';

class AudioService {
  Future loadMusic() async {
    List<FileSystemEntity> audioFiles = await getAudioFiles();
    if (audioFiles.isNotEmpty) {
    } else {
      print("aucun lecteur mp3 touve");
    }
    return audioFiles;
  }
}
