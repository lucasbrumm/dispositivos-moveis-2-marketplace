# 🍰 Marketplace de Bolos

Um aplicativo Flutter completo de marketplace de bolos com navegação entre telas e funcionalidade de carrinho de compras.

## ✨ Funcionalidades

### 🏠 Tela Inicial (Home)
- Lista de bolos em grid responsivo
- Exibição de nome, preço e emoji de cada bolo
- Badge com contador de itens no carrinho
- Botão para adicionar bolos ao carrinho
- Indicação visual de bolos já adicionados ao carrinho
- Navegação para tela de detalhes ao tocar no bolo

### 📱 Tela de Detalhes do Bolo
- Imagem grande do bolo com animação Hero
- Nome, categoria e preço
- Descrição detalhada
- Lista de sabores disponíveis
- Controle de quantidade (se já estiver no carrinho)
- Botão para adicionar ao carrinho
- Indicação visual se o bolo já está no carrinho

### 🛒 Tela do Carrinho
- Lista de todos os itens adicionados
- Controle de quantidade para cada item (+/-)
- Remoção de itens individuais
- Botão para limpar todo o carrinho
- Cálculo automático de totais
- Resumo do pedido com subtotal e total
- Finalização do pedido com mensagem de confirmação
- Tela vazia com mensagem quando não há itens

## 🎨 Características de Design

- **Tema moderno**: Utiliza Material Design 3 com paleta de cores em tons de rosa e roxo
- **UI/UX otimizada**: Interface intuitiva e responsiva
- **Feedback visual**: Snackbars para ações do usuário
- **Animações suaves**: Transições entre telas com Hero animations
- **Badges informativos**: Contador de itens no carrinho sempre visível

## 🏗️ Arquitetura

O projeto segue boas práticas de organização de código Flutter:

```
lib/
├── main.dart                  # Ponto de entrada do app
├── models/                    # Modelos de dados
│   ├── cake.dart             # Modelo de Bolo
│   └── cart_item.dart        # Modelo de Item do Carrinho
├── providers/                 # Gerenciamento de estado
│   └── cart_provider.dart    # Provider do carrinho (ChangeNotifier)
└── screens/                   # Telas do aplicativo
    ├── home_screen.dart      # Tela inicial com lista de bolos
    ├── cake_detail_screen.dart # Detalhes do bolo
    └── cart_screen.dart      # Carrinho de compras
```

### Padrões Utilizados

- **Provider Pattern**: Para gerenciamento de estado do carrinho
- **Separation of Concerns**: Separação clara entre models, providers e screens
- **Responsive Design**: Layout adaptável a diferentes tamanhos de tela

## 📦 Dependências

- **flutter**: Framework principal
- **provider**: ^6.1.1 - Gerenciamento de estado
- **cupertino_icons**: ^1.0.8 - Ícones iOS

## 🚀 Como Executar

1. Certifique-se de ter o Flutter instalado
2. Clone o repositório
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

## 📱 Funcionalidades do Carrinho

### Adicionar ao Carrinho
- Adicione bolos a partir da tela inicial ou da tela de detalhes
- Se o bolo já estiver no carrinho, a quantidade é incrementada automaticamente

### Gerenciar Quantidades
- Aumente ou diminua a quantidade de cada item no carrinho
- Remova itens individuais ou limpe todo o carrinho

### Finalizar Pedido
- Visualize o resumo completo do seu pedido
- Confirme a compra e receba feedback de sucesso

## 🎯 Navegação

O aplicativo utiliza navegação imperativa do Flutter:

- **Home → Detalhes**: Ao tocar em um bolo
- **Home → Carrinho**: Via botão no AppBar
- **Detalhes → Carrinho**: Via SnackBar após adicionar item
- **Carrinho → Home**: Após finalizar pedido ou via botão voltar

## 🍰 Bolos Disponíveis

O marketplace inclui 8 bolos deliciosos:

1. **Bolo de Chocolate** - R$ 45,90
2. **Bolo de Morango** - R$ 52,90
3. **Bolo Red Velvet** - R$ 65,90
4. **Bolo de Cenoura** - R$ 38,90
5. **Bolo de Limão** - R$ 42,90
6. **Bolo Prestígio** - R$ 55,90
7. **Bolo de Baunilha** - R$ 40,90
8. **Bolo Floresta Negra** - R$ 68,90

Cada bolo possui:
- Nome e categoria
- Descrição detalhada
- Lista de sabores
- Preço individual
- Emoji representativo

## 🎨 Paleta de Cores

- **Primary**: Rosa (#E91E63)
- **Secondary**: Roxo (#9C27B0)
- **Accent**: Verde (#4CAF50) para ações de sucesso
- **Background**: Gradiente rosa-roxo para cards

## 📝 Licença

Este é um projeto educacional para demonstração de funcionalidades Flutter.
