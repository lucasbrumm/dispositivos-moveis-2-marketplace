import 'package:flutter/foundation.dart' show kIsWeb;
import 'cake_repository.dart';
import 'cake_repository_memory.dart';
import 'database_helper.dart';

/// Factory para criar a implementação correta do repositório
/// baseado na plataforma (web usa memória, mobile usa SQLite)
class CakeRepositoryFactory {
  static CakeRepository? _instance;

  /// Retorna a instância apropriada do repositório baseado na plataforma
  static CakeRepository get instance {
    if (_instance != null) return _instance!;

    if (kIsWeb) {
      // Para web, usar implementação em memória
      _instance = CakeRepositoryMemory.instance;
    } else {
      // Para mobile (Android/iOS), usar SQLite
      _instance = DatabaseHelper.instance;
    }

    return _instance!;
  }

  /// Força reinicialização (útil para testes)
  static void reset() {
    _instance = null;
  }
}



