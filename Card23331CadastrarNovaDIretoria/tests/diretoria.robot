*** Settings ***
Resource          ../resources/auth.resource
Resource          ../resources/diretoria.resource
Suite Setup       Realizar Login e Salvar Token
Library           String

*** Test Cases ***
# --- Testes de Cadastro (POST) ---
*** Test Cases ***
*** Test Cases ***
*** Test Cases ***
*** Test Cases ***
*** Test Cases ***
CT01: Cadastrar diretoria com nome valido
    [Tags]    POST    smoke

    # 1. Gera o nome base
    ${nome_randomico}=    Generate Random String    8    [LOWER]
    ${nome_base}=         Set Variable    E${nome_randomico}

    # 2. Envia para a API o nome no formato "Capitalized"
    ${resp}=              Cadastrar nova diretoria    ${nome_base.capitalize()}

    # 3. Prepara a variável com o resultado esperado (também "Capitalized")
    ${nome_esperado_no_retorno}=    Set Variable    ${nome_base.capitalize()}

    # 4. Chama a keyword de validação
    Validar que a diretoria foi criada com sucesso    ${resp}    ${nome_esperado_no_retorno}

*** Test Cases ***
CT02: Cadastrar diretoria com nome composto e '&'
    [Tags]    POST

    # 1. Gera as duas partes aleatórias do nome
    ${nome1}=    Generate Random String    8    [LOWER]
    ${nome2}=    Generate Random String    8    [LOWER]

    # 2. Junta as partes com o '&' no meio.
    #    O Set Variable une tudo com espaços automaticamente.
    ${nome_base}=    Set Variable    ${nome1} & ${nome2}

    # Para depurar, vamos ver como ficou o nome base
    Log To Console    Nome Base Gerado: ${nome_base}
    # Exemplo: "bhrfteqo & pmdkiylw"

    # 3. Prepara a variável com o resultado esperado (formato "Capitalize")
    #    A API vai transformar "bhrfteqo & pmdkiylw" em "Bhrfteqo & pmdkiylw"
    ${nome_formatado_esperado}=    Set Variable    ${nome_base.capitalize()}

    Log To Console    Nome Formatado Esperado: ${nome_formatado_esperado}
    # Exemplo: "Bhrfteqo & pmdkiylw"

    # 4. Envia para a API o nome para ser cadastrado
    ${resp}=              Cadastrar nova diretoria    ${nome_formatado_esperado}

    # 5. Chama a keyword de validação, que já está correta
    Validar que a diretoria foi criada com sucesso    ${resp}    ${nome_formatado_esperado}

CT03: Cadastrar diretoria com nome aleatório contendo acentos
    [Tags]    POST

    # 1. Gera uma string aleatória de 12 caracteres usando a nossa lista customizada.
    ${nome_com_acento}=    Generate Random String    12    chars=${CHARS_COM_ACENTOS}

    # Log para vermos o resultado da geração aleatória
    Log To Console    Nome aleatório com acento gerado: ${nome_com_acento}
    # Exemplo: "õçãéúbcaqií"

    # 2. Prepara o nome para validação (a API vai capitalizar a primeira letra)
    ${nome_formatado_esperado}=    Set Variable    ${nome_com_acento.capitalize()}

    Log To Console    Nome formatado esperado: ${nome_formatado_esperado}
    # Exemplo: "Õçãéúbcaqií"

    # 3. Envia para a API o nome para ser cadastrado
    ${resp}=              Cadastrar nova diretoria    ${nome_formatado_esperado}

    # 4. Chama a keyword de validação
    Validar que a diretoria foi criada com sucesso    ${resp}    ${nome_formatado_esperado}

CT04: Cadastrar diretoria com nome no limite minimo (1 caracteres)
    [Tags]    POST    boundary
    # Usa um valor fixo ("TI"), pois o objetivo aqui é testar o limite de 2 caracteres, não a unicidade.
    ${nome_limite}=    Set Variable    D

    ${resp}=    Cadastrar nova diretoria    ${nome_limite}
    Validar que a diretoria foi criada com sucesso    ${resp}    ${nome_limite}

CT05: Nao permitir cadastrar diretoria com nome duplicado
    [Tags]    POST    negative
    # Gera um nome randômico para garantir que o teste não falhe por dados de execuções anteriores.
    ${nome_duplicado}=    Generate Random String    20    [UPPER]

    Cadastrar nova diretoria    ${nome_duplicado}
    ${resp}=    Cadastrar nova diretoria    ${nome_duplicado}
    Validar erro de negocio    ${resp}    409    Cadastro já existe

CT06: Nao permitir cadastrar diretoria com nome vazio
    [Tags]    POST    negative
    ${resp}=    Cadastrar nova diretoria    ${EMPTY}
    Validar erro de negocio    ${resp}    400    O campo Diretoria é obrigatório

# --- Testes de Listagem e Pesquisa (GET) ---
CT07: Listar diretorias em ordem alfabetica
    [Tags]    GET     regression
    # Usa nomes randômicos para não interferir com outros testes.
    Cadastrar nova diretoria    Zebra Corp ${:Generate Random String}
    Cadastrar nova diretoria    Apple Inc ${:Generate Random String}
    Cadastrar nova diretoria    Banana SA ${:Generate Random String}

    ${resp}=    Consultar diretorias
    Validar que a lista de diretorias esta ordenada    ${resp}

# --- Testes de Edição (PUT) ---
CT08: Editar o nome de uma diretoria com sucesso
    [Tags]    PUT     smoke
    # Gera nomes randômicos para garantir a independência do teste.
    ${nome_antigo}=      Generate Random String    20    [LOWER]
    ${nome_novo}=        Generate Random String    20    [UPPER]

    ${resp_cadastro}=    Cadastrar nova diretoria    ${nome_antigo}
    ${id}=               Obter ID da diretoria na resposta    ${resp_cadastro}
    ${resp_edicao}=      Editar diretoria    ${id}    ${nome_novo}
    Validar edicao com sucesso    ${resp_edicao}

# --- Testes de Inativação (DELETE) ---
CT25: Inativar uma diretoria com sucesso
    [Tags]    DELETE    smoke
    ${nome}=               Generate Random String    20    Diretoria Para Inativar-[LOWER]
    ${resp_cadastro}=      Cadastrar nova diretoria    ${nome}
    ${id}=                 Obter ID da diretoria na resposta    ${resp_cadastro}

    ${resp_inativacao}=    Inativar diretoria    ${id}
    Validar inativacao com sucesso    ${resp_inativacao}

CT09: Nao permitir inativar diretoria com vinculos
    [Tags]    DELETE    negative    business_rule
    # Este teste usa um ID fixo que, por regra de negócio, deve ter vínculos.
    ${id_fixo}=    Set Variable    687e9301824cbe8ca3f48937
    ${resp}=       Inativar diretoria    ${id_fixo}
    Validar erro de negocio    ${resp}    409    Essa Diretoria faz parte de um cadastro ativo