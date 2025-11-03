# Sistema de Banco de Dados - SQLite

Este diretório contém toda a estrutura de persistência de dados usando SQLite para o aplicativo Marketplace de Bolos.

## 📁 Estrutura de Arquivos

- **`database_helper.dart`**: Classe principal que gerencia a conexão com o banco de dados e operações CRUD
- **`migrations.dart`**: Sistema de migrations para versionamento e evolução do schema do banco

## 🗄️ Schema do Banco de Dados

### Tabela: `cakes`

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | TEXT PRIMARY KEY | Identificador único do bolo |
| `name` | TEXT NOT NULL | Nome do bolo |
| `description` | TEXT NOT NULL | Descrição detalhada |
| `price` | REAL NOT NULL | Preço do bolo |
| `image` | TEXT NOT NULL | Emoji ou URL da imagem |
| `category` | TEXT NOT NULL | Categoria do bolo |
| `flavors` | TEXT NOT NULL | Lista de sabores em formato JSON |

## 🔄 Sistema de Migrations

### O que são Migrations?

Migrations são arquivos que descrevem mudanças no schema do banco de dados ao longo do tempo. Elas permitem:

- ✅ Versionar o schema do banco de dados
- ✅ Aplicar mudanças de forma incremental
- ✅ Manter consistência entre diferentes instalações
- ✅ Facilitar upgrades do aplicativo

### Como Funciona?

1. **Versão Inicial (v1)**: Cria a tabela `cakes` e insere os 8 bolos iniciais
2. **Versões Futuras**: Novas migrations podem adicionar tabelas, colunas, índices, etc.

### Exemplo de Nova Migration

Para adicionar uma nova funcionalidade (exemplo: estoque de bolos):

```dart
// Em migrations.dart, descomente e modifique:
static Future<void> migration_v2(Database db) async {
  await db.execute('''
    ALTER TABLE cakes ADD COLUMN stock INTEGER DEFAULT 10
  ''');
  
  print('✅ Migration v2 executada: coluna stock adicionada');
}
```

Depois, atualize a versão em `database_helper.dart`:

```dart
static const int _databaseVersion = 2; // Mudar de 1 para 2
```

E registre a migration em `migrations.dart`:

```dart
case 2:
  await migration_v2(db);
  break;
```

## 📊 Operações Disponíveis

O `DatabaseHelper` fornece as seguintes operações:

### Leitura
- `readAllCakes()`: Retorna todos os bolos
- `readCake(id)`: Retorna um bolo específico
- `readCakesByCategory(category)`: Retorna bolos de uma categoria

### Escrita
- `createCake(cake)`: Adiciona um novo bolo
- `updateCake(cake)`: Atualiza um bolo existente
- `deleteCake(id)`: Remove um bolo
- `deleteAllCakes()`: Remove todos os bolos

### Utilidades
- `resetDatabase()`: Apaga e recria o banco (útil para desenvolvimento)
- `close()`: Fecha a conexão com o banco

## 🎯 Como Usar

### 1. Inicialização (já configurado no main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}
```

### 2. Usando com Provider

```dart
final cakeProvider = Provider.of<CakeProvider>(context);
await cakeProvider.loadCakes(); // Carrega do banco
```

### 3. Operações Diretas

```dart
// Listar todos os bolos
final cakes = await DatabaseHelper.instance.readAllCakes();

// Adicionar um novo bolo
final newCake = Cake(
  id: '9',
  name: 'Bolo de Coco',
  description: 'Delicioso bolo de coco',
  price: 35.90,
  image: '🥥',
  category: 'Tradicionais',
  flavors: ['Coco'],
);
await DatabaseHelper.instance.createCake(newCake);

// Buscar por categoria
final chocolateCakes = await DatabaseHelper.instance
    .readCakesByCategory('Chocolate');
```

## 🔧 Desenvolvimento

### Reset do Banco de Dados

Durante o desenvolvimento, você pode precisar resetar o banco:

```dart
await DatabaseHelper.instance.resetDatabase();
```

Ou através do provider:

```dart
await cakeProvider.resetDatabase();
```

### Localização do Banco

O banco de dados é criado em:
- **Android**: `/data/data/com.example.marketplace/databases/marketplace.db`
- **iOS**: `Library/Application Support/marketplace.db`

### Debugging

Os logs do banco aparecem no console:
- 📁 Localização do arquivo do banco
- 🆕 Criação de novo banco
- ⬆️ Upgrade de versão
- ✅ Migrations executadas

## 📝 Notas Importantes

1. **Migrations são incrementais**: Sempre adicione novas migrations, nunca modifique as existentes
2. **Versão do banco**: Incremente `_databaseVersion` ao adicionar migrations
3. **Testes**: Sempre teste migrations em um ambiente de desenvolvimento primeiro
4. **Backup**: Em produção, considere implementar backup de dados antes de migrations
5. **Flavors JSON**: A lista de sabores é armazenada como JSON string para compatibilidade

## 🚀 Próximos Passos

Possíveis melhorias futuras:

- [ ] Adicionar tabela de pedidos (orders)
- [ ] Adicionar tabela de clientes (customers)
- [ ] Implementar histórico de compras
- [ ] Adicionar campo de estoque (stock)
- [ ] Implementar sistema de favoritos
- [ ] Adicionar avaliações e comentários



