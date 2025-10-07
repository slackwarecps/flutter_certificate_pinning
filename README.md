# Flutter Security | Como Implementei e Testei o SSL Pinning do Zero (Nativo vs. Dio)

Este é um projeto de prova de conceito (PoC) desenvolvido em Flutter, criado com o auxílio do Gemini. O objetivo principal é demonstrar a implementação de uma aplicação Flutter seguindo uma arquitetura limpa e consumindo uma API para uma funcionalidade de verificação de status de saúde.

## Artigo no medium 
https://medium.com/@fabio.alvaro/flutter-security-como-implementei-e-testei-o-ssl-pinning-do-zero-nativo-vs-dio-9b465ab2b8d5



## Arquitetura

O projeto segue uma estrutura de pastas organizada para separar as responsabilidades:

- `lib/domain/models`: Contém os modelos de dados da aplicação.
- `lib/infra/repositories`: Responsável pela comunicação com fontes de dados, como a API.
- `lib/presenter/controllers`: Onde a lógica de negócio da apresentação é gerenciada, utilizando GetX.
- `lib/presenter/pages`: Contém a UI (Widgets) das páginas da aplicação.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento de aplicações multiplataforma.
- **Dart**: Linguagem de programação utilizada pelo Flutter.
- **GetX**: Para gerenciamento de estado e de rotas.
- **Dio**: Cliente HTTP para realizar as chamadas à API.

## Configuração da API

A aplicação está configurada para se comunicar com um endpoint de API local:

- **Endpoint Base**: `http://localhost:8088`
- **Serviço**: `/sisbedev/v1/{{dominio}}`

**Nota**: Para que a aplicação funcione corretamente, é necessário ter um servidor de mock-api rodando localmente no endereço especificado.

## Como Executar o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone <url-do-repositorio>
    ```
2.  **Entre na pasta do projeto:**
    ```bash
    cd flutter_certificate_pinning
    ```
3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```
4.  **Execute a aplicação:**
    ```bash
    flutter run
    ```