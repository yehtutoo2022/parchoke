// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:cached_video_player/cached_video_player.dart';
// import 'package:http/http.dart' as http;
//
// class ShortVideo {
//   final String id;
//   final String title;
//   final String description;
//   final String category;
//   late final bool isFavorite;
//   final String fileUrl;
//
//   ShortVideo({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.isFavorite,
//     required this.fileUrl,
//   });
//
//   factory ShortVideo.fromJson(Map<String, dynamic> json) {
//     return ShortVideo(
//       id: json['id'] as String,
//       title: json['title'] as String,
//       description: json['description'] as String,
//       category: json['category'] as String,
//       isFavorite: json['isFavorite'] as bool,
//       fileUrl: json['fileUrl'] as String,
//     );
//   }
// }
//
// class ShortVideoList extends StatefulWidget {
//   @override
//   _ShortVideoListState createState() => _ShortVideoListState();
// }
//
// class _ShortVideoListState extends State<ShortVideoList> {
//   List<CachedVideoPlayerController>? _controllers;
//   List<ShortVideo>? _videos;
//   Future<void>? _initializeVideoPlayerFutures;
//
//   bool _showControls = true;
//   Timer? _hideTimer;
//
//   void _resetHideTimer() {
//     _hideTimer?.cancel();
//     _hideTimer = Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _showControls = false;
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVideos();
//     _resetHideTimer();
//   }
//
//   Future<void> _loadVideos() async {
//     try {
//       final videos = await _fetchVideoData();
//       setState(() {
//         _videos = videos;
//         _controllers = _videos!.map((video) {
//           final controller = CachedVideoPlayerController.network(video.fileUrl);
//           controller.setLooping(true);
//           return controller;
//         }).toList();
//
//         _initializeVideoPlayerFutures = Future.wait(
//           _controllers!.map((controller) => controller.initialize()).toList(),
//         );
//       });
//     } catch (e) {
//       print('Error loading videos: $e');
//     }
//   }
//
//   Future<List<ShortVideo>> _fetchVideoData() async {
//     final response = await http.get(Uri.parse(
//       'https://raw.githubusercontent.com/yehtutoo2022/parchoke/main/short_videos.json',
//     ));
//
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonList = json.decode(response.body);
//       return jsonList.map((json) => ShortVideo.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load video data');
//     }
//   }
//
//   @override
//   void dispose() {
//     _controllers?.forEach((controller) {
//       controller.dispose();
//     });
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video List'),
//       ),
//       body: _videos == null
//           ? const Center(child: CircularProgressIndicator())
//           : FutureBuilder<void>(
//         future: _initializeVideoPlayerFutures,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return PageView.builder(
//               scrollDirection: Axis.vertical,
//               itemCount: _videos!.length,
//               itemBuilder: (context, index) {
//                 final controller = _controllers![index];
//                 return GestureDetector(
//                   onTap: _resetHideTimer,
//                   child: Stack(
//                     children: [
//                       Center(
//                         child: AspectRatio(
//                           aspectRatio: controller.value.aspectRatio,
//                           child: CachedVideoPlayer(controller),
//                         ),
//                       ),
//                       if (_showControls)
//                         Center(
//                           child: IconButton(
//                             icon: Icon(
//                               controller.value.isPlaying
//                                   ? Icons.pause_circle_outline
//                                   : Icons.play_circle_outline,
//                               color: Colors.white,
//                               size: 70.0,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 if (controller.value.isPlaying) {
//                                   controller.pause();
//                                 } else {
//                                   controller.play();
//                                 }
//                                 _resetHideTimer();
//                               });
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
