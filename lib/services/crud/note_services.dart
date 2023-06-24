import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exception.dart';

class NotesService {
  Database? _db;

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updateCount = await db
        .update(noteTable, {textColumn: text, isSyncedwithCloudColumn: 0});
    if (updateCount == 0) {
      throw CouldNotUpdate();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final note =
        await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);
    if (note.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(note.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount =
        await db.delete(noteTable, where: "id = ?", whereArgs: [id]);
    if (deleteCount == 0) {
      throw CouldNotDeleteNote;
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    //make sure owner exist in the database with current id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw UserNotFound();
    }
    const text = '';
    //create note
    final noteID = await db.insert(noteTable,
        {userIdColumn: owner.id, textColumn: text, isSyncedwithCloudColumn: 1});
    final note = DatabaseNote(
      id: noteID,
      userId: owner.id,
      text: text,
      isSyncedwithCloud: true,
    );
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: "email = ?", whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      throw UserNotFound;
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db
        .query(userTable, where: "email = ?", whereArgs: [email.toLowerCase()]);

    if (result.isNotEmpty) {
      throw UserAlreadyExist();
    }

    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    // ignore: unrelated_type_equality_checks
    if (deleteCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenedException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenedException;
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenedException();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbpath = join(docspath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;
      //create user table

      await db.execute(createUserTable);
      //create note table
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id , email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedwithCloud;

  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSyncedwithCloud});
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedwithCloud =
            (map[isSyncedwithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userID = $userId , isSyncedwithCloud = $isSyncedwithCloud, text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedwithCloudColumn = "is_synced_with_cloud";
const createUserTable = '''
  CREATE TABLE IF NOT EXIST "user" (
	"id"	INTEGER NOT NULL,
	"email"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
      ''';
const createNoteTable = '''
CREATE TABLE IF NOT EXIST "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);
    ''';
