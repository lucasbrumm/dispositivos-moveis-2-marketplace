import 'dart:convert';

class Order {
  final String id;
  final String customerName;
  final double total;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.customerName,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  // Converter para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_name': customerName,
      'total': total,
      'created_at': createdAt.toIso8601String(),
      'items_json': jsonEncode(items.map((item) => item.toMap()).toList()),
    };
  }

  // Criar Order a partir de Map (para ler do banco)
  factory Order.fromMap(Map<String, dynamic> map) {
    final itemsList = jsonDecode(map['items_json']) as List;
    return Order(
      id: map['id'] as String,
      customerName: map['customer_name'] as String,
      total: map['total'] as double,
      createdAt: DateTime.parse(map['created_at'] as String),
      items: itemsList.map((item) => OrderItem.fromMap(item)).toList(),
    );
  }

  // Formatar data para exibição
  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$minute';
  }
}

class OrderItem {
  final String cakeId;
  final String cakeName;
  final double price;
  final int quantity;
  final String cakeImage;

  OrderItem({
    required this.cakeId,
    required this.cakeName,
    required this.price,
    required this.quantity,
    required this.cakeImage,
  });

  double get totalPrice => price * quantity;

  // Converter para Map
  Map<String, dynamic> toMap() {
    return {
      'cake_id': cakeId,
      'cake_name': cakeName,
      'price': price,
      'quantity': quantity,
      'cake_image': cakeImage,
    };
  }

  // Criar OrderItem a partir de Map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      cakeId: map['cake_id'] as String,
      cakeName: map['cake_name'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      cakeImage: map['cake_image'] as String,
    );
  }
}

