import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/image_model.dart';

class ImageService {
  final String apiKey = '46305189-98547dbab02a08cb768ebbd7c';

  final int _perPage = 30;

  Future<List<ImageModel>> fetchImages(int currentPage) async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$apiKey&per_page=$_perPage&page=$currentPage'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['hits'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList();
    } else {
      throw Exception('Failed to load images'); // Handle API error
    }
  }
}
