class ImageModel {
  final int id;
  final String imageUrl;
  final int views;
  final int likes;

  ImageModel({
    required this.id,
    required this.imageUrl,
    required this.views,
    required this.likes,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      imageUrl: json['webformatURL'],
      views: json['views'],
      likes: json['likes'],
    );
  }
}
