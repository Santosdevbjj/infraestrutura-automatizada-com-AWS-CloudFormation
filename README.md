## Formação AWS Cloud Foundations.

<img width="105" height="120" alt="1000127839" src="https://github.com/user-attachments/assets/0ee2a9bf-ce01-4d91-b549-d2f1f4fcff0b" />


## DESCRIÇÃO:

Explore a automação de infraestrutura como código (IaC), utilizando templates em JSON ou YAML para criação, configuração e gerenciamento de recursos na AWS. A atividade desafia os participantes a aplicar conceitos de padronização, replicação e segurança na infraestrutura em nuvem, simulando cenários reais de provisionamento automatizado.


---


## Problema de Negócio

Empresas que criam infraestrutura manualmente enfrentam problemas como:

ambientes inconsistentes;

erros humanos;

demora no provisionamento;

dificuldade para reproduzir ambientes;

ausência de padronização;

riscos de segurança;

baixa rastreabilidade.


CloudFormation resolve exatamente esse problema.

Portanto o projeto não será sobre "criar uma Stack".

Será sobre

> Como eliminar a criação manual de infraestrutura utilizando Infrastructure as Code.



Isso muda completamente o nível do README.


---

Estrutura profissional do repositório

```

infraestrutura-automatizada-com-AWS-CloudFormation/

│
├── README.md
├── LICENSE
├── .gitignore
│
├── assets/
│   ├── arquitetura.png
│   ├── cloudformation-workflow.png
│   ├── stack-create.png
│   ├── stack-complete.png
│   ├── outputs.png
│   ├── terraform-vs-cloudformation.png
│   └── banner.png
│
├── docs/
│   ├── 01-introducao.md
│   ├── 02-cloudformation.md
│   ├── 03-beneficios.md
│   ├── 04-json-vs-yaml.md
│   ├── 05-stack.md
│   ├── 06-change-sets.md
│   ├── 07-rollback.md
│   ├── 08-drift-detection.md
│   ├── 09-boas-praticas.md
│   ├── 10-cloudformation-vs-terraform.md
│   ├── referencias.md
│   └── insights.md
│
├── templates/
│   ├── s3-bucket.yaml
│   ├── ec2.yaml
│   ├── vpc.yaml
│   ├── iam-role.yaml
│   ├── security-group.yaml
│   └── complete-lab.yaml
│
├── diagrams/
│   ├── arquitetura.drawio
│   ├── workflow.drawio
│   └── stack.drawio
│
├── examples/
│   ├── deploy-cli.md
│   ├── deploy-console.md
│   ├── update-stack.md
│   ├── delete-stack.md
│   └── parameters-example.json
│
├── scripts/
│   ├── deploy.sh
│   ├── validate.sh
│   └── delete.sh
│
└── .github/
    └── workflows/
        └── validate-template.yml


```

Essa estrutura é semelhante à encontrada em projetos open source de alto nível.


---

README

O README seguirá o framework de Meigarom + Luiz Café.

1 Problema de Negócio


---

2 Contexto


---

3 Premissas


---

4 Estratégia da solução

Aqui entra toda a arquitetura.

Fluxo:

Desenvolvedor

↓

Template YAML

↓

CloudFormation

↓

Stack

↓

AWS Resources

↓

Outputs


---

5 Arquitetura

Diagrama profissional.


---

6 Recursos criados

Tabela.

Serviço	Finalidade

Amazon S3	Storage
IAM	Controle de acesso
EC2	Computação
Security Groups	Segurança
CloudFormation	Orquestração



---

7 Estrutura dos templates

Explicação de:

Parameters

Mappings

Conditions

Resources

Outputs

Metadata

Transform


---

8 Implementação

Passo a passo.


---

9 Demonstração

Prints.


---

10 Benefícios

Padronização

Escalabilidade

Versionamento

Auditoria

Automação

Rollback


---

11 CloudFormation vs Terraform

Uma tabela extremamente profissional.


---

12 Lições aprendidas

Seguindo Luiz Café.


---

13 Próximos passos

Nested Stacks

StackSets

Macros

Modules

CI/CD

GitHub Actions

Pipeline


---

14 Referências

AWS Documentation

AWS Well-Architected

AWS CloudFormation User Guide


---

Diferencial FAANG

Eu acrescentaria ainda algo que quase ninguém coloca.

Decisões Técnicas

Por exemplo:

"Por que utilizar YAML?"

"Por que utilizar Parameters?"

"Por que Outputs?"

"Por que evitar hardcoding?"

"Quando usar Nested Stacks?"

"Quando usar StackSets?"

Isso demonstra pensamento de engenharia.


---

Outro diferencial

Uma seção chamada

Erros encontrados

Mostrando:

ROLLBACK_COMPLETE

CAPABILITY_IAM

Circular Dependency

Already Exists

DELETE_FAILED

ValidationError

Isso impressiona bastante porque mostra experiência prática.


---

Outro diferencial ainda

Criar um laboratório completo.

Em vez de apenas um template.

Teremos vários.

01-criar-s3

02-criar-ec2

03-criar-security-group

04-criar-iam

05-criar-vpc

06-template-completo

Assim o recrutador percebe evolução.


---

GitHub Actions

Podemos criar uma Action que valide automaticamente todos os templates YAML usando o AWS CLI ou ferramentas de lint.

Sempre que houver um push:

Push

↓

GitHub Actions

↓

Validação YAML

↓

Validação CloudFormation

↓

Status ✔

Pouquíssimos candidatos fazem isso.


---

## 👤 14. Autor

**Sérgio Santos** — Senior Data Engineer & Cloud Architect

15+ anos em sistemas bancários de missão crítica (Banco Bradesco S.A.) · DIO Campus Expert

[![Portfólio](https://img.shields.io/badge/Portfólio-Sérgio_Santos-111827?style=for-the-badge&logo=githubpages&logoColor=00eaff)](https://portfoliosantossergio.vercel.app)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Sérgio_Santos-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/santossergioluiz)

---



