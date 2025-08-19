*** Settings ***
Resource          ../resources/config.resource
Library           SeleniumLibrary

*** Keywords ***
Abrir Navegador
    Open Browser    browser=chrome
    Maximize Browser Window
    Go To    url=${BASE_URL}
    Input Text        locator=//*[@id="email"]    text=${ADMIN_EMAIL}
    Input Text        locator=//*[@id="password"]    text=${ADMIN_PASSWORD}
    Click Button      locator=//*[@id="login"]
    Wait Until Element Is Visible    xpath=//*[@id="Cadastros"]
    Click Element    xpath=//*[@id="Cadastros"]
    Click Element    xpath=//*[@id="Centro de Custo"]
    Wait Until Element Is Visible    xpath=/html/body/div/div/div[2]/div[2]/div
    Scroll Element Into View         xpath=/html/body/div/div/div[2]/div[2]/div
    Wait Until Element Is Visible    xpath=//p[text()='Vendas']/following-sibling::div/button[text()='Editar']  
    Click Element    xpath=//p[text()='Vendas']/following-sibling::div/button[text()='Editar']  
    Click Element    xpath=//*[@id="Diretoria"] 
    Click Element    xpath=//*[@id="Diretoria"]/option[2]
    Click Element    xpath=//*[@id="cancel"]
    