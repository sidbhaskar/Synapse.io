import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), '.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {},
    );
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    final db = await database;
    try {
      return await db.rawQuery(query);
    } catch (e) {
      return [];
    }
  }
}
