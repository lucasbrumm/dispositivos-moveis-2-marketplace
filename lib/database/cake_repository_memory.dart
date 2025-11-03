import 'package:flutter/foundation.dart';
import '../models/cake.dart';
import 'cake_repository.dart';

/// Implementação em memória do repositório de bolos
/// Usada para web e outras plataformas sem SQLite
class CakeRepositoryMemory implements CakeRepository {
  static final CakeRepositoryMemory instance = CakeRepositoryMemory._init();
  
  List<Cake> _cakes = [];
  bool _initialized = false;

  CakeRepositoryMemory._init();

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      debugPrint('🌐 Inicializando repositório em memória (Web)');
      _cakes = Cake.getSampleCakes();
      _initialized = true;
      debugPrint('✅ ${_cakes.length} bolos carregados em memória');
    }
  }

  @override
  Future<List<Cake>> readAllCakes() async {
    await _ensureInitialized();
    return List.from(_cakes)..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<Cake?> readCake(String id) async {
    await _ensureInitialized();
    try {
      return _cakes.firstWhere((cake) => cake.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Cake>> readCakesByCategory(String category) async {
    await _ensureInitialized();
    return _cakes
        .where((cake) => cake.category == category)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<Cake> createCake(Cake cake) async {
    await _ensureInitialized();
    _cakes.add(cake);
    debugPrint('✅ Bolo ${cake.name} adicionado');
    return cake;
  }

  @override
  Future<int> updateCake(Cake cake) async {
    await _ensureInitialized();
    final index = _cakes.indexWhere((c) => c.id == cake.id);
    if (index != -1) {
      _cakes[index] = cake;
      debugPrint('✅ Bolo ${cake.name} atualizado');
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteCake(String id) async {
    await _ensureInitialized();
    final initialLength = _cakes.length;
    _cakes.removeWhere((cake) => cake.id == id);
    final deleted = initialLength - _cakes.length;
    if (deleted > 0) {
      debugPrint('✅ Bolo removido');
    }
    return deleted;
  }

  @override
  Future<int> deleteAllCakes() async {
    await _ensureInitialized();
    final count = _cakes.length;
    _cakes.clear();
    debugPrint('✅ Todos os bolos removidos');
    return count;
  }

  @override
  Future<void> resetDatabase() async {
    debugPrint('🔄 Resetando repositório em memória');
    _cakes.clear();
    _initialized = false;
    await _ensureInitialized();
  }

  @override
  Future<void> close() async {
    // Não há conexão para fechar em memória
  }
}

