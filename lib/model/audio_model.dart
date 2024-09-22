// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
//
// class Audio {
//   final String title;
//   final String subtitle;
//   final String category;
//   final String playlist;
//   final String url;
//   final String thumbnail;
//   bool isFavorite;
//
//   Audio({
//     required this.title,
//     required this.subtitle,
//     required this.category,
//     required this.playlist,
//     required this.url,
//     required this.thumbnail,
//     this.isFavorite = false,
//   });
//
//   // Factory method to create an Audio object from JSON
//   factory Audio.fromJson(Map<String, dynamic> json) {
//     return Audio(
//       title: json['title'],
//       subtitle: json['subtitle'],
//       category: json['category'],
//       playlist: json['playlist'],
//       url: json['url'],
//       thumbnail: json['thumbnail'],
//       isFavorite: json['isFavorite'] ?? false,
//     );
//   }
//
//   // Method to toggle the favorite status
//   void toggleFavorite() {
//     isFavorite = !isFavorite;
//   }
//
//   // Method to download audio file to storage
//   Future<String?> downloadAudio() async {
//     try {
//       // Get the directory to save the audio file
//       final Directory appDir = await getApplicationDocumentsDirectory();
//       final String filePath = '${appDir.path}/$title.mp3';
//
//       // Download the audio using Dio
//       Dio dio = Dio();
//       await dio.download(url, filePath);
//
//       return filePath; // Return the file path if download is successful
//     } catch (e) {
//       print('Download failed: $e');
//       return null;
//     }
//   }
// }

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Audio {
  final String title;
  final String subtitle;
  final String category;
  final String playlist;
  final String url;
  final String thumbnail;
  bool isFavorite;

  Audio({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.playlist,
    required this.url,
    required this.thumbnail,
    this.isFavorite = false,
  });

  // Factory method to create an Audio object from JSON
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      playlist: json['playlist'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Method to toggle the favorite status
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  // Method to download audio file to storage
  Future<String?> downloadAudio() async {
    try {
      // Get the directory to save the audio file
      final Directory appDir = await getApplicationDocumentsDirectory();
      // Sanitize the title to create a valid filename
      final String safeTitle = title.replaceAll(RegExp(r'[\/:*?"<>|]'), '_');
      final String filePath = '${appDir.path}/$safeTitle.mp3';

      // Download the audio using Dio
      Dio dio = Dio();
      await dio.download(url, filePath);

      return filePath; // Return the file path if download is successful
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }
}
