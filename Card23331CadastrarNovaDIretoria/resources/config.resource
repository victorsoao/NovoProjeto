*** Variables ***
${BASE_URL}                  https://api-supernatural.qacoders.dev.br/api  
${ADMIN_EMAIL}               sysadmin@qacoders.com
${ADMIN_PASSWORD}            1234@Test
${CHARS_COM_ACENTOS}         abcdefghijklmnopqrstuvwxyzáàâãéèêíïóôõöúç

${MSG_ERRO_DUPLICADO}        Não é possível salvar esse registro. Diretoria já cadastrada no sistema.
${MSG_ERRO_OBRIGATORIO}      O campo 'diretoria' é obrigatório.
${MSG_ERRO_MIN_CHARS}        O nome da diretoria deve ter no mínimo 2 caracteres.
${MSG_ERRO_MAX_CHARS}        O campo 'diretoria' deve possuir no máximo 50 caracteres.
${MSG_ERRO_CHARS_INVALIDOS}  O campo 'diretoria' só pode conter letras e o caractere especial '&'.
${MSG_ERRO_VINCULO}          Não é possível inativar a Diretoria. Essa Diretoria faz parte de um cadastro ativo.
${MSG_ERRO_NAO_ENCONTRADO}   Cadastro não encontrado
${MSG_ERRO_JA_INATIVO}       Ao escolher inativar, não será mais possível utilizar essa Diretoria. Deseja realmente inativar?