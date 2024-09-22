class ShortVideo {
  final String id;
  final String title;
  final String description;
  final String category;
  late final bool isFavorite;
  final String fileUrl;

  ShortVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isFavorite,
    required this.fileUrl,
  });


  factory ShortVideo.fromJson(Map<String, dynamic> json) {
    return ShortVideo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      isFavorite: json['isFavorite'] as bool,
      fileUrl: json['fileUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isFavorite': isFavorite,
      'fileUrl': fileUrl,
    };
  }
}
