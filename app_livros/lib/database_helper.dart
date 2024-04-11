import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'reading_list.db';
  static const String _tableName = 'books';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _dbName);

    await deleteDatabase(dbPath);

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          author TEXT,
          thumbnailUrl TEXT,
          isInReadingList INTEGER DEFAULT 0
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
      },
    );
  }

  Future<int> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    return await db.insert(
      _tableName,
      {
        'title': book['title'],
        'author': book['author'],
        'thumbnailUrl': book['thumbnailUrl'],
        'isInReadingList': 1,
      },
    );
  }

  Future<int> removeBookFromReadingList(Map<String, dynamic> book) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [book['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<List<Map<String, dynamic>>> getReadingList() async {
    final db = await database;
    return await db
        .query(_tableName, where: 'isInReadingList = ?', whereArgs: [1]);
  }
}
