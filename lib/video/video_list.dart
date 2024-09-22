import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../model/short_video_model.dart';

class ShortVideoList extends StatefulWidget {
  const ShortVideoList({super.key});

  @override
  State<ShortVideoList> createState() => _ShortVideoListState();
}

class _ShortVideoListState extends State<ShortVideoList> {
  late List<VideoPlayerController> _controllers;
  late List<ShortVideo> _videos;
  Future<void>? _initializeVideoPlayerFutures;

  bool _showControls = true;
  Timer? _hideTimer;

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await _fetchVideoData();
      setState(() {
        _videos = videos;
        _controllers = _videos.map((video) {
          final controller = VideoPlayerController.network(video.fileUrl);
          controller.setLooping(true);
          controller.initialize(); // Preload each video during initialization
          return controller;
        }).toList();

        // Ensure _initializeVideoPlayerFutures is set after controllers are created
        _initializeVideoPlayerFutures = Future.wait(
          _controllers.map((controller) => controller.initialize()).toList(),
        );
      });
    } catch (e) {
      print('Error loading videos: $e');
      _showErrorSnackbar('Failed to load videos.');
    }
  }

  Future<List<ShortVideo>> _fetchVideoData() async {
    final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/yehtutoo2022/parchoke/main/short_videos.json',
    ));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ShortVideo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load video data');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Short Videos'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _videos.isNotEmpty) {
            return PageView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                final controller = _controllers[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                    _resetHideTimer();
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: controller.value.isInitialized
                              ? VideoPlayer(controller)
                              : Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Positioned video title
                      Positioned(
                        top: 20, // Positioning the title near the top
                        left: 10,
                        right: 10,
                        child: Text(
                          _videos[index].title,
                          //the pageview.builder generate dynamically as you scroll,
                          //index provided by pageview.builder is used to determine which page (video) is being rendered.
                          //index to access relevant controller, video title, or metadata from respective lists

                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),

                      // Positioned video subtitle
                      Positioned(
                        top: 50, // Positioning the subtitle below the title
                        left: 10,
                        right: 10,
                        child: Text(
                          _videos[index].description,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),

                      if (_showControls)
                        Center(
                          child: IconButton(
                            icon: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.white,
                              size: 70.0,
                            ),
                            onPressed: () {
                              setState(() {
                                if (controller.value.isPlaying) {
                                  controller.pause();
                                } else {
                                  controller.play();
                                }
                              });
                            },
                          ),
                        ),

                      Positioned(
                        bottom: 20,
                        left: 10,
                        right: 10,
                        child: VideoProgressIndicator(
                          controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            backgroundColor: Colors.grey,
                            bufferedColor: Colors.white,
                            playedColor: Colors.blue,
                          ),
                        ),
                      ),

                      if (_showControls)
                        Positioned(
                          bottom: 40,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              Text(
                                _formatDuration(controller.value.position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.red,
                                  inactiveColor: Colors.grey,
                                  value: controller.value.position.inSeconds.toDouble(),
                                  min: 0.0,
                                  max: controller.value.duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    controller.seekTo(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ),
                              Text(
                                _formatDuration(controller.value.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                setState(() {
                  for (var i = 0; i < _controllers.length; i++) {
                    if (i == index) {
                      // Restart the video from the beginning and play it
                      // Restart the video from the beginning with a slight delay
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _controllers[i].seekTo(Duration.zero).then((_) {
                          _controllers[i].play();
                        });
                      }
                      );
                    } else {
                      // Pause other videos
                      _controllers[i].pause();
                    }
                  }
                });
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color> (Colors.red),
                      strokeWidth: 8.0,
                      backgroundColor: Colors.grey[200],
                    ),
                    SizedBox(height: 20,),
                    const Text(
                      'Please wait while loading short videos',
                      style: TextStyle(color: Colors.red),)
                  ],
                )
            );
          } else {
            return const Center(child: Text('No videos available.'));
          }
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? '${twoDigits(duration.inHours)}:$minutes:$seconds'
        : '$minutes:$seconds';
  }

}
