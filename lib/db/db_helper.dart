import 'dart:developer';

import 'package:mynotes/model/model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE DATA(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     description TEXT,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'db-notes.db',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  static Future<int> createNotes(NotesResult data) async {
    final db = await SqlHelper.db();

    final id = await db.insert(
      'data',
      data.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await SqlHelper.db();

    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleNotes(int id) async {
    final db = await SqlHelper.db();

    return db.query(
      'data',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
  }

  static Future<int> updateNotes(NotesResult data, int id) async {
    final db = await SqlHelper.db();

    final result = await db.update(
      'data',
      data.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteNotes(int id) async {
    final db = await SqlHelper.db();

    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log('Error -> $e');
    }
  }
}
