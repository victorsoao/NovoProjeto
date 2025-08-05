*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         String

Resource        ../resources/config.resource
Resource        ../resources/auth.resource
Resource        ../resources/diretoria.resource

Test Setup      Realizar Login e Salvar Token


*** Test Cases ***
# ==================================================================================================
#            --- Testes de (POST) ---
# ==================================================================================================

CT01: Cadastrar diretoria
    [Tags]     POST    smoke
    ${nome_randomico}=           Generate Random String    10    [LOWER]
    ${nome_base}=                Set Variable              E${nome_randomico}
    ${body}=                     Create Dictionary         name=${nome_randomico}
    ${resp}=                     Cadastrar nova diretoria    ${nome_randomico}
    Status Should Be             201                       ${resp}
    Dictionary Should Contain Key     ${resp.json()}     newBoard
    Dictionary Should Contain Key   ${resp.json()}[newBoard]    _id
    Should Be Equal As Strings      ${resp.json()}[newBoard][boardName]    ${nome_randomico}
CT02: Cadastrar diretoria com nome usando &
    [Tags]     POST    regression
    ${nome1_randomico}=          Generate Random String    8    [LOWER]
    ${nome1_base}=               Set Variable              E${nome1_randomico}
    ${nome2_base}=               Generate Random String    8    [LOWER]
    ${nome_composto_completo}=   Set Variable              ${nome1_base} & ${nome2_base}
    ${body}=                     Create Dictionary         name=${nome_composto_completo}
    ${resp}=                     Cadastrar nova diretoria    ${nome_composto_completo}
    Status Should Be             201                       ${resp}
    Dictionary Should Contain Key     ${resp.json()}     newBoard
    Dictionary Should Contain Key   ${resp.json()}[newBoard]    _id
    Should Be Equal As Strings      ${resp.json()}[newBoard][boardName]    ${nome_composto_completo}

CT03: Cadastrar diretoria com acentos
    [Tags]     POST    regression
    ${nome_com_acento_base}=     Generate Random String    12    chars=${CHARS_COM_ACENTOS}
    ${nome_prefixado_com_acento}=  Set Variable              E${nome_com_acento_base}
    ${body}=                     Create Dictionary         name=${nome_prefixado_com_acento}
    ${resp}=                     Cadastrar nova diretoria    ${nome_prefixado_com_acento}
    Status Should Be             201                       ${resp}
    Dictionary Should Contain Key     ${resp.json()}     newBoard
    Dictionary Should Contain Key   ${resp.json()}[newBoard]    _id
    Should Be Equal As Strings      ${resp.json()}[newBoard][boardName]    ${nome_prefixado_com_acento}

CT04: Não permitir cadastrar diretoria com nome abaixo do limite minimo (1 caractere)  # está com BUG
    [Tags]     POST    negative    
    ${letra_aleatoria}=          Generate Random String    1    [UPPER]
    ${letra_maiscurta}=           Set Variable              ${letra_aleatoria}
    ${body}=                     Create Dictionary         name=${letra_aleatoria}
    ${resp_erro}=                Cadastrar nova diretoria    ${letra_aleatoria}   
    Status Should Be             400                       ${resp_erro}
    Should Contain               ${resp_erro.json()}[error][0]     ${MSG_ERRO_MIN_CHARS}

CT05: Não permitir cadastrar diretoria com nome acima do limite maximo (51 caracteres)
    [Tags]     POST    negative    
    ${parte_randomica}=          Generate Random String    50    [LOWER]
    ${nome_longo_final}=         Set Variable              E${parte_randomica}
    ${body}=                     Create Dictionary         name=${nome_longo_final}
    ${resp_erro}=                Cadastrar nova diretoria    ${nome_longo_final}  
    Status Should Be             400                       ${resp_erro}
    Should Contain               ${resp_erro.json()}[error][0]     ${MSG_ERRO_MAX_CHARS}

CT06: Não permitir cadastrar diretoria com nome duplicado
    [Tags]     POST    negative
    ${parte_randomica}=          Generate Random String    15    [LOWER]
    ${nome_duplicado_com_prefixo}=  Set Variable              E${parte_randomica}
    ${body_valido}=              Create Dictionary         name=${nome_duplicado_com_prefixo}
                        Cadastrar nova diretoria    ${nome_duplicado_com_prefixo}
    ${body_duplicado}=           Create Dictionary         name=${nome_duplicado_com_prefixo}
    ${resp_alert}=               Cadastrar nova diretoria    ${nome_duplicado_com_prefixo}    
    Status Should Be             409                       ${resp_alert}
    Should Contain               ${resp_alert.json()}[alert][0]     ${MSG_ERRO_DUPLICADO}

CT07: Não permitir cadastrar diretoria com nome vazio
    [Tags]     POST    negative
    ${body}=                     Create Dictionary         name=${EMPTY}
    ${resp_erro}=                Cadastrar nova diretoria    ${EMPTY}   
    Status Should Be             400                       ${resp_erro}
    Should Contain               ${resp_erro.json()}[error][0]    O campo 'diretoria' é obrigatório.

CT08: Não permitir cadastro de diretoria com caracteres especiais inválidos
    [Tags]    POST    negative
   @{caracteres_invalidos}=    Create List    \#    $    %    * (    )    -    +    =    [    ]    {    }    
                  ...    |    ;    :    "   '    <    >    ,    .    /    ?    @    !    ~    `    ^
    
    FOR    ${caractere}    IN    @{caracteres_invalidos}
        ${nome_invalido}=    Generate Random String    10    [LOWER]
        ${nome_invalido_final}=    Set Variable    E${caractere}${nome_invalido}        
        ${resp_erro}=    Cadastrar nova diretoria    ${nome_invalido_final}
        Status Should Be    400    ${resp_erro}
        Should Contain    ${resp_erro.json()}[error][0]    ${MSG_ERRO_CHARS_INVALIDOS}
    END
CT08: Nao permitir cadastrar diretoria com caracteres especiais invalidos
    [Tags]     POST    negative
    ${nome_invalido}=            Set Variable              Diretoria @#$%
    ${body}=                     Create Dictionary         name=${nome_invalido}
    ${resp_erro}=                Cadastrar nova diretoria    ${nome_invalido}   
    Status Should Be             400                       ${resp_erro}
    Should Contain               ${resp_erro.json()}[error][0]     ${MSG_ERRO_CHARS_INVALIDOS}

# ==================================================================================================
#            ---  Testes de (GET) ---
# ==================================================================================================

CT09: Consultar a lista de diretorias
    [Tags]    GET    smoke
    ${resp}=    Consultar diretorias
    Status Should Be    200    ${resp}

CT10: Consultar contagem de diretorias com sucesso
    [Tags]     GET    count    smoke
    ${resp}=   Contar Diretorias
    Status Should Be    200    ${resp}

CT11: Consultar diretoria pelo seu ID
    [Tags]     GET    smoke    ponta-a-ponta
    ${nome_aleatorio}=           Generate Random String    15    [LOWER]
    ${nome_para_criar}=          Set Variable              E${nome_aleatorio}
    ${resp_cadastro}=            diretoria.Cadastrar nova diretoria    ${nome_para_criar}
    ${id_criado}=                Set Variable              ${resp_cadastro.json()}[newBoard][_id]    
    ${resp_por_id}=              Consultar diretoria por id    ${id_criado}
    Status Should Be             200                       ${resp_por_id}
    Should Be Equal As Strings    ${resp_por_id.json()}[board][_id]    ${id_criado}
    Should Be Equal As Strings    ${resp_por_id.json()}[board][boardName]   ${nome_para_criar}
    
# ==================================================================================================
#            --- Testes de Edição (PUT) ---
# ==================================================================================================

CT12: Editar o nome de uma diretoria com sucesso   
    [Tags]     PUT    smoke
    ${nome_antigo_aleatorio}=    Generate Random String    20    [LOWER]
    ${nome_antigo_final}=        Set Variable              E${nome_antigo_aleatorio}
    ${resp_cadastro}=            Cadastrar nova diretoria    ${nome_antigo_final}
    ${id}=                       Set Variable              ${resp_cadastro.json()}[newBoard][_id] 
    ${nome_novo_aleatorio}=      Generate Random String    20    [LOWER]
    ${nome_novo_final}=          Set Variable              E${nome_novo_aleatorio}
    ${resp_edicao}=              Editar diretoria          ${id}  ${nome_novo_final}
    Status Should Be             200                       ${resp_edicao}
    Should Contain               ${resp_edicao.text}       Cadastro atualizado com sucesso.

CT13: Não permitir editar o nome para um ja existente  
    [Tags]     PUT    negative
    ${nome_a}=                   Generate Random String    15    [LOWER]
    ${nome_a_final}=             Set Variable              A${nome_a}
    ${resp_a}=                   diretoria.Cadastrar nova diretoria    ${nome_a_final}
    ${id_a}=                     Set Variable              ${resp_a.json()}[newBoard][_id] 
    ${nome_b}=                   Generate Random String    15    [LOWER]
    ${nome_b_final}=             Set Variable              B${nome_b}
    diretoria.Cadastrar nova diretoria    ${nome_b_final}
    ${resp_edicao}=              Editar diretoria          ${id_a}    ${nome_b_final}   
    Status Should Be             409                       ${resp_edicao}
    Should Contain               ${resp_edicao.json()}[alert][0]     Não é possível salvar esse registro. Diretoria já cadastrada no sistema.

CT14: Nao permitir editar o nome para vazio
    [Tags]     PUT    negative
    ${nome}=                     Generate Random String    15    [LOWER]
    ${resp_cadastro}=            Cadastrar nova diretoria    ${nome}
    ${id}=                       Set Variable              ${resp_cadastro.json()}[newBoard][_id]
    ${resp_edicao}=              Editar diretoria          ${id}    ${EMPTY}    
    Status Should Be             400                       ${resp_edicao}
    Should Contain               ${resp_edicao.json()}[error][0]     ${MSG_ERRO_OBRIGATORIO}
