*** Settings ***
Library           RequestsLibrary
Library           Collections
Resource          ../resources/config.resource

*** Keywords ***
Realizar Login e Salvar Token
    [Documentation]    Realiza o login com um usuário fixo e salva o token de autenticação
    ...                para ser usado por toda a suíte de testes.

    ${headers}=       Create Dictionary    Content-Type=application/json
    Create Session    alias=supernatural   url=${BASE_URL}    headers=${headers}    verify=${True}

    ${body}=          Create Dictionary
    ...               mail=sysadmin@qacoders.com
    ...               password=1234@Test

    ${response}=      POST On Session    alias=supernatural    url=/login    json=${body}
    Status Should Be    200    ${response}

    ${token}=         Set Variable    ${response.json()["token"]}
    Set Suite Variable    ${AUTH_TOKEN}    ${token}  # <-- O token é salvo para toda a suíte