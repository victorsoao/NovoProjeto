# File: seu_projeto/resources/diretoria.resource

*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     String
Resource    config.resource 
Resource    auth.resource

*** Keywords ***
Cadastrar nova diretoria
     [Arguments]     ${nome_diretoria}   
    [Documentation]    Envia uma requisição POST para criar uma nova diretoria.
    ${body}=       Create Dictionary    boardName=${nome_diretoria}
    ${response}=    POST On Session
    ...             alias=supernatural
    ...             url=/board?token=${AUTH_TOKEN}
    ...             json=${body}
    ...             expected_status=any
    RETURN          ${response}


Editar diretoria
    [Arguments]    ${id_diretoria}    ${novo_nome}    
    [Documentation]    Envia uma requisição PUT para editar o nome de uma diretoria.
    ${body}=           Create Dictionary    diretoria=${novo_nome}
    ${response}=       PUT On Session
    ...                alias=supernatural
    ...                url=/board/${id_diretoria}?token=${AUTH_TOKEN}
    ...                json=${body}
    ...                expected_status=any
    RETURN             ${response}

Consultar diretorias
    [Arguments]    &{filtros}
    [Documentation]    Envia uma requisição GET para buscar diretorias.
    ${response}=       GET On Session
    ...                alias=supernatural
    ...                url=/board?token=${AUTH_TOKEN}
    ...                params=${filtros}
    RETURN             ${response}



Contar Diretorias
    [Arguments]    &{filtros}
    [Documentation]    Envia uma requisição GET para /board/count.
    ${response}=       GET On Session
    ...                alias=supernatural
    ...                url=/board/count?token=${AUTH_TOKEN}    
    ...                params=${filtros}
    RETURN             ${response}

Consultar diretoria por id
    [Arguments]    ${id_diretoria}    ${expected_status}=200
    [Documentation]    Envia uma requisição GET para buscar uma única diretoria.
    ${response}=       GET On Session
    ...                alias=supernatural
    ...                url=/board/${id_diretoria}?token=${AUTH_TOKEN} 
    ...                expected_status=${expected_status}
    RETURN             ${response}

Inativar diretoria
    [Arguments]    ${id_diretoria}
    [Documentation]    Envia uma requisição DELETE para inativar uma diretoria (soft delete).
    ${response}=    DELETE On Session
    ...             alias=supernatural
    ...             url=/board/${id_diretoria}?token=${AUTH_TOKEN}
    RETURN    ${response}