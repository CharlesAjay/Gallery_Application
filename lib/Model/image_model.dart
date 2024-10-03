class ImageModel {
  final String imageUrl;
  final int likes;
  final int views;
  final int imageHeight;

  ImageModel({required this.imageUrl, required this.likes, required this.views, required this.imageHeight});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['webformatURL'],
      likes: json['likes'],
      views: json['views'],
      imageHeight: json['webformatHeight']
    );
  }
}
