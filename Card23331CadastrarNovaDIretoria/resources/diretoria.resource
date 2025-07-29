*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           String

*** Keywords ***
# --- Keywords de Ação (POST, PUT, DELETE, GET) ---
Cadastrar nova diretoria
    [Arguments]    ${nome_diretoria}
    [Documentation]    Envia uma requisição POST para criar uma nova diretoria.
    ${body}=       Create Dictionary    boardName=${nome_diretoria}
    ${response}=    POST On Session
    ...             alias=supernatural
    ...             url=/board?token=${AUTH_TOKEN}
    ...             json=${body}
    RETURN    ${response}

    

Editar diretoria
    [Arguments]    ${id_diretoria}    ${novo_nome}
    [Documentation]    Envia uma requisição PUT para editar o nome de uma diretoria.
    ${body}=       Create Dictionary    boardName=${novo_nome}
    ${response}=    PUT On Session
    ...             alias=supernatural
    ...             url=/board/${id_diretoria}?token=${AUTH_TOKEN}
    ...             json=${body}
    RETURN    ${response}

Inativar diretoria
    [Arguments]    ${id_diretoria}
    [Documentation]    Envia uma requisição DELETE para inativar uma diretoria (soft delete).
    ${response}=    DELETE On Session
    ...             alias=supernatural
    ...             url=/board/${id_diretoria}?token=${AUTH_TOKEN}
    RETURN    ${response}

Consultar diretorias
    [Arguments]    &{filtros}
    [Documentation]    Envia uma requisição GET para buscar diretorias, com filtros opcionais.
    ${response}=    GET On Session
    ...             alias=supernatural
    ...             url=/board/all?token=${AUTH_TOKEN}
    ...             params=${filtros}
    RETURN    ${response}

Obter ID da diretoria na resposta
    [Arguments]    ${response_cadastro}
    [Documentation]    Extrai o ID de uma diretoria a partir da resposta de um cadastro.
    RETURN    ${response_cadastro.json()}[newBoard][_id]

# --- Keywords de Validação ---
Validar que a diretoria foi criada com sucesso
    [Arguments]    ${response}    ${nome_esperado_exato}
    [Documentation]    Valida se a resposta da criação foi 201 e se o nome está correto.
    
    Status Should Be    201    ${response}
    ${nome_retornado}=    Set Variable    ${response.json()}[newBoard][boardName]
    Should Be Equal    ${nome_retornado}    ${nome_esperado_exato}

Validar edicao com sucesso
    [Arguments]    ${response}
    [Documentation]    Valida se a resposta da edição foi 200 OK.
    Status Should Be    200    ${response}
    Should Contain    ${response.json()}[msg]    Cadastro editado com sucesso

Validar inativacao com sucesso
    [Arguments]    ${response}
    [Documentation]    Valida se a resposta da inativação foi 200 OK.
    Status Should Be    200    ${response}
    Should Contain    ${response.json()}[msg]    Cadastro inativado com sucesso

Validar erro de negocio
    [Arguments]    ${response}    ${status_esperado}    ${mensagem_parcial}
    [Documentation]    Keyword genérica para validar respostas de erro da API.
    Status Should Be    ${status_esperado}    ${response}
    Should Contain    ${response.json()}[msg]    ${mensagem_parcial}

Validar que a lista de diretorias esta ordenada
    [Arguments]    ${response_lista}
    [Documentation]    Verifica se a lista de diretorias retornada está em ordem alfabética.
    Status Should Be    200    ${response_lista}
    ${boards}=          Set Variable    ${response_lista.json()}
    ${nomes}=           Create List
    FOR    ${board}    IN    @{boards}
        Append To List    ${nomes}    ${board['boardName']}
    END
    ${nomes_ordenados}=    Copy List    ${nomes}
    Sort List    ${nomes_ordenados}
    Lists Should Be Equal    ${nomes}    ${nomes_ordenados}