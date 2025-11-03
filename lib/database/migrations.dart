import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../models/cake.dart';

/// Classe responsável por gerenciar as migrations do banco de dados
class DatabaseMigrations {
  
  /// Migration inicial - Versão 1
  /// Cria a tabela de bolos e insere os dados iniciais
  static Future<void> migrationV1(Database db) async {
    // Criar tabela de bolos
    await db.execute('''
      CREATE TABLE cakes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        category TEXT NOT NULL,
        flavors TEXT NOT NULL
      )
    ''');

    // Inserir dados iniciais
    await insertInitialCakes(db);
  }

  /// Insere os bolos iniciais no banco de dados
  static Future<void> insertInitialCakes(Database db) async {
    final initialCakes = Cake.getSampleCakes();
    
    for (final cake in initialCakes) {
      await db.insert(
        'cakes',
        cake.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    debugPrint('✅ ${initialCakes.length} bolos inseridos no banco de dados');
  }

  /// Migration v2 - Sistema de Pedidos
  /// Cria tabela de pedidos (orders)
  static Future<void> migrationV2(Database db) async {
    // Criar tabela de pedidos
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        customer_name TEXT NOT NULL,
        total REAL NOT NULL,
        created_at TEXT NOT NULL,
        items_json TEXT NOT NULL
      )
    ''');
    
    debugPrint('✅ Migration v2 executada: tabela de pedidos criada');
  }

  /// Exemplo de migration futura - Versão 3
  /// (Descomente quando necessário)
  /*
  static Future<void> migration_v3(Database db) async {
    // Exemplo: Criar uma nova tabela
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        customer_name TEXT NOT NULL,
        total REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        cake_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id),
        FOREIGN KEY (cake_id) REFERENCES cakes (id)
      )
    ''');
    
    print('✅ Migration v3 executada: tabelas de pedidos criadas');
  }
  */

  /// Executa todas as migrations necessárias
  static Future<void> runMigrations(Database db, int oldVersion, int newVersion) async {
    debugPrint('🔄 Executando migrations de v$oldVersion para v$newVersion');
    
    // Executar migrations sequencialmente
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      switch (version) {
        case 1:
          await migrationV1(db);
          break;
        case 2:
          await migrationV2(db);
          break;
        // case 3:
        //   await migrationV3(db);
        //   break;
        default:
          debugPrint('⚠️ Migration para versão $version não encontrada');
      }
    }
    
    debugPrint('✅ Migrations concluídas com sucesso!');
  }
}

