import 'package:flutter/foundation.dart';
import '../models/cake.dart';
import '../database/cake_repository_factory.dart';

class CakeProvider with ChangeNotifier {
  List<Cake> _cakes = [];
  bool _isLoading = false;
  String? _error;

  List<Cake> get cakes => _cakes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar todos os bolos do banco de dados
  Future<void> loadCakes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cakes = await CakeRepositoryFactory.instance.readAllCakes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar bolos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Buscar bolos por categoria
  Future<void> loadCakesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cakes = await CakeRepositoryFactory.instance.readCakesByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar bolos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Buscar um bolo específico pelo ID
  Future<Cake?> getCakeById(String id) async {
    try {
      return await CakeRepositoryFactory.instance.readCake(id);
    } catch (e) {
      _error = 'Erro ao buscar bolo: $e';
      notifyListeners();
      return null;
    }
  }

  // Adicionar um novo bolo
  Future<void> addCake(Cake cake) async {
    try {
      await CakeRepositoryFactory.instance.createCake(cake);
      await loadCakes(); // Recarregar lista
    } catch (e) {
      _error = 'Erro ao adicionar bolo: $e';
      notifyListeners();
    }
  }

  // Atualizar um bolo
  Future<void> updateCake(Cake cake) async {
    try {
      await CakeRepositoryFactory.instance.updateCake(cake);
      await loadCakes(); // Recarregar lista
    } catch (e) {
      _error = 'Erro ao atualizar bolo: $e';
      notifyListeners();
    }
  }

  // Deletar um bolo
  Future<void> deleteCake(String id) async {
    try {
      await CakeRepositoryFactory.instance.deleteCake(id);
      await loadCakes(); // Recarregar lista
    } catch (e) {
      _error = 'Erro ao deletar bolo: $e';
      notifyListeners();
    }
  }

  // Reset do banco (útil para desenvolvimento)
  Future<void> resetDatabase() async {
    try {
      await CakeRepositoryFactory.instance.resetDatabase();
      await loadCakes(); // Recarregar lista
    } catch (e) {
      _error = 'Erro ao resetar banco: $e';
      notifyListeners();
    }
  }

  // Obter categorias únicas
  List<String> get categories {
    return _cakes.map((cake) => cake.category).toSet().toList()..sort();
  }
}

