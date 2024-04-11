import 'package:flutter/material.dart';
import 'package:app_livros/books_service.dart';
import 'package:app_livros/database_helper.dart';

class BookListScreen extends StatelessWidget {
  final List<dynamic>? books;
  final BooksService booksService = BooksService();

  BookListScreen({Key? key, this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Livros'),
      ),
      body: _buildBookList(context),
    );
  }

  Widget _buildBookList(BuildContext context) {
    if (books == null || books!.isEmpty) {
      return Center(
        child: Text('Nenhum livro encontrado.'),
      );
    }

    return ListView.builder(
      itemCount: books!.length,
      itemBuilder: (context, index) {
        return _buildBookItem(context, books![index]);
      },
    );
  }

  Widget _buildBookItem(BuildContext context, dynamic book) {
    if (book == null || book['volumeInfo'] == null) {
      return Container(); // Retorna um widget vazio se o livro ou volumeInfo for nulo
    }

    String title = book['volumeInfo']['title'] ?? 'Título indisponível';
    String author =
        book['volumeInfo']['authors']?.join(', ') ?? 'Autor desconhecido';
    String? thumbnailUrl;

    // Verifica se 'imageLinks' está presente e não é nulo
    if (book['volumeInfo']['imageLinks'] != null) {
      thumbnailUrl = book['volumeInfo']['imageLinks']['thumbnail'];
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 120,
              child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                  ? Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(Icons.book, size: 40),
                    ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    author,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addToReadingList(context, book);
                    },
                    child: Text('Adicionar à Lista de Leitura'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToReadingList(BuildContext context, dynamic book) async {
    Map<String, dynamic> bookData = {
      'title': book['volumeInfo']['title'],
      'author':
          book['volumeInfo']['authors']?.join(', ') ?? 'Autor desconhecido',
      'thumbnailUrl': book['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
      'isInReadingList': 1, // Indica que está na lista de leitura
    };

    final dbHelper = DatabaseHelper();
    int result = await dbHelper.insertBook(bookData);

    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livro adicionado à lista de leitura.')),
      );
      // Atualiza a lista de leitura após adicionar o livro
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao adicionar o livro à lista de leitura.'),
        ),
      );
    }
  }
}
