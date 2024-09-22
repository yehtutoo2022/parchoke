import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'model/audio_model.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration();
  Duration position = Duration();
  Audio? currentAudio;

  // void init(String audioUrl) {
  //   play(audioUrl);
  //
  //   audioPlayer.onDurationChanged.listen((d) {
  //     duration = d;
  //     notifyListeners();
  //   });
  //
  //   audioPlayer.onPositionChanged.listen((p) {
  //     position = p;
  //     notifyListeners();
  //   });
  // }

  void init(Audio audio) {
    currentAudio = audio;
    play(audio.url);

    audioPlayer.onDurationChanged.listen((d) {
      duration = d;
      notifyListeners();
    });

    audioPlayer.onPositionChanged.listen((p) {
      position = p;
      notifyListeners();
    });
  }

  Future<void> play(String audioUrl) async {
    await audioPlayer.play(UrlSource(audioUrl));
    isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    await audioPlayer.pause();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    notifyListeners();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
