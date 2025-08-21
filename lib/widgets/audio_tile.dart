import 'package:flutter/material.dart';
import 'package:multimediapp/models/audio.dart';

class AudioTile extends StatelessWidget {
  final Audio audio;
  final bool isPlaying;
  final VoidCallback? onTap;
  const AudioTile({
    super.key,
    required this.audio,
    required this.isPlaying,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPlaying ? Colors.purpleAccent : Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: isPlaying ? Border.all(color: Colors.purple, width: 1) : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(),
          child: Icon(
            isPlaying ? Icons.music_note : Icons.music_note_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          audio.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
