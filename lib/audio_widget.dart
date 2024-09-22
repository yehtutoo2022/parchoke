import 'package:flutter/material.dart';
import 'package:par_choke_sayardaw/audio_player_screen.dart';
import 'package:provider/provider.dart';

import 'audio_provider.dart';

class CurrentPlayingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    if (audioPlayerProvider.currentAudio == null) {
      return SizedBox.shrink(); // Return an empty widget if no audio is playing
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AudioPlayerScreen(audio: audioPlayerProvider.currentAudio!)
        )
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blueAccent,
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                audioPlayerProvider.currentAudio!.thumbnail,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                audioPlayerProvider.currentAudio!.title,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(audioPlayerProvider.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
              onPressed: () {
                audioPlayerProvider.isPlaying ? audioPlayerProvider.pause() : audioPlayerProvider.play(audioPlayerProvider.currentAudio!.url);
              },
            ),
          ],
        ),
      ),
    );
  }
}
