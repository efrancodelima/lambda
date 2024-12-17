#!/bin/bash

# Inicia o script
echo "Importação de recursos iniciada."

# Função para importar os recursos passando os parâmetros necessários
import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  echo " "

  terraform import \
  -var="aws_account_id=${ACCOUNT_ID}" \
  "$resource_type.$resource_name" "$resource_id" \
  || echo "Erro ao importar o recurso, continuando..."
}

# Importa o user pool
USER_POLL_ID=$(aws cognito-idp list-user-pools --max-results 5 --query "UserPools[?Name=='lanchonete-user-pool'].Id" --output text 2>/dev/null)

if [ -z "${USER_POLL_ID}" ]; then
    echo " "
    echo "User pool não encontrado."
else
    import_resource "aws_cognito_user_pool" "lanchonete-user-pool" ${USER_POLL_ID}
fi

# Importa o client do user pool
UP_CLIENT_NAME="lanchonete-up-client"
UP_CLIENT_ID=$(aws cognito-idp list-user-pool-clients --user-pool-id ${USER_POLL_ID} --query "UserPoolClients[?ClientName=='${UP_CLIENT_NAME}'].ClientId" --output text 2>/dev/null)

if [ -z "${USER_POLL_ID}" -o -z "${UP_CLIENT_ID}" ]; then
    echo " "
    echo "Client do user pool não encontrado."
else
    import_resource "aws_cognito_user_pool_client" "tf_up_client" ${USER_POLL_ID}/${UP_CLIENT_ID}
fi

# Importa o domain do user pool
UP_DOMAIN="us-east-1-up-domain"

if [ -z "${USER_POLL_ID}" ]; then
    echo " "
    echo "Domain do user pool não encontrado."
else
    import_resource "aws_cognito_user_pool_domain" "tf_up_domain" ${UP_DOMAIN}
fi

# Encerra o script
echo "Importação de recursos finalizada!"
echo " "
