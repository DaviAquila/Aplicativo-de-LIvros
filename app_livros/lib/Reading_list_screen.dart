import 'package:flutter/material.dart';
import 'package:app_livros/database_helper.dart';

class ReadingListScreen extends StatefulWidget {
  @override
  _ReadingListScreenState createState() => _ReadingListScreenState();
}

class _ReadingListScreenState extends State<ReadingListScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> readingList = [];

  @override
  void initState() {
    super.initState();
    _refreshReadingList();
  }

  Future<void> _refreshReadingList() async {
    final list = await dbHelper.getReadingList();
    setState(() {
      readingList = list;
    });
  }

  Future<void> _removeBookFromReadingList(Map<String, dynamic> book) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.removeBookFromReadingList(book);
    await _refreshReadingList(); // Atualizar a lista após a remoção
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Lista de Leitura'),
      ),
      body: _buildReadingList(),
    );
  }

  Widget _buildReadingList() {
    if (readingList.isEmpty) {
      return Center(
        child: Text('Nenhum livro adicionado à lista de leitura.'),
      );
    }

    return ListView.builder(
      itemCount: readingList.length,
      itemBuilder: (context, index) {
        return _buildReadingListItem(readingList[index]);
      },
    );
  }

  Widget _buildReadingListItem(Map<String, dynamic> book) {
    String title = book['title'] ?? 'Título indisponível';
    String author = book['author'] ?? 'Autor desconhecido';
    String thumbnailUrl = book['thumbnailUrl'];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: _buildThumbnailWidget(thumbnailUrl),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(author),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                // Adicione ação para mostrar mais informações sobre o livro
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeBookFromReadingList(book);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailWidget(String? thumbnailUrl) {
    if (thumbnailUrl != null) {
      if (thumbnailUrl.isNotEmpty) {
        return Image.network(
          thumbnailUrl,
          width: 80,
          height: 120,
          fit: BoxFit.cover,
        );
      }
    }

    // Caso thumbnailUrl seja null ou vazio, retorna o ícone padrão de livro
    return Container(
      width: 80,
      height: 120,
      color: Colors.grey[300],
      child: Icon(Icons.book, size: 40, color: Colors.grey[600]),
    );
  }
}
