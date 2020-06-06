class ImageModel {
  String imageUrl;

  ImageModel({this.imageUrl});

  ImageModel.fromJson(Map<String, dynamic> parsedJSON)
      : imageUrl = parsedJSON['download_url'];
}