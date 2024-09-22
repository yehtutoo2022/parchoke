import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'audio_provider.dart';
import 'model/audio_model.dart';

//added to github
class AudioPlayerScreen extends StatelessWidget {
  final Audio audio;

  const AudioPlayerScreen({Key? key, required this.audio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album Art
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ClipOval(
              child: Image.network(
                audio.thumbnail,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          ),
          // Song Title
          Text(
            audio.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Subtitle
          Text(
            audio.subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // Progress Bar
          Slider(
            value: audioPlayerProvider.position.inSeconds.toDouble(),
            min: 0.0,
            max: audioPlayerProvider.duration.inSeconds.toDouble(),
            onChanged: (newValue) {
              audioPlayerProvider.seek(Duration(seconds: newValue.toInt()));
            },
          ),
          Text('${audioPlayerProvider.position.inMinutes}:${(audioPlayerProvider.position.inSeconds % 60).toString().padLeft(2, '0')} / '
              '${audioPlayerProvider.duration.inMinutes}:${(audioPlayerProvider.duration.inSeconds % 60).toString().padLeft(2, '0')}'),
          const SizedBox(height: 30),
          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  // Handle previous song action
                },
              ),
              IconButton(
                icon: Icon(audioPlayerProvider.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: audioPlayerProvider.isPlaying
                    ? audioPlayerProvider.pause
                    : () => audioPlayerProvider.play(audio.url),
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  // Handle next song action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
