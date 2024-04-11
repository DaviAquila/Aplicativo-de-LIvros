import 'package:flutter/material.dart';
import 'package:app_livros/books_service.dart';
import 'package:app_livros/book_list_screen.dart';
import 'package:app_livros/Reading_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BooksService booksService = BooksService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Lista de Leitura',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(booksService: booksService),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final BooksService booksService;
  final TextEditingController _searchController = TextEditingController();

  HomeScreen({Key? key, required this.booksService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Lista de Leitura'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _navigateToBookListScreen(context, _searchController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo à Minha Lista de Leitura!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar livros...',
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _navigateToBookListScreen(context, _searchController.text);
              },
              child: Text('Buscar Livros'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _navigateToReadingListScreen(context);
              },
              child: Text('Ver Lista de Leitura'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBookListScreen(
      BuildContext context, String searchTerm) async {
    try {
      final books = await booksService.searchBooks(searchTerm);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookListScreen(books: books)),
      );
    } catch (e) {
      print('Erro ao buscar livros: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar livros.')),
      );
    }
  }

  void _navigateToReadingListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadingListScreen()),
    );
  }
}
