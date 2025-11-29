import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cake.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class CakeDetailScreen extends StatelessWidget {
  final Cake cake;

  const CakeDetailScreen({super.key, required this.cake});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(cake.id);
    final quantity = cartProvider.getQuantity(cake.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(cake.name),
        backgroundColor: Colors.pink[300],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem/Emoji do bolo
            Hero(
              tag: 'cake_${cake.id}',
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink[100]!,
                      Colors.purple[100]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    cake.image,
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome e Categoria
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cake.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cake.category,
                          style: TextStyle(
                            color: Colors.pink[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Preço
                  Text(
                    'R\$ ${cake.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Descrição
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cake.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sabores
                  Text(
                    'Sabores',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cake.flavors.map((flavor) {
                      return Chip(
                        label: Text(flavor),
                        backgroundColor: Colors.purple[50],
                        labelStyle: TextStyle(
                          color: Colors.purple[800],
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Controle de quantidade se já estiver no carrinho
                  if (isInCart) ...[
                    Text(
                      'Quantidade no carrinho',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            if (quantity > 1) {
                              cartProvider.updateQuantity(
                                  cake.id, quantity - 1);
                            } else {
                              cartProvider.removeItem(cake.id);
                            }
                          },
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton.filled(
                          onPressed: () {
                            cartProvider.updateQuantity(cake.id, quantity + 1);
                          },
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.pink[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                if (!isInCart) {
                  cartProvider.addItem(cake);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${cake.name} adicionado ao carrinho!'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'Ver Carrinho',
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(isInCart ? Icons.check : Icons.add_shopping_cart),
              label: Text(
                isInCart ? 'Já está no carrinho' : 'Adicionar ao Carrinho',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart ? Colors.green : Colors.pink[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

