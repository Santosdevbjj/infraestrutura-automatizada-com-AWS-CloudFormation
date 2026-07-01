# JSON vs YAML no AWS CloudFormation

## Visão geral

O AWS CloudFormation permite escrever templates em dois formatos:

- JSON (JavaScript Object Notation)
- YAML (YAML Ain't Markup Language)

Ambos são totalmente suportados pela AWS e possuem a mesma capacidade funcional.

A escolha entre eles não muda o comportamento da infraestrutura, apenas a forma de representação.

---

# Por que dois formatos?

O CloudFormation foi projetado para ser flexível e compatível com diferentes perfis de engenheiros e sistemas.

## JSON

Foi o primeiro formato suportado pela AWS.

- amplamente utilizado em APIs;
- estruturado e rígido;
- fácil de processar por máquinas;
- mais verboso para humanos.

---

## YAML

Adicionado posteriormente para melhorar a experiência humana.

- mais legível;
- menos verboso;
- suporte a comentários;
- melhor para arquivos complexos;
- amplamente adotado em DevOps.

---

# Comparação direta

| Característica | JSON | YAML |
|----------------|------|------|
| Legibilidade | Média | Alta |
| Verbosidade | Alta | Baixa |
| Comentários | Não suporta | Suporta |
| Erros de sintaxe | Mais fácil de detectar | Mais sensível à indentação |
| Uso em APIs | Sim | Não comum |
| CloudFormation | Suportado | Suportado |
| Popularidade DevOps | Menor | Maior |

---

# Exemplo prático: EC2 Instance

## JSON

```json
{
  "Resources": {
    "MyInstance": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "InstanceType": "t2.micro",
        "ImageId": "ami-12345678"
      }
    }
  }
}
```

---

## YAML

```yaml
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId: ami-12345678
```

---

# Diferença de legibilidade

## JSON

- mais estruturado
- mais difícil de ler em arquivos grandes
- excesso de chaves e aspas

## YAML

- estrutura visual clara
- indentação define hierarquia
- ideal para templates complexos

---

# Uso no mundo real

## JSON é mais comum em:

- APIs REST
- integrações de sistemas
- aplicações legadas
- automações programáticas

---

## YAML é mais comum em:

- Kubernetes
- Docker Compose
- GitHub Actions
- AWS CloudFormation
- CI/CD pipelines

---

# CloudFormation e YAML

No contexto deste projeto, YAML foi escolhido porque:

- melhora a legibilidade dos templates;
- facilita manutenção;
- reduz ruído visual;
- é padrão de mercado em DevOps;
- suporta comentários explicativos.

---

# Erros comuns em YAML

YAML é sensível a indentação.

Erros comuns:

## 1. Indentação incorreta

❌

```yaml
Resources:
 MyInstance:
Type: AWS::EC2::Instance
```

✔

```yaml
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
```

---

## 2. Uso inconsistente de espaços

YAML não permite tabs.

Sempre usar espaços.

---

## 3. Estrutura mal organizada

Arquivos YAML grandes exigem organização clara para evitar erros.

---

# Quando usar JSON no CloudFormation?

Apesar de YAML ser mais comum, JSON ainda pode ser útil em alguns casos:

- automação programática;
- geração de templates via código;
- integração com sistemas legados;
- pipelines que geram JSON dinamicamente.

---

# Quando usar YAML?

YAML é preferido quando:

- humanos precisam ler e manter o código;
- o template é grande e complexo;
- há colaboração entre equipes;
- documentação está embutida no código.

---

# Conclusão

JSON e YAML são apenas representações diferentes do mesmo modelo de infraestrutura.

No AWS CloudFormation:

- JSON representa robustez e compatibilidade com sistemas;
- YAML representa legibilidade e produtividade para humanos.

---

# Decisão neste projeto

Este laboratório adota **YAML como padrão oficial**, por ser mais adequado para:

- leitura técnica;
- manutenção contínua;
- documentação integrada;
- práticas modernas de DevOps.

---

# Encerramento

Com isso, concluímos a análise comparativa entre JSON e YAML no contexto de Infrastructure as Code.

O próximo passo natural é aprofundar práticas de organização de templates e padrões de arquitetura utilizados em ambientes corporativos.
