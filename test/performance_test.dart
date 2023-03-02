import 'package:powersync/powersync.dart';
import 'package:powersync/src/background_database.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  setupLogger();

  group('Performance Tests', () {
    late String path;

    setUp(() async {
      path = dbPath();
      await cleanDb(path: path);
    });

    tearDown(() async {
      await cleanDb(path: path);
    });

    // Manual tests
    test('Insert Performance 1', () async {
      final db = PowerSyncDatabase(
          schema: schema, path: path, sqliteSetup: testSetup, maxReaders: 3);
      await db.initialize();
      await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)');
      final timer = Stopwatch()..start();

      for (var i = 0; i < 1000; i++) {
        await db.execute('INSERT INTO data(name, email) VALUES(?, ?)',
            ['Test User', 'user@example.org']);
      }
      print("Completed sequential inserts in ${timer.elapsed}");
      expect(await db.get('SELECT count(*) as count FROM data'),
          equals({'count': 1000}));
    });

    test('Insert Performance 2', () async {
      final db = PowerSyncDatabase(
          schema: schema, path: path, sqliteSetup: testSetup, maxReaders: 3);
      await db.initialize();
      await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)');
      final timer = Stopwatch()..start();

      await db.writeTransaction((tx) async {
        for (var i = 0; i < 1000; i++) {
          await tx.execute('INSERT INTO data(name, email) VALUES(?, ?)',
              ['Test User', 'user@example.org']);
        }
      });
      print("Completed transaction inserts in ${timer.elapsed}");
      expect(await db.get('SELECT count(*) as count FROM data'),
          equals({'count': 1000}));
    });

    test('Insert Performance 3', () async {
      final db = PowerSyncDatabase(
          schema: schema, path: path, sqliteSetup: testSetup, maxReaders: 3);
      await db.initialize();
      await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)');
      final timer = Stopwatch()..start();

      final con = db.connectionFactory().openConnection(updates: db.updates)
          as SqliteConnectionImpl;
      await con.inIsolateWriteTransaction((db) async {
        for (var i = 0; i < 1000; i++) {
          db.execute('INSERT INTO data(name, email) VALUES(?, ?)',
              ['Test User', 'user@example.org']);
        }
      });

      print("Completed synchronous inserts in ${timer.elapsed}");
      expect(await db.get('SELECT count(*) as count FROM data'),
          equals({'count': 1000}));
    });

    test('Insert Performance 3b', () async {
      final db = PowerSyncDatabase(
          schema: schema, path: path, sqliteSetup: testSetup, maxReaders: 3);
      await db.initialize();
      await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)');
      final timer = Stopwatch()..start();

      final con = db.connectionFactory().openConnection(updates: db.updates)
          as SqliteConnectionImpl;
      await con.inIsolateWriteTransaction((db) async {
        var stmt = db.prepare('INSERT INTO data(name, email) VALUES(?, ?)');
        for (var i = 0; i < 1000; i++) {
          stmt.execute(['Test User', 'user@example.org']);
        }
        stmt.dispose();
      });

      print("Completed synchronous inserts prepared in ${timer.elapsed}");
      expect(await db.get('SELECT count(*) as count FROM data'),
          equals({'count': 1000}));
    });

    test('Insert Performance 4', () async {
      final db = PowerSyncDatabase(
          schema: schema, path: path, sqliteSetup: testSetup, maxReaders: 3);
      await db.initialize();
      await db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)');
      final timer = Stopwatch()..start();

      await db.writeTransaction((tx) async {
        // Not safe yet!
        List<Future> futures = [];
        for (var i = 0; i < 1000; i++) {
          var future = tx.execute('INSERT INTO data(name, email) VALUES(?, ?)',
              ['Test User', 'user@example.org']);
          futures.add(future);
        }
        await Future.wait(futures);
      });
      print("Completed pipelined inserts in ${timer.elapsed}");
      expect(await db.get('SELECT count(*) as count FROM data'),
          equals({'count': 1000}));
    });
  });
}
