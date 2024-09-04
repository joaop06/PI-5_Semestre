# PI-5_Semestre - CryptoInsight

CryptoInsight é uma aplicação web e mobile que oferece recomendações de investimentos, informações sobre valores atualizados, altas e baixas do mercado de criptomoedas, e outras análises financeiras, com base em uma combinação de dados atualizados e aprendizado de máquina.

## Tecnologias Utilizadas

- **Frontend Web**: [React](https://reactjs.org/)
- **Backend**: [Node.js](https://nodejs.org/) com [Hapi](https://hapi.dev/)
- **Mobile**: [Flutter](https://flutter.dev/)
- **Banco de Dados**: [MongoDB](https://www.mongodb.com/)

## Funcionalidades Principais

- **Recomendações de Investimentos**: Sugestões personalizadas baseadas em aprendizado de máquina e análise de dados.
- **Valores Atualizados**: Informações em tempo real sobre preços de criptomoedas, incluindo altas e baixas.
- **Análises do Mercado**: Gráficos e visualizações para entender melhor o comportamento do mercado.
- **Alertas Personalizados**: Notificações de mudanças significativas nos valores de criptomoedas.
- **Compatibilidade Multiplataforma**: Disponível como aplicação web e mobile.

## Pré-requisitos

Certifique-se de ter os seguintes softwares instalados:

- Node.js (v20 ou superior)
- Flutter (versão mais recente)
- MongoDB (instância local ou em nuvem)
- Yarn ou npm para gerenciamento de pacotes

## Como Iniciar o Projeto

### Backend

1. Clone o repositório:
    ```bash
    git clone https://github.com/seuusuario/cryptoinsight.git
    cd cryptoinsight/backend
    ```

2. Instale as dependências:
    ```bash
    npm install
    # ou
    yarn install
    ```

3. Configure o arquivo `.env` com suas credenciais do banco de dados e outras variáveis de ambiente:
    ```env
    MONGO_URI=mongodb://localhost:27017/cryptoinsight
    PORT=5000
    ```

4. Inicie o servidor:
    ```bash
    npm start
    # ou
    yarn start
    ```

### Frontend Web

1. Navegue até o diretório do frontend:
    ```bash
    cd ../frontend
    ```

2. Instale as dependências:
    ```bash
    npm install
    # ou
    yarn install
    ```

3. Inicie o servidor de desenvolvimento:
    ```bash
    npm start
    # ou
    yarn start
    ```

4. Acesse a aplicação no navegador em `http://localhost:3000`.

### Mobile

1. Navegue até o diretório do projeto Flutter:
    ```bash
    cd ../mobile
    ```

2. Instale as dependências:
    ```bash
    flutter pub get
    ```

3. Inicie o aplicativo em um dispositivo ou emulador:
    ```bash
    flutter run
    ```

## Estrutura do Projeto

```plaintext
cryptoinsight/
│
├── backend/             # Código fonte do backend (Node.js, Express ou Hapi)
│   ├── controllers/     # Controladores da aplicação
│   ├── models/          # Modelos do banco de dados
│   ├── routes/          # Rotas da API
│   └── server.js        # Arquivo principal do servidor
│
├── frontend/            # Código fonte do frontend web (React)
│   ├── public/          # Arquivos públicos (index.html, ícones, etc)
│   ├── src/             # Código fonte da aplicação React
│   └── package.json     # Dependências e scripts do projeto React
│
└── mobile/              # Código fonte do aplicativo mobile (Flutter)
    ├── lib/             # Código fonte do aplicativo Flutter
    └── pubspec.yaml     # Dependências do Flutter
