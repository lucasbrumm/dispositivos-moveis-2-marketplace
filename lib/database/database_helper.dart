import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cake.dart';
import 'migrations.dart';
import 'cake_repository.dart';

class DatabaseHelper implements CakeRepository {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Versão atual do banco de dados
  static const int _databaseVersion = 1;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('marketplace.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    debugPrint('📁 Banco de dados localizado em: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    debugPrint('🆕 Criando novo banco de dados v$version');
    await DatabaseMigrations.migrationV1(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('⬆️ Atualizando banco de dados de v$oldVersion para v$newVersion');
    await DatabaseMigrations.runMigrations(db, oldVersion, newVersion);
  }

  // CRUD Operations para Cakes

  // Criar um novo bolo
  @override
  Future<Cake> createCake(Cake cake) async {
    final db = await database;
    await db.insert(
      'cakes',
      cake.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return cake;
  }

  // Ler um bolo pelo ID
  @override
  Future<Cake?> readCake(String id) async {
    final db = await database;
    final maps = await db.query(
      'cakes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Cake.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Ler todos os bolos
  @override
  Future<List<Cake>> readAllCakes() async {
    final db = await database;
    final result = await db.query('cakes', orderBy: 'name ASC');
    return result.map((map) => Cake.fromMap(map)).toList();
  }

  // Buscar bolos por categoria
  @override
  Future<List<Cake>> readCakesByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'cakes',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    return result.map((map) => Cake.fromMap(map)).toList();
  }

  // Atualizar um bolo
  @override
  Future<int> updateCake(Cake cake) async {
    final db = await database;
    return db.update(
      'cakes',
      cake.toMap(),
      where: 'id = ?',
      whereArgs: [cake.id],
    );
  }

  // Deletar um bolo
  @override
  Future<int> deleteCake(String id) async {
    final db = await database;
    return await db.delete(
      'cakes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Deletar todos os bolos
  @override
  Future<int> deleteAllCakes() async {
    final db = await database;
    return await db.delete('cakes');
  }

  // Fechar o banco de dados
  @override
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Reset do banco (útil para desenvolvimento/testes)
  @override
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'marketplace.db');
    
    await deleteDatabase(path);
    _database = null;
    
    // Reinicializar o banco com dados iniciais
    await database;
  }
}

