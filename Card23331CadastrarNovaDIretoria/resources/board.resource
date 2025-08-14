*** Settings ***
Resource          ../resources/config.resource
Library           SeleniumLibrary

*** Keywords ***
Abrir Navegador 
    Open Browser        browser=firefox
    Maximize Browser Window
    Go To    url=${BASE_URL}
    Input Text        locator=//*[@id="email"]    text=${ADMIN_EMAIL}
    Input Text        locator=//*[@id="password"]    text=${ADMIN_PASSWORD}
    Click Button                            //*[@id="login"]
    Close Browser
