import 'dart:convert';
import 'package:http/http.dart' as http;

class BooksService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  static const String _apiKey = 'AIzaSyA741Q5YSYIOPyx32OJql1cAS1BUBhRgW8';

  Future<List<dynamic>> searchBooks(String searchTerm) async {
    final response =
        await http.get(Uri.parse('$_baseUrl?q=$searchTerm&key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'] ?? [];
    } else {
      throw Exception('Falha ao buscar livros: ${response.statusCode}');
    }
  }
}
