import 'dart:async';

import 'package:eval/models/Car.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final _databaseName = "card.db";
  static final _databaseVersion = 1;
  static final table = 'cars_table';
  static final columnId = "id";
  static final columnName = "name";
  static final columnMiles = "miles";

  DatabaseHelper._privateCOnstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateCOnstructor();
  static Database? _database;

  Future<Database?> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
  }

  _initDatabase()async {
  String path = join(await getDatabasesPath(), _databaseName);
  return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }


  Future<void> _onCreate(Database db, int version)async{
      await db.execute(
        '''
        CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnMiles INTEGER NOT NULL 
        )
        '''
      );
  }

  Future<int>update(Car car)async{
    Database? db = await instance.database;
    int id =  car.toMap()["id"];
    return await db!.update(table, car.toMap(), where: '$columnId = ?', whereArgs: [id] );
  }


  Future<int>insert(Car car)async{
    Database? db = await instance.database;
   return await db!.insert(table, {"name":car.name, "miles":car.miles, });
  }

  Future<int>delete(int id)async{
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String,dynamic>>>queryRows(name)async{
    Database? db = await instance.database;
    return await db!.query(table, where: "$columnName LIKE '%$name%'");

  }

  Future<List<Map<String,dynamic>>>queryAllRows()async{
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<int?>queryRowCount(int id)async{
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }
}
















