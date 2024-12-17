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

# Importa o security group
SG_NAME="lanchonete-api-sg"
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME}" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)

if [ "${SG_ID}" = "None" ]; then
    echo " "
    echo "Security group do service ECS não encontrado."
else
    import_resource "aws_security_group" "tf_api_sg" "${SG_ID}"
fi

# Importa a VPC link
VPC_LINK_NAME="lanchonete-vpc-link"
VPC_LINK_ID=$(aws apigatewayv2 get-vpc-links --query "Items[?Name == '${VPC_LINK_NAME}'] | [0].VpcLinkId" --output text 2>/dev/null)

if [ "${VPC_LINK_ID}" = "None" ]; then
    echo " "
    echo "VPC Link não encontrado."
else
    import_resource "aws_apigatewayv2_vpc_link" "tf_vpc_link" ${VPC_LINK_ID}
fi

# Importa o API gateway
API_GATEWAY_NAME="lanchonete-api-gateway"
API_GATEWAY_ID=$(aws apigatewayv2 get-apis --query "Items[?Name == '${API_GATEWAY_NAME}'] | [0].ApiId" --output text 2>/dev/null)

if [ "${API_GATEWAY_ID}" = "None" ]; then
    echo " "
    echo "API gateway não encontrado."
else
    import_resource "aws_apigatewayv2_api" "tf_api_gateway" ${API_GATEWAY_ID}
fi

# Importa o stage do API gateway
STAGE_NAME="\$default"

if [ "${API_GATEWAY_ID}" = "None" ]; then
    echo " "
    echo "Stage do API gateway não encontrado."
else
    import_resource "aws_apigatewayv2_stage" "tf_api_stage" ${API_GATEWAY_ID}/${STAGE_NAME}
fi

# Importa a integration do API gateway
INTEGRATION_ID=$(aws apigatewayv2 get-integrations --api-id ${API_GATEWAY_ID} --query "Items[0].IntegrationId" --output text 2>/dev/null)

if [ "${API_GATEWAY_ID}" = "None" ] || [ "${INTEGRATION_ID}" = "None" ]; then
    echo " "
    echo "Integration do API gateway não encontrado."
else
    import_resource "aws_apigatewayv2_integration" "tf_api_integration" ${API_GATEWAY_ID}/${INTEGRATION_ID}
fi

# Importa o Authorizer do API gateway
AUTHORIZER_ID=$(aws apigatewayv2 get-authorizers --api-id ${API_GATEWAY_ID} --query 'Items[0].AuthorizerId' --output text 2>/dev/null)

if [ "${API_GATEWAY_ID}" = "None" ] || [ "${AUTHORIZER_ID}" = "None" ]; then
    echo " "
    echo "Authorizer do API gateway não encontrado."
else
    import_resource "aws_apigatewayv2_authorizer" "tf_api_authorizer" ${API_GATEWAY_ID}/${AUTHORIZER_ID}
fi

# Importa a route do API gateway
ROUTE_ID=$(aws apigatewayv2 get-routes --api-id ${API_GATEWAY_ID} --query "Items[0].RouteId" --output text 2>/dev/null)

if [ "${API_GATEWAY_ID}" = "None" ] || [ "${ROUTE_ID}" = "None" ]; then
    echo " "
    echo "Route do API gateway não encontrado."
else
    import_resource "aws_apigatewayv2_route" "tf_api_route" ${API_GATEWAY_ID}/${ROUTE_ID}
fi

# Encerra o script
echo "Importação de recursos finalizada!"
echo " "
