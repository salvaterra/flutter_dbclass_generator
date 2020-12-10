import 'package:capitaw_ui/data/db/db.dart';
import 'package:flutter/material.dart';

abstract class BaseModel {
  int id;
  Map<String, dynamic> toJson();
  BaseModel fromJson(Map<String, dynamic> json);
}

class Dao<T extends BaseModel> {
  //Future<Database> db = DBProvider.db;
  final db = DBProvider.db.database;
  final String tableName;
  final BaseModel instance;

  Dao(this.instance, {@required this.tableName});

  BaseModel fromJson(dynamic map) => instance.fromJson(map);

  Future<T> find(int id) async {
    final dbClient = await db;
    var map = await dbClient.query(tableName, where: "id = ?", whereArgs: [id]);
    return fromJson(map.first) as T;
  }

  Future<List<T>> getAll() async {
    var dbClient = await db;
    var map = await dbClient.query(tableName);
    return List.generate(map.length, (i) => fromJson(map[i]) as T);
  }

  Future<int> insert(BaseModel model) async {
    var dbClient = await db;
    return await dbClient.insert(tableName, model.toJson());
  }

  Future<void> update(BaseModel model) async {
    final dbClient = await db;
    await dbClient.update(
      tableName,
      model.toJson(),
      where: "id = ?",
      whereArgs: [model.id],
    );
  }

  Future<void> delete(BaseModel model) async {
    final dbClient = await db;
    await dbClient.delete(tableName, where: "id = ?", whereArgs: [model.id]);
  }

  Future<void> deleteById(int id) async {
    final dbClient = await db;
    await dbClient.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
