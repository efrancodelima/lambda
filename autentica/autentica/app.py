import json
import requests

def lambda_handler(event, context):
    request = event.get('request', {})
    user_attributes = request.get('userAttributes', {})
    cpf_cliente = user_attributes.get('custom:cpfCliente')
    
    url = "http://internal-lanchonete-load-balancer-1314031809.us-east-1.elb.amazonaws.com:8080/clientes/buscar/" + cpf_cliente
    print(url)
    
    headers = {
        'Content-Type': 'application/json'
    }
    
    response = "None"

    try:
        response = requests.get(url, headers=headers)
    except Exception as e:
        raise Exception("Erro ao verificar o CPF do cliente.")
    
    if response.status_code == 200:
        return event
    else:
        raise Exception("O usuário não é cliente da rede.")