import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  late Database db;

  NewsDbProvider() {
    init();
  }

  @override
  Future<List<int>?> fetchTopIds() async {
    return null;
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items1.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute('''
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER, 
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER 
            )
        ''');
      },
    );
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      columns: null,
      where: "id=?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      // print(ItemModel.fromDB(maps.first));
      return ItemModel.fromDB(maps.first);
    }
    return null;
  }

  @override
  Future<int> addItem(ItemModel? item) {
    return db.insert(
      'Items',
      item!.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<int?> clear() async {
    return await db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();