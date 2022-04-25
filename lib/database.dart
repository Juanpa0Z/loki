import 'package:loki/models/sound.dart';
import 'package:sqflite/sqflite.dart';


class DbHelper {
  static Database? database;

  static const String _createTable = '''
      CREATE TABLE Sound(
        id INTEGER PRIMARY KEY,
        name TEXT,
        media BLOB,
        image BLOB
      );
  ''';
  static const String _querySounds = '''
    SELECT * FROM Sound ORDER BY id DESC
  ''';
  static const  String _deleteSoundById = '''
   DELETE FROM Sound WHERE id = ?
  ''';
  static initialized() async {
    DbHelper.database =
        await openDatabase('app.db', version: 1, onCreate: (db, version) async {
      await db.execute(_createTable);
      print('db and table was created!');
    }, onOpen: (db) {
      print('db is opened!');
    });
  }

  static Future<List<Sound>> getSounds()async{
    var list = await DbHelper.database?.rawQuery(_querySounds);
    return list!.map((map) =>  Sound.fromMap(map)).toList();
  }
  static Future<void> deleteSoundById(int id)async{
    await DbHelper.database?.rawDelete(_deleteSoundById,[id]);
  }
}
