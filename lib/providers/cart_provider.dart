import 'package:flutter/foundation.dart';
import '../models/cake.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(Cake cake) {
    final existingIndex = _items.indexWhere((item) => item.cake.id == cake.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(cake: cake));
    }
    
    notifyListeners();
  }

  void removeItem(String cakeId) {
    _items.removeWhere((item) => item.cake.id == cakeId);
    notifyListeners();
  }

  void updateQuantity(String cakeId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cakeId);
      return;
    }

    final index = _items.indexWhere((item) => item.cake.id == cakeId);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String cakeId) {
    return _items.any((item) => item.cake.id == cakeId);
  }

  int getQuantity(String cakeId) {
    final item = _items.firstWhere(
      (item) => item.cake.id == cakeId,
      orElse: () => CartItem(cake: Cake(
        id: '',
        name: '',
        description: '',
        price: 0,
        image: '',
        category: '',
        flavors: [],
      ), quantity: 0),
    );
    return item.quantity;
  }
}

