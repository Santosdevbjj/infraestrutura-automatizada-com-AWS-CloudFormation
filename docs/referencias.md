# Referências Técnicas do Projeto

## Visão geral

Este documento reúne todas as referências utilizadas na construção deste projeto de Infrastructure as Code com AWS CloudFormation.

As fontes incluem documentação oficial da AWS, padrões de mercado, ferramentas DevOps e conceitos fundamentais de engenharia de software.

---

# 1. Documentação oficial da AWS

## AWS CloudFormation

- https://docs.aws.amazon.com/cloudformation/

Documentação principal do serviço AWS CloudFormation, incluindo:

- criação de stacks;
- templates YAML/JSON;
- parâmetros e outputs;
- Change Sets;
- rollback automático;
- drift detection.

---

## AWS IAM

- https://docs.aws.amazon.com/IAM/latest/UserGuide/

Referência para gerenciamento de identidade e acesso na AWS:

- roles e policies;
- best practices de segurança;
- princípio do menor privilégio;
- integração com serviços AWS.

---

## Amazon EC2

- https://docs.aws.amazon.com/ec2/

Documentação sobre instâncias EC2:

- tipos de instâncias;
- AMIs;
- networking;
- security groups;
- lifecycle.

---

## Amazon VPC

- https://docs.aws.amazon.com/vpc/

Referência para redes virtuais na AWS:

- subnets;
- route tables;
- internet gateways;
- NAT gateways;
- isolamento de rede.

---

## AWS Well-Architected Framework

- https://docs.aws.amazon.com/wellarchitected/

Framework de boas práticas da AWS baseado em cinco pilares:

- excelência operacional;
- segurança;
- confiabilidade;
- eficiência de performance;
- otimização de custos.

---

# 2. Infraestrutura como Código (IaC)

## Martin Fowler – Infrastructure as Code

- https://martinfowler.com/bliki/InfrastructureAsCode.html

Artigo conceitual sobre IaC explicando:

- automação de infraestrutura;
- versionamento;
- reprodutibilidade;
- eliminação de processos manuais.

---

# 3. DevOps e CI/CD

## GitHub Actions

- https://docs.github.com/actions

Documentação oficial do GitHub Actions:

- workflows YAML;
- jobs e steps;
- secrets;
- integração com AWS;
- automação CI/CD.

---

## DevOps Principles

Conceitos gerais:

- integração contínua;
- entrega contínua;
- automação de processos;
- cultura colaborativa entre Dev e Ops;
- feedback rápido.

---

# 4. AWS CLI

## AWS Command Line Interface

- https://docs.aws.amazon.com/cli/

Ferramenta de linha de comando para AWS:

- gerenciamento de stacks;
- automação de deploy;
- integração com scripts;
- execução de comandos CloudFormation.

---

# 5. CloudFormation Concepts

## Templates

Definem infraestrutura como código.

---

## Stacks

Instâncias executáveis de templates.

---

## Change Sets

Permitem visualizar mudanças antes da execução.

---

## Drift Detection

Detecta divergências entre template e infraestrutura real.

---

## Rollback

Mecanismo automático de recuperação em caso de falha.

---

# 6. Linguagens de infraestrutura

## YAML

- https://yaml.org/

Usado para templates CloudFormation e pipelines CI/CD.

---

## JSON

- https://www.json.org/

Formato estruturado utilizado em APIs e templates CloudFormation.

---

## HCL (Terraform)

- https://developer.hashicorp.com/terraform/language

Linguagem usada pelo Terraform para definição de infraestrutura.

---

# 7. Comparativos e práticas de mercado

## AWS vs Multi-cloud

- AWS: foco em integração nativa e profundidade de serviços
- Multi-cloud: foco em portabilidade e abstração

---

## CloudFormation vs Terraform

- CloudFormation: AWS-native, simples, integrado
- Terraform: multi-cloud, flexível, amplamente adotado

---

# 8. Segurança em Cloud

## IAM Best Practices

- uso de roles ao invés de credenciais fixas;
- menor privilégio possível;
- auditoria constante;
- uso de OIDC em pipelines.

---

## Segurança em CI/CD

- proteção de secrets;
- uso de environments;
- aprovação manual em produção;
- logs e auditoria.

---

# 9. Observabilidade

Conceitos importantes:

- logs centralizados;
- métricas;
- tracing;
- eventos de infraestrutura;
- auditoria contínua.

---

# 10. Boas práticas gerais

Baseadas em:

- AWS Well-Architected Framework;
- práticas de DevOps;
- engenharia de plataformas (Platform Engineering);
- SRE (Site Reliability Engineering).

---

# Conclusão

Este projeto foi construído com base em documentação oficial da AWS e práticas consolidadas da indústria de tecnologia.

As referências aqui listadas garantem que o conteúdo técnico esteja alinhado com padrões reais de mercado.

---

# Encerramento

Este documento finaliza a trilha de referências do projeto.

Ele serve como base para:

- aprofundamento técnico;
- validação conceitual;
- estudos avançados em Cloud Computing e DevOps.

---

# Projeto

**Implementando Infraestrutura Automatizada com AWS CloudFormation**

---

# Autor

Sérgio Luiz dos Santos  
GitHub: https://github.com/Santosdevbjj

---

# Status

Projeto completo — nível Cloud Engineering / DevOps / IaC
