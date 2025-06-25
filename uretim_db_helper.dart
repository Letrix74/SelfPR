import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/uretim_model.dart';

class UretimDBHelper {
  static final UretimDBHelper _instance = UretimDBHelper._internal();
  factory UretimDBHelper() => _instance;
  UretimDBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'uretim.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE uretimler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            referansAdi TEXT,
            vulkanizeKodu TEXT,
            ebosKodu TEXT,
            macaSayisi INTEGER,
            uretimAdedi INTEGER,
            kayitZamani TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUretim(UretimModel model) async {
    final db = await database;
    await db.insert('uretimler', model.toMap());
  }

  Future<List<UretimModel>> getUretimler() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('uretimler');
    return maps.map((map) => UretimModel.fromMap(map)).toList();
  }

  Future<void> deleteUretim(int id) async {
    final db = await database;
    await db.delete('uretimler', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateUretim(UretimModel model) async {
    final db = await database;
    await db.update(
      'uretimler',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
