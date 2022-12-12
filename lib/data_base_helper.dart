import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/constants.dart';

import 'info_model.dart';

class DatabaseHelper{
  // singleton(only Instance to USE)
 static final DatabaseHelper instance=DatabaseHelper._init();
  DatabaseHelper._init();
  static Database ?_database;

Future<Database>?get database async{
 if(_database !=null)return _database!;
 _database=await initDB();
 return _database!;
}
Future<Database>initDB()async{
 String path=join(await getDatabasesPath(),'InfoDatabase.db');
 // OPEN DATABASE
 return await openDatabase(path,version: 1,onCreate: _onCreate);
}
Future<void>_onCreate(Database? db,int?version)async{
 //CREATE TABLES in DB -SQL SYNTAX
 db!.execute('''
 CREATE TABLE $infoTable (
 $columnID $idType,
 $columnName $textType,
 $columnPhone $textType,
 $columnEmail $textType
 )
 ''');

}

 /// CRUD OPERATION (CREATE - READ -UPDATE - DELETE)
 Future<void>insertInfo(InfoModel info)async{
  final db =await instance.database;
  db!.insert(
   infoTable,info.toDB(),
   conflictAlgorithm: ConflictAlgorithm.replace,
  );
 }
 /// READ
 Future<List<InfoModel>>readAllInfo()async{
  final db = await instance.database;
  List<Map<String,dynamic>>data=await db!.query(infoTable);
  return data.isNotEmpty?data.map((element)=>InfoModel.fromDB(element)).toList():[];
 }

/// READ
Future<InfoModel>readOneInfo(int id)async{
 final db=await instance.database;
 List<Map<String,dynamic>>data=await db!.query(infoTable,
 where: '$columnID = ?',
 whereArgs: [id]);
 return data.isNotEmpty? InfoModel.fromDB(data.first)
     :throw Exception('Id $id is not found');
}
 /// UPDATE
 Future<void>editInfo(InfoModel info)async{
  final db=await instance.database;
  db!.update(infoTable, info.toDB(),
  where: '$columnID = ?',
  whereArgs: [info.id],);
 }
 ///DELETE
 Future<void>deleteInfo( int id)async{
  final db=await instance.database;
  db!.delete(infoTable,
  where: '$columnID = ?',
  whereArgs: [id],);
 }

}