import '../models/cake.dart';

/// Interface abstrata para repositório de bolos
/// Permite diferentes implementações para web, mobile, etc.
abstract class CakeRepository {
  Future<List<Cake>> readAllCakes();
  Future<Cake?> readCake(String id);
  Future<List<Cake>> readCakesByCategory(String category);
  Future<Cake> createCake(Cake cake);
  Future<int> updateCake(Cake cake);
  Future<int> deleteCake(String id);
  Future<int> deleteAllCakes();
  Future<void> resetDatabase();
  Future<void> close();
}



