import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/image_model.dart';

class ImageService {
  final String apiKey = '46305189-98547dbab02a08cb768ebbd7c';
  int _currentPage = 1;
  final int _perPage = 30;

  Future<List<ImageModel>> fetchImages() async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$apiKey&per_page=$_perPage&page=$_currentPage'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _currentPage++;
      return (data['hits'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
