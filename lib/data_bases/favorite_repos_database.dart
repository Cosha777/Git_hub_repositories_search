import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RepoDatabase {
  static final RepoDatabase instance = RepoDatabase._init();
  static Database? _database;

  RepoDatabase._init();

  Future<Database> get database async => _database ??= await _initDB(DBConst.dBName);

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, filePath);
    return await openDatabase(path, version: DBConst.version, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DBConst.table);
  }
}

abstract class DBConst {
  static const String dBName = 'repos.db';
  static const int version = 1;
  static const String tableName = 'FavoriteRepos';
  static const String id = 'id';
  static const String repoName = 'repoName';
  static const String isFavorite = 'isFavorite';
  static String table =
      """CREATE TABLE IF NOT EXISTS $tableName ($id INTEGER UNIQUE, $repoName TEXT, $isFavorite BOOLEAN);""";
}
