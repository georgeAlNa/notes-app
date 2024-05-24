import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqflite {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDataBase();
      return _db;
    } else {
      return _db;
    }
  }

  initialDataBase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    Database database = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 4,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  _onCreate(Database db, int version) async {
    // await db.execute('''
    // CREATE TABLE "notes" (
    //   "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    //   "note" TEXT NOT NULL
    //   )''');

    Batch batch = db.batch();
    batch.execute('''
  CREATE TABLE "notes" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "note" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "color" TEXT NOT NULL
    )''');
    await batch.commit();
    print('on create');
  }

  _onUpgrade(Database db, int oldVersion, int newVrsion) async {
    print('on upgrade');
    await db.execute("ALTER TABLE notes ADD COLUMN title TEXT");
  }

//Select + insert + update + delete functions to edit database
  readData(String sql) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql);
    return response;
  }

  deleteLocalDataBase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    deleteDatabase(path);
  }


  

//Select + insert + update + delete by package without sql instructions

  read(String table) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.query(table);
    return response;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? myDb = await db;
    int response = await myDb!.insert(table, values);
    return response;
  }

  update(String table, Map<String, Object?> values, String? myWhere) async {
    Database? myDb = await db;
    int response = await myDb!.update(table, values, where: myWhere);
    return response;
  }

  delete(String table, String? myWhere) async {
    Database? myDb = await db;
    int response = await myDb!.delete(table, where: myWhere);
    return response;
  }
}
