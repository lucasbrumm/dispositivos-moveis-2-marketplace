import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../database/database_helper.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar todos os pedidos do banco de dados
  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await DatabaseHelper.instance.readAllOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar pedidos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Criar um novo pedido
  Future<bool> createOrder(Order order) async {
    try {
      await DatabaseHelper.instance.createOrder(order);
      await loadOrders(); // Recarregar lista
      return true;
    } catch (e) {
      _error = 'Erro ao criar pedido: $e';
      notifyListeners();
      return false;
    }
  }

  // Buscar um pedido específico pelo ID
  Future<Order?> getOrderById(String id) async {
    try {
      return await DatabaseHelper.instance.readOrder(id);
    } catch (e) {
      _error = 'Erro ao buscar pedido: $e';
      notifyListeners();
      return null;
    }
  }

  // Deletar um pedido
  Future<void> deleteOrder(String id) async {
    try {
      await DatabaseHelper.instance.deleteOrder(id);
      await loadOrders(); // Recarregar lista
    } catch (e) {
      _error = 'Erro ao deletar pedido: $e';
      notifyListeners();
    }
  }

  // Obter total de pedidos
  Future<int> getOrdersCount() async {
    try {
      return await DatabaseHelper.instance.getOrdersCount();
    } catch (e) {
      return 0;
    }
  }

  // Obter receita total
  Future<double> getTotalRevenue() async {
    try {
      return await DatabaseHelper.instance.getTotalRevenue();
    } catch (e) {
      return 0.0;
    }
  }
}

