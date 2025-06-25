import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/referans_model.dart';

class ReferansDBHelper {
  static final ReferansDBHelper _instance = ReferansDBHelper._internal();
  factory ReferansDBHelper() => _instance;
  ReferansDBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'referanslar.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE referanslar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        referansAdi TEXT NOT NULL,
        vulkanizeKodu TEXT NOT NULL,
        ebosKodu TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertReferans(ReferansModel referans) async {
    final db = await database;
    return await db.insert('referanslar', referans.toMap());
  }

  Future<List<ReferansModel>> getReferanslar({String? arama}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (arama != null && arama.isNotEmpty) {
      maps = await db.query(
        'referanslar',
        where: 'referansAdi LIKE ? OR vulkanizeKodu LIKE ? OR ebosKodu LIKE ?',
        whereArgs: ['%$arama%', '%$arama%', '%$arama%'],
      );
    } else {
      maps = await db.query('referanslar');
    }

    return maps.map((e) => ReferansModel.fromMap(e)).toList();
  }

  Future<int> updateReferans(ReferansModel referans) async {
    final db = await database;
    return await db.update(
      'referanslar',
      referans.toMap(),
      where: 'id = ?',
      whereArgs: [referans.id],
    );
  }

  Future<int> deleteReferans(int id) async {
    final db = await database;
    return await db.delete('referanslar', where: 'id = ?', whereArgs: [id]);
  }
}
