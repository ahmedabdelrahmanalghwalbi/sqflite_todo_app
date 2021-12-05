import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql/models/note_model.dart';

class NotesCollection {
  static final NotesCollection instance = NotesCollection._init();
  static Database? _database;
  NotesCollection._init();

  //get database method
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // in onCreate i path my database schema
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    await db.execute('''
    CREATE TABLE $tableName(
      ${NotesFields.id} $idType,
      ${NotesFields.title} $textType,
      ${NotesFields.description} $textType,
      ${NotesFields.number} $integerType,
      ${NotesFields.isImportant} $boolType,
      ${NotesFields.createdTime} $textType
    )
    ''');
  }

  Future<Note> insert(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableName,
        columns: NotesFields.values,
        where: '${NotesFields.id}=?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('this id => $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesFields.createdTime} ASC';
    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((note) => Note.fromJson(note)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(tableName, note.toJson(),
        where: '${NotesFields.id}=?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db
        .delete(tableName, where: '${NotesFields.id}=?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
