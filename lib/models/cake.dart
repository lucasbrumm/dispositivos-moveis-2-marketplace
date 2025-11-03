class Cake {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final List<String> flavors;

  Cake({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.flavors,
  });

  // Lista de bolos de exemplo
  static List<Cake> getSampleCakes() {
    return [
      Cake(
        id: '1',
        name: 'Bolo de Chocolate',
        description: 'Delicioso bolo de chocolate com cobertura de ganache',
        price: 45.90,
        image: '🍫',
        category: 'Chocolate',
        flavors: ['Chocolate', 'Chocolate Belga', 'Chocolate Branco'],
      ),
      Cake(
        id: '2',
        name: 'Bolo de Morango',
        description: 'Bolo fofo com morangos frescos e chantilly',
        price: 52.90,
        image: '🍓',
        category: 'Frutas',
        flavors: ['Morango', 'Chantilly'],
      ),
      Cake(
        id: '3',
        name: 'Bolo Red Velvet',
        description: 'Clássico bolo red velvet com cream cheese',
        price: 65.90,
        image: '❤️',
        category: 'Especiais',
        flavors: ['Red Velvet', 'Cream Cheese'],
      ),
      Cake(
        id: '4',
        name: 'Bolo de Cenoura',
        description: 'Tradicional bolo de cenoura com cobertura de chocolate',
        price: 38.90,
        image: '🥕',
        category: 'Tradicionais',
        flavors: ['Cenoura', 'Chocolate'],
      ),
      Cake(
        id: '5',
        name: 'Bolo de Limão',
        description: 'Refrescante bolo de limão siciliano',
        price: 42.90,
        image: '🍋',
        category: 'Frutas',
        flavors: ['Limão', 'Limão Siciliano'],
      ),
      Cake(
        id: '6',
        name: 'Bolo Prestígio',
        description: 'Bolo de chocolate com coco e cobertura de chocolate',
        price: 55.90,
        image: '🥥',
        category: 'Especiais',
        flavors: ['Chocolate', 'Coco'],
      ),
      Cake(
        id: '7',
        name: 'Bolo de Baunilha',
        description: 'Clássico bolo de baunilha com cobertura de buttercream',
        price: 40.90,
        image: '🍰',
        category: 'Tradicionais',
        flavors: ['Baunilha', 'Buttercream'],
      ),
      Cake(
        id: '8',
        name: 'Bolo Floresta Negra',
        description: 'Bolo de chocolate com cerejas e chantilly',
        price: 68.90,
        image: '🍒',
        category: 'Especiais',
        flavors: ['Chocolate', 'Cereja', 'Chantilly'],
      ),
    ];
  }
}

