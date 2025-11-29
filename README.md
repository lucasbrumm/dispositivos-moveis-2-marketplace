# 📋 Documento de Especificação - Marketplace de Bolos

## 1. Nome e Descrição do Aplicativo

### Nome
**Marketplace de Bolos** 🍰

### Descrição
O Marketplace de Bolos é um aplicativo mobile desenvolvido em Flutter que oferece uma experiência completa de e-commerce para venda de bolos artesanais. O aplicativo permite aos usuários navegar por um catálogo de bolos, visualizar detalhes de cada produto, gerenciar um carrinho de compras e realizar pedidos que são persistidos localmente no dispositivo através de banco de dados SQLite.

O aplicativo foi desenvolvido seguindo boas práticas de arquitetura Flutter, utilizando padrões de design como Provider para gerenciamento de estado e Repository Pattern para abstração da camada de dados, garantindo escalabilidade e manutenibilidade do código.

---

## 2. Funcionalidades Implementadas

### 2.1. Catálogo de Produtos

**Tela Inicial (Home Screen)**
- Exibição de 8 bolos em grid responsivo (2 colunas)
- Cada card exibe: emoji, nome, preço e botão de ação
- Badge com contador de itens no carrinho no AppBar
- Indicador visual para bolos já adicionados ao carrinho
- Navegação para tela de detalhes ao tocar no card
- Tela de splash screen com loading durante inicialização
- Tratamento de estados: loading, erro e vazio
- Suporte multiplataforma (Android, iOS, Web)

**Tela de Detalhes do Bolo**
- Visualização completa das informações do bolo
- Exibição de: nome, categoria, descrição, preço e sabores
- Animação Hero para transição suave
- Botão para adicionar ao carrinho
- Indicador se o bolo já está no carrinho
- Navegação direta para carrinho via SnackBar

### 2.2. Carrinho de Compras

**Gerenciamento de Itens**
- Adição de bolos ao carrinho (incremento automático se já existir)
- Controle de quantidade individual por item (+/-)
- Remoção de itens individuais
- Limpeza completa do carrinho com confirmação
- Cálculo automático de subtotal e total
- Badge dinâmico com quantidade total de itens

**Finalização de Pedido**
- Diálogo de checkout com campo para nome do cliente
- Validação de dados obrigatórios
- Resumo do pedido antes de confirmar
- Persistência do pedido no banco de dados SQLite
- Limpeza automática do carrinho após confirmação
- Navegação automática para tela de pedidos
- Feedback visual com mensagens de sucesso/erro

### 2.3. Sistema de Pedidos

**Visualização de Pedidos**
- Lista completa de todos os pedidos realizados
- Ordenação por data (mais recentes primeiro)
- Cards expansíveis com detalhes completos
- Exibição de: nome do cliente, data/hora, valor total
- Detalhamento de cada item do pedido (nome, quantidade, preço)
- Opção de excluir pedidos com confirmação
- Estados visuais: loading, erro e lista vazia

**Persistência de Dados**
- Todos os pedidos são salvos no banco SQLite
- Dados persistem entre sessões do aplicativo
- Sistema de migrations para evolução do banco de dados
- Suporte para upgrade automático de versão do banco

### 2.4. Persistência de Dados

**Banco de Dados SQLite**
- Tabela `cakes`: Armazena informações dos bolos
- Tabela `orders`: Armazena pedidos com itens em JSON
- Sistema de migrations versionado (v1 e v2)
- Inserção automática de 8 bolos iniciais na primeira execução
- Operações CRUD completas para bolos e pedidos
- Suporte multiplataforma: SQLite em mobile, memória em web

**Repository Pattern**
- Abstração da camada de dados através de interfaces
- Implementação específica por plataforma (SQLite/Memória)
- Factory pattern para seleção automática da implementação
- Facilita testes e manutenção

### 2.5. Gerenciamento de Estado

**Providers Implementados**
- `CakeProvider`: Gerencia estado dos bolos (carregamento, listagem)
- `CartProvider`: Gerencia estado do carrinho (itens, quantidades, totais)
- `OrderProvider`: Gerencia estado dos pedidos (criação, listagem, exclusão)

**Estados Gerenciados**
- Loading states para operações assíncronas
- Error handling com mensagens amigáveis
- Estados vazios com mensagens informativas
- Notificações automáticas de mudanças (ChangeNotifier)

### 2.6. Interface e Experiência do Usuário

**Design System**
- Material Design 3 com tema personalizado
- Paleta de cores em tons de rosa e roxo
- Gradientes suaves nos cards de produtos
- Ícones intuitivos e consistentes
- Tipografia hierárquica e legível

**Navegação**
- Navegação imperativa entre telas
- AppBar com ações rápidas (pedidos, carrinho)
- Botão de voltar nativo
- Transições suaves entre telas

**Feedback Visual**
- SnackBars para ações do usuário
- Indicadores de loading durante operações
- Mensagens de erro com opção de retry
- Badges informativos no AppBar
- Animações Hero para elementos compartilhados

---

## 3. Tecnologias Utilizadas

### 3.1. Framework e Linguagem

**Flutter**
- Versão: SDK ^3.9.2
- Framework multiplataforma para desenvolvimento mobile
- Linguagem: Dart
- Suporte para Android, iOS e Web

### 3.2. Gerenciamento de Estado

**Provider** (^6.1.1)
- Padrão Provider para gerenciamento de estado reativo
- ChangeNotifier para notificações de mudanças
- MultiProvider para múltiplos providers na árvore de widgets
- Reduz acoplamento e facilita testes

### 3.3. Persistência de Dados

**SQLite (sqflite)** (^2.3.0)
- Banco de dados SQLite nativo para Android e iOS
- Operações assíncronas para não bloquear a UI
- Suporte a migrations versionadas
- Transações e queries otimizadas

**Path** (^1.8.3)
- Manipulação de caminhos de arquivos
- Utilizado para localização do banco de dados
- Compatibilidade multiplataforma

### 3.4. Arquitetura e Padrões

**Repository Pattern**
- Abstração da camada de dados
- Interface `CakeRepository` para operações CRUD
- Implementações: `DatabaseHelper` (SQLite) e `CakeRepositoryMemory` (Web)
- Factory pattern para seleção automática

**Migrations**
- Sistema versionado de evolução do banco de dados
- Migrations incrementais (v1 → v2)
- Execução automática na inicialização
- Suporte para rollback e upgrade

### 3.5. Ferramentas de Desenvolvimento

**Flutter Lints** (^5.0.0)
- Análise estática de código
- Boas práticas e convenções Flutter
- Detecção de problemas potenciais

**Cupertino Icons** (^1.0.8)
- Biblioteca de ícones iOS
- Ícones consistentes e profissionais

### 3.6. Estrutura de Dados

**Modelos**
- `Cake`: Modelo de dados do bolo com serialização JSON
- `CartItem`: Item do carrinho com quantidade
- `Order`: Pedido completo com lista de itens
- `OrderItem`: Item individual do pedido

**Serialização**
- Métodos `toMap()` e `fromMap()` para conversão
- JSON encoding/decoding para listas complexas
- Compatibilidade com banco de dados

---

## 4. Instruções de Instalação e Execução

### 4.1. Pré-requisitos

**Flutter SDK**
- Versão mínima: 3.9.2
- Verificar instalação: `flutter --version`
- Instalação: https://flutter.dev/docs/get-started/install

**Android Studio** (para desenvolvimento Android)
- Android SDK configurado
- Emulador Android ou dispositivo físico
- Depuração USB habilitada (para dispositivo físico)

**VS Code ou Android Studio** (IDE recomendado)
- Extensões Flutter e Dart instaladas
- Configuração do ambiente de desenvolvimento

### 4.2. Instalação

**1. Clonar o Repositório**
```bash
git clone <url-do-repositorio>
cd dispositivos-moveis-2-marketplace
```

**2. Instalar Dependências**
```bash
flutter pub get
```

Este comando irá baixar e instalar todas as dependências listadas no `pubspec.yaml`:
- provider
- sqflite
- path
- cupertino_icons

**3. Verificar Configuração**
```bash
flutter doctor
```

Certifique-se de que todos os componentes necessários estão instalados e configurados corretamente.

### 4.3. Execução

**Executar no Emulador/Dispositivo Android**

1. **Iniciar Emulador** (se usando emulador):
   - Abrir Android Studio
   - AVD Manager → Iniciar emulador
   - Ou via terminal: `flutter emulators --launch <nome>`

2. **Conectar Dispositivo Físico** (se usando dispositivo):
   - Conectar via USB
   - Habilitar "Depuração USB" nas opções do desenvolvedor
   - Verificar conexão: `adb devices`

3. **Executar o Aplicativo**:
```bash
flutter run
```

O Flutter detectará automaticamente o dispositivo disponível e instalará o aplicativo.

**Executar na Web (Chrome)**
```bash
flutter run -d chrome
```

**Executar em Dispositivo Específico**
```bash
# Listar dispositivos disponíveis
flutter devices

# Executar em dispositivo específico
flutter run -d <device-id>
```

### 4.4. Build para Produção

**Gerar APK de Release (Android)**
```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

**Gerar APK Split por ABI (menor tamanho)**
```bash
flutter build apk --split-per-abi
```

Gera APKs separados para cada arquitetura (arm64-v8a, armeabi-v7a, x86_64).

**Instalar APK no Dispositivo**
```bash
# Via ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Ou via Flutter
flutter install
```

### 4.5. Comandos Úteis Durante Desenvolvimento

**Hot Reload**
- Pressione `r` no terminal durante execução
- Aplica mudanças sem reiniciar o app

**Hot Restart**
- Pressione `R` (maiúsculo) no terminal
- Reinicia o app mantendo o estado

**Ver Logs**
```bash
flutter logs
```

**Limpar Build**
```bash
flutter clean
flutter pub get
```

### 4.6. Solução de Problemas Comuns

**Erro: "no such table: orders"**
- Solução: Desinstalar e reinstalar o app
```bash
adb uninstall com.example.marketplace
flutter run
```

**Erro: "databaseFactory not initialized" (Web)**
- Normal: SQLite não funciona na web, usa memória automaticamente
- Não é necessário ação

**Erro: Dispositivo não detectado**
```bash
# Verificar conexão ADB
adb devices

# Reiniciar servidor ADB
adb kill-server
adb start-server
```

**Erro: Dependências não instaladas**
```bash
flutter clean
flutter pub get
flutter run
```

### 4.7. Estrutura do Projeto

```
dispositivos-moveis-2-marketplace/
├── lib/
│   ├── main.dart                    # Ponto de entrada
│   ├── models/                      # Modelos de dados
│   │   ├── cake.dart
│   │   ├── cart_item.dart
│   │   └── order.dart
│   ├── providers/                   # Gerenciamento de estado
│   │   ├── cake_provider.dart
│   │   ├── cart_provider.dart
│   │   └── order_provider.dart
│   ├── screens/                     # Telas do aplicativo
│   │   ├── home_screen.dart
│   │   ├── cake_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   └── orders_screen.dart
│   └── database/                    # Camada de persistência
│       ├── database_helper.dart
│       ├── migrations.dart
│       ├── cake_repository.dart
│       ├── cake_repository_factory.dart
│       └── cake_repository_memory.dart
├── android/                          # Configurações Android
├── ios/                              # Configurações iOS
├── web/                              # Configurações Web
├── pubspec.yaml                      # Dependências do projeto
└── README.md                         # Documentação básica
```

---

## 5. Considerações Finais

O Marketplace de Bolos é um aplicativo completo e funcional que demonstra o uso de tecnologias modernas de desenvolvimento mobile, incluindo gerenciamento de estado, persistência de dados local e arquitetura escalável. O projeto está pronto para execução e pode ser facilmente estendido com novas funcionalidades como autenticação de usuários, integração com APIs REST, sistema de pagamento e notificações push.

**Versão do Aplicativo:** 1.0.0+1  
**Data de Criação:** 2024  
**Plataformas Suportadas:** Android, iOS, Web