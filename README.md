# Tech Challenge - Fase 3

Projeto realizado como atividade avaliativa do curso de **Software Architecture - Pós-Tech - FIAP**.

Link do projeto no GitHub:

- Aplicação: https://github.com/efrancodelima/application
- Infra kubernetes: https://github.com/efrancodelima/infra-k8s
- Infra do banco de dados: https://github.com/efrancodelima/infra-bd
- Function AWS Lambda: https://github.com/efrancodelima/lambda

# Índice

- [Objetivos](#objetivos)
- [Requisitos](#requisitos)
  - [API Web](#api-web)
  - [Arquitetura](#arquitetura)
  - [Pipeline](#pipeline)
- [Aplicação](#aplicação)
  - [Instrução para rodar a aplicação](#instrução-para-rodar-a-aplicação)
- [Banco de dados](#banco-de-dados)
  - [Escolha e justificativa](#escolha-e-justificativa)
  - [Documentação](#documentação)
    - [Modelo conceitual](#modelo-conceitual)
    - [Modelo lógico](#modelo-lógico)
- [Infra kubernetes](#infra-kubernetes)
- [Função lambda](#função-lambda)

## Objetivos

Desenvolver um sistema para uma lanchonete local em fase de expansão. O sistema deverá realizar o controle dos pedidos, além de outras funções correlatas, conforme especificado no Tech Challenge.

## Requisitos

### API Web

A aplicação deverá oferecer a seguinte API web para consumo:

Cliente

- Cadastrar cliente
- Buscar cliente pelo CPF

Produto:

- Criar, editar e remover produtos
- Buscar produtos por categoria

Pedido

- Fazer checkout
- Deverá retornar a identificação do pedido
- Atualizar o status do pedido
- Consultar o status do pagamento
- Listar pedidos nessa ordem: Pronto > Em Preparação > Recebido
- Pedidos mais antigos primeiro e mais novos depois.
- Pedidos finalizados não devem aparecer na lista.

### Arquitetura

Arquitetura do software: utilizar a Clean Architecture.

Arquitetura da infra: utilizar o kubernetes para rodar a aplicação, que deverá rodar na nuvem utilizando os serviços serverless.
O banco de dados do projeto deverá ser uma solução oferecida pela nuvem escolhida.

### Pipeline

O projeto foi dividido em 4 partes:

- uma função lambda para a autenticação do usuário
- uma aplicação com as regras de negócio
- a infraestrutura kubernetes para a aplicação
- a infraestrutura para o banco de dados

Cada parte tem um repositório separado no GitHub, conforme mencionado no início deste documento, e todos os repositórios necessitam pull request para realizar qualquer tipo de alteração na branch main. As branchs main/master devem estar protegidas de forma a não permitir commits diretos.

Cada repositório deverá acionar o respectivo pipeline sempre que a branch main for alterada, realizando o deploy na nuvem escolhida.

## Aplicação

A aplicação não mudou em relação à fase anterior, mas foi criada uma pipeline que antes não existia.

Essa pipeline compila o projeto em um arquivo jar, executa os testes, compila o projeto em uma imagem docker, faz o login/push/logout na AWS ECR e por fim o deploy na infra kubernetes. O logout é feito sempre que o login for bem sucedido, mesmo que o push falhe.

O push é feito duas vezes, uma com a tag igual à versão do projeto e outra com a tag latest. O repositório ECR é do tipo mutável, já que a tag latest precisa ser substituída a cada nova versão, mas na pipeline foi adicionado um script bash que impede que o primeiro push substitua uma versão já existente do projeto. Exemplificando: se já existe uma imagem com a tag "2.0.5" no ECR, a pipeline não permite subir outra imagem com a mesma tag; mas a tag latest ela permite subir quantas vezes for necessário.

### Instrução para rodar a aplicação

Primeiro, é necessário fazer o deploy, nessa ordem, da infra do banco de dados, da infra kubernetes, da aplicação e, por fim, da lambda.

Sugestão de ordem para execução das APIs:

- Cadastrar cliente
- Buscar cliente pelo CPF
- Cadastrar produtos
- Editar produto
- Buscar produtos por categoria
- Remover produtos (não remova todos, deixe pelo menos 1)
- Fazer checkout
- Consultar o status do pagamento
- Mock da notificação do Mercado Pago \*
- Atualizar o status do pedido
- Listar pedidos

O status do pedido muda em uma ordem definida: recebido, em preparação, pronto, finalizado. Mas ele não avança se o pedido não tiver o pagamento aprovado, então é necessário realizar o mock da notificação do Mercado Pago antes de atualizar o status do pedido.

Exemplo de mock para a notificação do Mercado Pago usando o curl (você pode usar o Postman também, se preferir).

```
curl -X PUT <URL>/api/v2/pedidos/webhook/ \
-H "Content-Type: application/json" \
-d '{
"id": 1,
"date_created": "2024-09-30T11:26:38.000Z",
"date_approved": "2024-09-30T11:26:38.000Z",
"date_last_updated": "2024-09-30T11:26:38.000Z",
"money_release_date": "2017-09-30T11:22:14.000Z",
"payment_method_id": "Pix",
"payment_type_id": "credit_card",
"status": "approved",
"status_detail": "accredited",
"currency_id": "BRL",
"description": "Pago Pizza",
"collector_id": 2,
"payer": {
  "id": 123,
  "email": "test_user_80507629@testuser.com",
  "identification": {
	"type": "CPF",
	"number": 19119119100
  },
  "type": "customer"
},
"metadata": {},
"additional_info": {},
"external_reference": "MP0001",
"transaction_amount": 250,
"transaction_amount_refunded": 50,
"coupon_amount": 15,
"transaction_details": {
  "net_received_amount": 250,
  "total_paid_amount": 250,
  "overpaid_amount": 0,
  "installment_amount": 250
},
"installments": 1,
"card": {}
}'
```

## Banco de dados

### Escolha e justificativa

Escolhemos trabalhar com o modelo relacional, principalmente pela consistência e integridade dos dados, características fundamentais para um controle preciso dos pedidos e dos pagamentos da lanchonete.

Outra vantagem do modelo relacional é a sua maturidade: o modelo foi proposto em 1970 por Edgar F. Codd e desde então passou por diversas melhorias. Por estar há bastante tempo no mercado, é o modelo mais conhecido pelos profissionais de TI, sendo mais fácil encontrar mão de obra especializada para suporte e manutenção.

O SGBD escolhido foi o Amazon Aurora (engine MySQL). Como a aplicação também está rodando na nuvem da AWS, vamos aproveitar a sinergia de usar um pacote de soluções do mesmo desenvolvedor. O Aurora possui desempenho suficiente para atender às necessidades do projeto, oferece escalabilidade sob demanda (cobrando apenas pelo que foi usado), alta disponibilidade, gerenciamento automático de instâncias, backups automáticos, cache de dados em memória RAM (InnoDB Buffer Pool) e diversas outras ferramentas que funcionam de forma transparente ao profissional de TI, diminuindo muito a carga de trabalho do administrador do banco de dados.

### Documentação

#### Modelo conceitual

Utilizamos o Diagrama Entidade Relacionamento (DER) para representar o modelo conceitual do nosso banco de dados.

Esse diagrama está mais próximo da visão do usuário do sistema e mais distante da implementação de fato (modelo físico).

O diagrama abaixo foi feito utilizando o software brModelo.

![Diagrama Entidade Relacionamento representando o Modelo Conceitual do banco de dados](./assets/modelo-conceitual.png)

Alguns pontos a destacar nesse diagrama:

- um pedido pode não ter um cliente (cliente não se identifica), por isso a cardinalidade mínima do lado cliente é zero;
- nome e e-mail do cliente são atributos opcionais, mas, pelo menos, um deles precisa ser preenchido. O brModelo não tem uma funcionalidade específica para anotar esse tipo de situação: "os campos podem ser nulos, mas não ambos";
- o brModelo também não tem a opção de linha dupla para as entidades com participação obrigatória no relacionamento, mas isso pode ser facilmente deduzido pela cardinalidade;
- o timestamp do checkout poderia ser um atributo opcional, indicando, quando ausente, que o checkout não foi realizado. No nosso caso, como o pedido só é gravado no banco de dados quando o cliente faz o checkout, faz mais sentido deixá-lo como atributo obrigatório mesmo;
- na entidade Pedido, o timestamp do status e o timestamp do checkout podem ser usados para acompanhar o tempo de espera do pedido. Poderíamos também ter feito uma entidade "Histórico do pedido" registrando o avanço do pedido em cada etapa. Tem várias formas de modelar uma solução, nós optamos pela forma mais simples dentre aquelas que atendem aos requisitos do projeto;
- Categoria do produto, pagamento do pedido e status do pedido: os três poderiam ser atributos ou entidades. A definição do que é uma entidade e do que é um atributo varia muito segundo a visão de quem modela, mas observando que "o modelo conceitual deve ser estar próximo da visão do usuário", escolhi deixar apenas o status do pedido como atributo.

#### Modelo lógico

No modelo lógico utilizamos a notação de Chen, também conhecida como "notação pé de galinha".

O diagrama abaixo foi criado com o MySQL BenchMark.

As principais mudanças são:

- a entidade Categoria do modelo anterior virou um campo do tipo "enum". Como temos poucas categorias, o enum permite ter um ganho de desempenho nas consultas e escritas do banco de dados, além de simplificar o esquema.
- a entidade Pagamento foi incorporada pela entidade pedido. Como o relacionamento era 1 para 1, não faz sentido ter tabelas separadas.

![Diagrama do Modelo Lógico do banco de dados](./assets/modelo-logico.png)

Na tabela "itens_pedido" a chave primária é composta pelas chaves primárias de pedido e produto, por isso as chaves aparecem em vermelho.

## Infra kubernetes

A infra está rodando em um cluster ECS. Esse cluster roda apenas em subnets privadas e não tem um IP público atribuído, sendo acessado por um API Gateway (que exige autenticação).

Os recursos foram criados mais ou menos nessa ordem, respeitando as dependências entre eles (cláusula depends_on):

- os securities groups do cluster ECS e do load balancer;
- as roles da task e da task execution;
- as policies attachments (políticas associadas às roles);
- o cluster ECS;
  - o service do cluster ECS;
- a task definition;
- o load balancer;
  - o target group do load balancer;
  - o listener do load balancer;
- o VPC link
- o API Gateway;
  - o stage do API Gateway;
  - a integration do API Gateway;
  - o authorizer do API Gateway;
  - a route do API Gateway.

Todos os recursos foram definidos com o Terraform, que tenta importar os recursos da AWS para a VM do GitHub Actions (que é onde a pipeline roda) antes de executar o "plan" e o "apply". Então, se o recurso não existe, ele cria; se já existe, ele atualiza. Ao final da pipeline, ele imprime no console o link direto para a aplicação usando um output do terraform.

## Função lambda

Essa função é acionada durante o login do usuário e verifica se o CPF do usuário está cadastrado no banco de dados. Se estiver: ok, login realizado com sucesso; se não estiver é exibida uma mensagem informando o erro da falha no login.

Cadastrei 2 usuários de exemplo no user pool, o primeiro é cliente cadastrado no banco de dados da lanchonete e o segundo, não:

- Usuário: carlos | Senha: Teste@123
- Usuário: helena | Senha: Teste@123
