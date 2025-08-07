🚀 Projeto de Automação - API de Diretorias (QA.Coders)

Este projeto é um trabalho de automação de testes de API desenvolvido para o curso QA.Coders. Utilizando o Robot Framework, ele testa as funcionalidades de Criação, Leitura e Edição da API de Diretorias, garantindo que tudo funcione como o esperado.

🛠️ Tecnologias Utilizadas
Robot Framework: Framework de automação de testes.

RequestsLibrary: Biblioteca para interagir com APIs REST.

Python 3: Linguagem utilizada no projeto.

📂 Como Rodar os Testes
1. Configuração Inicial
Primeiro, clone o repositório e instale as dependências necessárias.

Bash

git clone https://coderefinery.github.io/github-without-command-line/doi/
cd [nome-do-repositorio]
pip install robotframework robotframework-requests
2. Executando a Suíte de Testes
Para rodar todos os testes, use o comando:

Bash

robot tests/
Para rodar testes específicos, você pode usar as tags definidas no projeto:

Bash

# Executa apenas os testes de criação (POST)
robot --include POST tests/

# Executa apenas os testes de fumaça (smoke tests)
robot --include smoke tests/
✅ O Que o Projeto Testa
Endpoints de Criação (POST): Testes de sucesso e cenários de erro para garantir a criação correta de diretorias.

Endpoints de Consulta (GET): Validação da consulta por ID e da contagem total de diretorias cadastradas.

Endpoints de Edição (PUT): Testes de edição de nome, incluindo a validação para nomes duplicados ou inválidos.
