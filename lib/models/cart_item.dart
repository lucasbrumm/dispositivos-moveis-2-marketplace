import 'cake.dart';

class CartItem {
  final Cake cake;
  int quantity;

  CartItem({
    required this.cake,
    this.quantity = 1,
  });

  double get totalPrice => cake.price * quantity;
}

