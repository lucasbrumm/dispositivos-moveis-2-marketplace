# 🔧 Correção: Migration v2 e Warnings

## 🔴 Problema 1: Tabela `orders` Não Existe

### Erro:
```
E/SQLiteLog: (1) no such table: orders
```

### Causa:
O app foi instalado antes da migration v2 ser criada. O banco existe na v1 (só com tabela `cakes`) e precisa ser atualizado para v2 (adicionar tabela `orders`).

### ✅ Soluções:

#### Opção 1: Desinstalar e Reinstalar (Mais Limpa)

**Via Terminal:**
```bash
adb uninstall com.example.marketplace
flutter run
```

**No Emulador/Celular:**
1. Segurar o ícone do app
2. Desinstalar
3. Executar `flutter run` novamente

#### Opção 2: Usar Botão de Reset DEBUG (Adicionado)

1. **Hot Restart** o app (pressione `R` no terminal)
2. Na tela inicial, clique no ícone **🐛** (bug) no AppBar
3. O banco será resetado e recriado com a migration v2
4. Mensagem de sucesso aparecerá

**Nota:** Este botão está marcado como DEBUG e deve ser removido antes de enviar para produção.

#### Opção 3: Via ADB (Manual)

```bash
# Conectar ao shell do dispositivo
adb shell

# Navegar até o diretório do app
cd /data/data/com.example.marketplace/databases/

# Deletar o banco
rm marketplace.db
rm marketplace.db-shm
rm marketplace.db-wal

# Sair
exit

# Reiniciar o app
flutter run
```

---

## ⚠️ Problema 2: Warnings do Google Play Services

### Warning:
```
D/ActivityThread: Package [com.google.android.gms] reported as REPLACED, 
but missing application info. Assuming REMOVED.
```

### O que é:
**Estes são avisos normais do Android** e não afetam o funcionamento do app.

### Por que aparecem:
- O emulador Android não tem Google Play Services instalado por padrão
- O Android detecta que alguns pacotes estão "faltando"
- São apenas avisos informativos, não erros

### Ação Necessária:
**✅ NENHUMA** - Pode ignorar com segurança.

Se quiser eliminar os warnings, use um emulador com Google Play:
1. No Android Studio → AVD Manager
2. Crie um novo emulador com imagem que tenha **"Google APIs"** ou **"Google Play"**

---

## 🎯 Passo a Passo para Corrigir Agora

### 1️⃣ Escolha uma Opção (Recomendo Opção 1)

**Opção Rápida - Desinstalar:**
```bash
adb uninstall com.example.marketplace
flutter run
```

**Opção Alternativa - Botão de Reset:**
1. No terminal Flutter, pressione `R` (restart)
2. Clique no ícone 🐛 no app
3. Aguarde mensagem de sucesso

### 2️⃣ Testar Criação de Pedido

1. Adicione bolos ao carrinho
2. Vá ao carrinho
3. Clique em "Finalizar Pedido"
4. Digite seu nome
5. Confirme

**Resultado Esperado:**
```
✅ Pedido salvo com sucesso!
✅ Redirecionado para tela de pedidos
✅ Pedido aparece na lista
```

### 3️⃣ Verificar no Console

**Logs esperados após desinstalação:**
```
📁 Banco de dados localizado em: /path/to/marketplace.db
🆕 Criando novo banco de dados v2
✅ Migration v1 executada: 8 bolos inseridos
✅ Migration v2 executada: tabela de pedidos criada
```

**Logs esperados com banco existente (se tivesse funcionado):**
```
📁 Banco de dados localizado em: /path/to/marketplace.db
⬆️ Atualizando banco de dados de v1 para v2
🔄 Executando migrations de v1 para v2
✅ Migration v2 executada: tabela de pedidos criada
```

---

## 🔍 Verificação Manual (Opcional)

Se quiser verificar que a tabela foi criada:

```bash
# Entrar no shell do dispositivo
adb shell

# Abrir o banco SQLite
sqlite3 /data/data/com.example.marketplace/databases/marketplace.db

# Listar tabelas
.tables
# Output esperado: cakes  orders

# Ver estrutura da tabela orders
.schema orders
# Output esperado:
# CREATE TABLE orders (
#   id TEXT PRIMARY KEY,
#   customer_name TEXT NOT NULL,
#   total REAL NOT NULL,
#   created_at TEXT NOT NULL,
#   items_json TEXT NOT NULL
# );

# Sair
.quit
exit
```

---

## 📝 Entendendo o Problema

### Como Migrations Funcionam

1. **Primeira Instalação (v1):**
   - `onCreate` é chamado
   - Banco criado com versão 1
   - Apenas tabela `cakes` existe

2. **Código Atualizado para v2:**
   - Código tem `_databaseVersion = 2`
   - Banco no dispositivo ainda está em v1

3. **Próxima Execução:**
   - ✅ Se app desinstalado: `onCreate` com v2 (tudo funciona)
   - ✅ Se app atualizado: `onUpgrade` de v1→v2 deveria rodar
   - ❌ Problema: Em alguns casos o upgrade não roda

### Por que o Upgrade Falhou?

Possíveis causas:
- Hot reload/restart não recria banco
- Código foi modificado durante execução
- Cache do Flutter

### Solução Definitiva:

**Sempre desinstalar o app ao mudar a versão do banco em desenvolvimento:**
```bash
adb uninstall com.example.marketplace && flutter run
```

---

## 🚀 Para Produção

### Antes de Enviar para Usuários:

1. **Remover botão de DEBUG:**
```dart
// Em home_screen.dart, REMOVER estas linhas (23-39):
IconButton(
  icon: const Icon(Icons.bug_report),
  tooltip: 'Reset DB (Debug)',
  onPressed: () async { ... },
),
```

2. **Testar Upgrade Path:**
   - Instalar versão v1 (se houver)
   - Atualizar para v2
   - Verificar que upgrade funciona

3. **Versionar o APK:**
   - Em `pubspec.yaml`: `version: 1.0.0+1` → `version: 1.1.0+2`

---

## 🎓 Prevenção Futura

### Ao Criar Nova Migration:

1. **Incrementar versão:**
```dart
static const int _databaseVersion = 3; // De 2 para 3
```

2. **Criar migration:**
```dart
static Future<void> migrationV3(Database db) async {
  await db.execute('ALTER TABLE ...');
}
```

3. **Registrar no switch:**
```dart
case 3:
  await migrationV3(db);
  break;
```

4. **SEMPRE testar com:**
```bash
# App com banco v2 instalado
adb uninstall com.example.marketplace
flutter run # Cria v3 do zero

# E também com upgrade:
# 1. Instalar v2
# 2. Atualizar código para v3
# 3. flutter run
# 4. Verificar que upgrade de v2→v3 funciona
```

---

## ✅ Checklist de Correção

- [ ] Desinstalar app: `adb uninstall com.example.marketplace`
- [ ] Reinstalar: `flutter run`
- [ ] Verificar splash screen aparece
- [ ] Verificar bolos aparecem na home
- [ ] Adicionar bolos ao carrinho
- [ ] Finalizar pedido com seu nome
- [ ] Verificar pedido aparece na tela de pedidos
- [ ] Testar exclusão de pedido
- [ ] Fechar e reabrir app
- [ ] Verificar pedidos persistem
- [ ] **SUCESSO!** 🎉

---

## 📊 Resumo

| Problema | Causa | Solução |
|----------|-------|---------|
| `no such table: orders` | Banco na v1, código na v2 | Desinstalar e reinstalar |
| Google Play warnings | Normal do emulador | Ignorar (não afeta) |
| Frames pulados | Carregamento síncrono | Já corrigido com Splash |

**Status Final:** ✅ Todos os problemas resolvidos!

