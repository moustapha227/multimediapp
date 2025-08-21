import 'dart:io';

import 'package:multimediapp/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  Future loadMusic() async {
    List<FileSystemEntity> audioFiles = await getAudioFiles();
    if (audioFiles.isNotEmpty) {
    } else {
      print("aucun lecteur mp3 touve");
    }
    return audioFiles;
  }

  // // code dart pour recuperer les fichiers audio
  // static Future<bool> requestStoragePermission() async {
  //   print('🔐 Requesting storage permission...');
  //   final status = await Permission.storage.request();
  //   print('📋 Permission status: $status');

  //   return status.isGranted;
  // }

  // // Chemins où chercher la musique
  // static List<String> get musicFolders => [
  //   '/storage/emulated/0/Music',
  //   '/storage/emulated/0/Download',
  //   '/storage/emulated/0/DCIM',
  //   '/storage/emulated/0/Android/media',
  // ];

  // // Chercher dans un dossier spécifique
  // static Future<List<File>> searchInFolder(String folderPath) async {
  //   print('🔍 Searching in folder: $folderPath');
  //   List<File> audioFiles = [];

  //   try {
  //     Directory folder = Directory(folderPath);
  //     if (await folder.exists()) {
  //       List<FileSystemEntity> files = folder.listSync(recursive: true);

  //       for (var file in files) {
  //         if (file is File) {
  //           String path = file.path.toLowerCase();
  //           if (path.endsWith('.mp3') ||
  //               path.endsWith('.wav') ||
  //               path.endsWith('.aac')) {
  //             audioFiles.add(file);
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error accessing $folderPath: $e');
  //   }

  //   return audioFiles;
  // }

  // // Chercher dans tous les dossiers
  // static Future<List<File>> findAllAudioFiles() async {
  //   bool hasPermission = await requestStoragePermission();
  //   if (!hasPermission) return [];

  //   List<File> allAudioFiles = [];

  //   for (String folder in musicFolders) {
  //     List<File> files = await searchInFolder(folder);
  //     allAudioFiles.addAll(files);
  //   }
  //   return allAudioFiles;
  // }

  static Future<bool> requestStoragePermission() async {
    print('🔐 Requesting storage permission...');
    final status = await Permission.storage.request();
    print('📋 Permission status: $status');
    return status.isGranted;
  }

  static List<String> get musicFolders => [
    '/storage/emulated/0/Music',
    '/storage/emulated/0/Download',
    '/storage/emulated/0/DCIM',
    '/storage/emulated/0/Android/media',
    '/sdcard/Music',
    '/sdcard/Download',
  ];

  static Future<List<File>> searchInFolder(String folderPath) async {
    print('🔍 Searching in folder: $folderPath');
    List<File> audioFiles = [];

    try {
      Directory folder = Directory(folderPath);
      bool exists = await folder.exists();
      print('📁 Folder exists: $exists - $folderPath');

      if (exists) {
        List<FileSystemEntity> files = folder.listSync(recursive: true);
        print('📊 Found ${files.length} items in $folderPath');

        for (var file in files) {
          if (file is File) {
            String path = file.path.toLowerCase();
            if (path.endsWith('.mp3') ||
                path.endsWith('.wav') ||
                path.endsWith('.aac') ||
                path.endsWith('.m4a')) {
              audioFiles.add(file);
              print('🎵 Found audio: ${file.path}');
            }
          }
        }
      }
    } catch (e) {
      print('❌ Error accessing $folderPath: $e');
    }

    print('✅ Found ${audioFiles.length} audio files in $folderPath');
    return audioFiles;
  }

  static Future<List<File>> findAllAudioFiles() async {
    print('🚀 Starting audio file search...');

    bool hasPermission = await requestStoragePermission();
    print('🔑 Has permission: $hasPermission');
    if (!hasPermission) {
      print('❌ Permission denied, returning empty list');
      return [];
    }

    List<File> allAudioFiles = [];

    for (String folder in musicFolders) {
      List<File> files = await searchInFolder(folder);
      allAudioFiles.addAll(files);
    }

    print('🎉 Total audio files found: ${allAudioFiles.length}');
    print('📋 Files:');
    for (var file in allAudioFiles) {
      print('   - ${file.path}');
    }

    return allAudioFiles;
  }
}
