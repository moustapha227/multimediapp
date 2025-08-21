import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:multimediapp/main.dart';
import 'package:multimediapp/models/audio.dart';
import 'package:path/path.dart' as path;

class MusicService {
  static final MusicService _intance = MusicService._internal();

  factory MusicService() => _intance;
  MusicService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Audio> _audios = [];
  int _currentIndex = -1;

  AudioPlayer get audioPlayer => _audioPlayer;
  List<Audio> get audios => _audios;
  int get currentIndex => _currentIndex;
  Audio? get _currentAudio =>
      _audios.isNotEmpty ? _audios[_currentIndex] : null;

  Future<List<Audio>> scanForAudios() async {
    _audios.clear();
    try {
      final allDirectories = await _getAllStorageDirectories();
      for (String dirPath in allDirectories) {
        await _scanDirectoryRecursively(dirPath);
      }
      _audios = _removeDuplicates(_audios);
      _audios.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    } catch (e) {
      print("Error scanning for audios: $e");
    }
    return _audios;
  }

  Future<List<String>> _getAllStorageDirectories() async {
    List<String> directories = [];

    // final primaryPaths = [
    //   '/storage/emulated/0',
    //   '/storage/emulated/0/Music',
    //   '/storage/emulated/0/Download',
    //   '/storage/emulated/0/Android/data',
    //   '/storage/emulated/0/Android/media',
    //   '/storage/emulated/0/Media',
    //   '/storage/emulated/0/Audio',
    //   '/storage/emulated/0/Podcasts',
    //   '/storage/emulated/0/AudioBooks',
    //   '/storage/emulated/0/Ringtones',
    //   '/storage/emulated/0/Alarms',
    //   '/sdcard',
    // ];
    // final secondaryPaths = [
    //   '/storage/emulated/1',
    //   '/storage/sdcard1',
    //   '/storage/sdcard2',
    //   '/storage/extSdCard',
    //   '/storage/external_SD',
    //   '/storage/external_SDCard',
    // ];

    // directories.addAll(primaryPaths);
    // directories.addAll(secondaryPaths);

    try {
      final storageDir = Directory('/storage');
      if (await storageDir.exists()) {
        await requestStoragePermission();
        await for (FileSystemEntity entity in storageDir.list(
          recursive: false,
        )) {
          print('apres storge');
          if (entity is Directory && !directories.contains(entity.path)) {}
        }
      }
    } catch (e) {
      print("Error getting storge directories: $e");
    }
    List<String> existingDirs = [];
    for (String dir in directories) {
      final directory = Directory(dir);
      if (await directory.exists()) {
        existingDirs.add(dir);
      }
    }
    return existingDirs;
  }

  Future<void> _scanDirectoryRecursively(String dirPath) async {
    try {
      final directory = Directory(dirPath);
      await for (FileSystemEntity entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File && _isAudioFile(entity.path)) {
          try {
            final audio = await _createAudioFromFile(entity);
            if (audio != null) {
              _audios.add(audio);
            }
          } catch (e) {
            print("Error processing file ${entity.path}: $e");
            continue;
          }
        }
      }
    } catch (e) {
      print("Error scanning directory $dirPath: $e");
    }
  }

  bool _isAudioFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    final audioExtension = [
      '.mp3',
      '.wav',
      '.flac',
      '.aac',
      '.ogg',
      '.m4a',
      '.wma',
      '.opus',
    ];
    return audioExtension.contains(extension);
  }

  Future<Audio?> _createAudioFromFile(File file) async {
    try {
      final fileName = path.basenameWithoutExtension(file.path);
      String title = fileName;
      String artist = 'Artist inconnue';
      String album = 'Album inconnue';
      Duration duration = Duration.zero;
      try {
        final temPlayer = AudioPlayer();
        await temPlayer.setFilePath(file.path);
        if (temPlayer.duration != null) {
          duration = temPlayer.duration!;
        }
        await temPlayer.dispose();
      } catch (e) {
        if (fileName.contains(' - ')) {
          final parts = fileName.split(' - ');
          if (parts.length >= 2) {
            artist = parts[0].trim();
            title = parts.sublist(1).join(' - ').trim();
          }
        }
      }
      return Audio(
        title: title,
        artist: artist,
        album: album,
        path: file.path,
        duration: duration,
      );
    } catch (e) {
      print("Error creating song from file ${file.path}");
      return null;
    }
  }

  List<Audio> _removeDuplicates(List<Audio> audios) {
    final seen = <String>{};
    return audios.where((audio) {
      final key = '${audio.title}-${audio.artist}-${audio.duration.inSeconds}';
      return seen.add(key);
    }).toList();
  }

  Future<void> playAudio(int index) async {
    if (index >= 0 && index < _audios.length) {
      _currentIndex = index;
      await _audioPlayer.setFilePath(_audios[index].path);
      await _audioPlayer.play();
    }
  }

  Future<void> playPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> skipNext() async {
    if (_currentIndex < _audios.length - 1) {
      await playAudio(_currentIndex + 1);
    } else {
      await playAudio(0);
    }
  }

  Future<void> skipPrevious() async {
    if (_currentIndex > 0) {
      await playAudio(_currentIndex - 1);
    } else {
      await playAudio(_audios.length - 1);
    }
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void shufflePlaylist() {
    if (_audios.length > 1) {
      final currentAudio = _audios[currentIndex];
      _audios.shuffle();

      final newIndex = _audios.indexOf(currentAudio);
      if (newIndex != _currentIndex) {
        final temp = _audios[_currentIndex];
        _audios[_currentIndex] = currentAudio;
        _audios[newIndex] = temp;
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    _audios.clear();
    _currentIndex = -1;
  }
}
