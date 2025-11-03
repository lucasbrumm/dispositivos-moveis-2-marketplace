import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cake.dart';
import '../models/order.dart';
import 'migrations.dart';
import 'cake_repository.dart';

class DatabaseHelper implements CakeRepository {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Versão atual do banco de dados
  static const int _databaseVersion = 2;

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
    // Executar todas as migrations até a versão atual
    for (int v = 1; v <= version; v++) {
      switch (v) {
        case 1:
          await DatabaseMigrations.migrationV1(db);
          break;
        case 2:
          await DatabaseMigrations.migrationV2(db);
          break;
      }
    }
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

  // ============================================
  // CRUD Operations para Orders (Pedidos)
  // ============================================

  // Criar um novo pedido
  Future<Order> createOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('✅ Pedido ${order.id} criado com sucesso');
    return order;
  }

  // Ler um pedido pelo ID
  Future<Order?> readOrder(String id) async {
    final db = await database;
    final maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Ler todos os pedidos (ordenados do mais recente para o mais antigo)
  Future<List<Order>> readAllOrders() async {
    final db = await database;
    final result = await db.query('orders', orderBy: 'created_at DESC');
    return result.map((map) => Order.fromMap(map)).toList();
  }

  // Ler pedidos de um cliente específico
  Future<List<Order>> readOrdersByCustomer(String customerName) async {
    final db = await database;
    final result = await db.query(
      'orders',
      where: 'customer_name = ?',
      whereArgs: [customerName],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Order.fromMap(map)).toList();
  }

  // Deletar um pedido
  Future<int> deleteOrder(String id) async {
    final db = await database;
    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Deletar todos os pedidos
  Future<int> deleteAllOrders() async {
    final db = await database;
    return await db.delete('orders');
  }

  // Obter total de pedidos
  Future<int> getOrdersCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM orders');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Obter valor total de todos os pedidos
  Future<double> getTotalRevenue() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(total) as total FROM orders');
    final total = result.first['total'];
    return total != null ? (total as num).toDouble() : 0.0;
  }
}

