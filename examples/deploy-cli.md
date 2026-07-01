# Exemplo de Deploy via AWS CLI

## Visão geral

Este documento apresenta exemplos práticos de como realizar o deploy de infraestrutura AWS CloudFormation utilizando a AWS CLI.

O objetivo é demonstrar como os templates deste projeto podem ser executados fora de pipelines CI/CD, diretamente por linha de comando.

---

# Pré-requisitos

Antes de executar qualquer comando, é necessário garantir:

## 1. AWS CLI instalada

```bash
aws --version
```

---

## 2. Credenciais configuradas

```bash
aws configure
```

Parâmetros:

- AWS Access Key
- AWS Secret Key
- Região (ex: us-east-1)
- Output format (json)

---

## 3. Permissões IAM

O usuário ou role deve ter permissões para:

- cloudformation:*
- ec2:*
- iam:*
- s3:*

---

# Estrutura do projeto

Exemplo de estrutura utilizada:

```
templates/
  main.yaml
  iam-role.yaml
  security-group.yaml
```

---

# 1. Validação do template

Antes do deploy, sempre validar:

```bash
aws cloudformation validate-template \
  --template-body file://templates/main.yaml
```

---

# 2. Criar uma Stack

## Comando básico

```bash
aws cloudformation create-stack \
  --stack-name my-lab-stack \
  --template-body file://templates/main.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

---

## Explicação dos parâmetros

- `--stack-name` → nome da Stack
- `--template-body` → caminho do template
- `--capabilities` → necessário quando há criação de IAM Roles

---

# 3. Acompanhar criação da Stack

## Ver status geral

```bash
aws cloudformation describe-stacks \
  --stack-name my-lab-stack
```

---

## Ver eventos detalhados

```bash
aws cloudformation describe-stack-events \
  --stack-name my-lab-stack
```

---

# 4. Atualizar uma Stack

Quando o template for modificado:

```bash
aws cloudformation update-stack \
  --stack-name my-lab-stack \
  --template-body file://templates/main.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

---

# 5. Usar Change Set (recomendado)

## Criar Change Set

```bash
aws cloudformation create-change-set \
  --stack-name my-lab-stack \
  --change-set-name update-v1 \
  --template-body file://templates/main.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

---

## Descrever Change Set

```bash
aws cloudformation describe-change-set \
  --stack-name my-lab-stack \
  --change-set-name update-v1
```

---

## Executar Change Set

```bash
aws cloudformation execute-change-set \
  --stack-name my-lab-stack \
  --change-set-name update-v1
```

---

# 6. Obter outputs da Stack

```bash
aws cloudformation describe-stacks \
  --stack-name my-lab-stack \
  --query "Stacks[0].Outputs"
```

---

# 7. Deletar a Stack

## Remoção completa da infraestrutura

```bash
aws cloudformation delete-stack \
  --stack-name my-lab-stack
```

---

## Acompanhar exclusão

```bash
aws cloudformation describe-stack-events \
  --stack-name my-lab-stack
```

---

# 8. Verificar drift (opcional)

## Detectar drift

```bash
aws cloudformation detect-stack-drift \
  --stack-name my-lab-stack
```

---

## Consultar resultados

```bash
aws cloudformation describe-stack-resource-drifts \
  --stack-name my-lab-stack
```

---

# 9. Boas práticas ao usar CLI

## Sempre:

- validar o template antes do deploy
- usar `Change Sets` em produção
- acompanhar eventos da Stack
- versionar templates no Git
- usar IAM Roles ao invés de credenciais fixas

---

## Evitar:

- deploy direto sem validação
- mudanças manuais no console AWS
- uso de credenciais hardcoded
- ausência de logs de execução

---

# 10. Fluxo completo recomendado

```mermaid
flowchart TD

A[Editar Template]

--> B[Validate Template]

--> C[Create Change Set]

--> D[Review Changes]

--> E[Execute Change Set]

--> F[Monitor Stack]

--> G[Delete Stack (opcional)]
```

---

# Conclusão

A AWS CLI é uma ferramenta poderosa para gerenciamento direto de infraestrutura CloudFormation.

Quando combinada com boas práticas, ela permite:

- automação total;
- controle granular;
- integração com scripts e pipelines;
- execução manual controlada.

---

# Encerramento

Este exemplo demonstra como o CloudFormation pode ser utilizado de forma prática fora de pipelines CI/CD, permitindo controle total da infraestrutura via linha de comando.

---

# Projeto

**Implementando Infraestrutura Automatizada com AWS CloudFormation**

---

# Autor

Sérgio Luiz dos Santos  
GitHub: https://github.com/Santosdevbjj

---

# Status

Exemplo prático de execução via AWS CLI
