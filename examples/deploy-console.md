# Exemplo de Deploy via AWS Console (CloudFormation)

## Visão geral

Este documento demonstra como realizar o deploy de uma infraestrutura AWS CloudFormation utilizando a interface gráfica (AWS Management Console).

Embora o uso de CLI e CI/CD seja recomendado em ambientes modernos, o Console ainda é amplamente utilizado para:

- testes rápidos;
- validação de templates;
- troubleshooting;
- ambientes educacionais;
- análise de stacks existentes.

---

# Acesso ao CloudFormation

## Passo 1: Login na AWS

Acesse o console:

https://console.aws.amazon.com/

Faça login com sua conta AWS.

---

## Passo 2: Acessar o serviço CloudFormation

No campo de busca:

```
CloudFormation
```

Clique no serviço **CloudFormation**.

---

# Criando uma Stack

## Passo 3: Iniciar criação

Clique em:

```
Create stack → With new resources (standard)
```

---

## Passo 4: Selecionar template

Você pode escolher uma das opções:

### Opção 1: Upload de arquivo

- selecione **Upload a template file**
- envie o arquivo YAML do projeto (ex: `main.yaml`)

---

### Opção 2: S3 URL

- informe o link de um template hospedado no S3

---

### Opção 3: Editor direto

- cole o conteúdo do template no editor inline

---

# Configuração da Stack

## Passo 5: Nome da Stack

Defina um nome:

```
my-lab-stack
```

---

## Passo 6: Parâmetros

Se o template possuir parâmetros, configure:

- Environment (dev/prod)
- InstanceType
- CIDR blocks
- nomes de recursos

---

## Passo 7: Capabilities

Marque a opção:

```
I acknowledge that AWS CloudFormation might create IAM resources
```

Essa etapa é obrigatória quando o template cria:

- IAM Roles
- Policies
- Instance Profiles

---

# Configurações avançadas

## Tags

Recomenda-se adicionar tags:

- Project: CloudFormation-Lab
- Environment: Dev
- Owner: DevOps-Team

---

## Stack policies (opcional)

Permite proteger recursos críticos contra alterações acidentais.

---

# Revisão

## Passo 8: Review

Revise:

- nome da Stack
- parâmetros
- permissões
- template selecionado

Clique em:

```
Create stack
```

---

# Monitoramento da Stack

Após iniciar o deploy, você será redirecionado para a Stack.

## Aba Events

Mostra o progresso detalhado:

- CREATE_IN_PROGRESS
- CREATE_COMPLETE
- ROLLBACK_IN_PROGRESS (em caso de erro)

---

## Aba Resources

Lista todos os recursos criados:

- EC2
- VPC
- Security Groups
- IAM Roles

---

## Aba Outputs

Exibe valores exportados pelo template:

- IP público
- IDs de recursos
- endpoints

---

# Atualizando uma Stack

## Passo 9: Update Stack

Clique em:

```
Update
```

Depois:

- selecione novo template
- ou edite parâmetros

Clique em:

```
Next → Update stack
```

---

# Deletando uma Stack

## Passo 10: Delete

Para remover toda infraestrutura:

1. selecione a Stack
2. clique em **Delete**
3. confirme a ação

O CloudFormation irá remover todos os recursos automaticamente.

---

# Erros comuns no Console

## 1. Falta de permissão IAM

Erro ao criar recursos devido a políticas insuficientes.

---

## 2. Falta de capabilities

IAM resources não podem ser criados sem marcar a opção de acknowledgment.

---

## 3. Template inválido

Erros de sintaxe YAML ou JSON.

---

## 4. Recursos já existentes

Conflito de nomes globais (ex: S3 bucket).

---

# Quando usar o Console

O Console é recomendado para:

- testes rápidos;
- visualização de stacks;
- debugging de erros;
- aprendizado inicial;
- inspeção manual de recursos.

---

# Quando NÃO usar o Console

Evitar o Console em:

- ambientes de produção;
- pipelines CI/CD;
- infraestrutura crítica;
- processos repetitivos.

---

# Comparação com CLI

| Console | CLI |
|---------|-----|
| Manual | Automatizado |
| Visual | Scriptável |
| Lento | Rápido |
| Bom para aprendizado | Bom para produção |

---

# Conclusão

O AWS Console é uma ferramenta essencial para aprendizado e inspeção visual de infraestrutura CloudFormation.

No entanto, em ambientes modernos, ele deve ser complementar ao uso de:

- AWS CLI
- GitHub Actions
- Infrastructure as Code

---

# Encerramento

Este exemplo demonstra o fluxo completo de criação e gerenciamento de uma Stack utilizando a interface gráfica da AWS.

---

# Projeto

**Implementando Infraestrutura Automatizada com AWS CloudFormation**

---

# Autor

Sérgio Luiz dos Santos  
GitHub: https://github.com/Santosdevbjj

---

# Status

Exemplo prático de deploy via AWS Console
