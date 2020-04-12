import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:userslist/model/post_users.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._();

  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Users.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Users ("
          "id TEXT,"
          "createdAt TEXT"
          ")");
    });
  }

  addPersonToDatabase(PostUsers person) async {
    final db = await database;
    var raw = await db.insert(
      "Users",
      person.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updatePerson(PostUsers postUsers) async {
    final db = await database;
    var response = await db.update("Users", postUsers.toJson(),
        where: "id = ?", whereArgs: [postUsers.id]);
    return response;
  }

  Future<PostUsers> getPersonWithId(int id) async {
    final db = await database;
    var response = await db.query("Users", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? PostUsers.fromJson(response.first) : null;
  }

  Future<List<PostUsers>> getAllPersons() async {
    final db = await database;
    var response = await db.query("Users");
    List<PostUsers> list = response.map((c) => PostUsers.fromJson(c)).toList();
    return list;
  }

  deletePersonWithId(int id) async {
    final db = await database;
    return db.delete("Users", where: "id = ?", whereArgs: [id]);
  }

  deleteAllPersons() async {
    final db = await database;
    db.delete("Users");
  }
}