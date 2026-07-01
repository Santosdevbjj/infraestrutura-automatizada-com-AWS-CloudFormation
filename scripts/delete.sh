#!/usr/bin/env bash
###############################################################################
#
# Projeto:
# Implementando Infraestrutura Automatizada com AWS CloudFormation
#
# Arquivo:
# scripts/delete.sh
#
# Descrição:
# Script responsável pela remoção segura da infraestrutura provisionada
# pelo AWS CloudFormation.
#
# Objetivos:
#
# • Validar ambiente
# • Validar credenciais AWS
# • Validar existência da Stack
# • Confirmar exclusão
# • Excluir Stack
# • Aguardar conclusão
# • Gerar relatório final
#
# Arquitetura
#
# AWS CloudFormation
# ├── VPC
# ├── Subnets
# ├── Internet Gateway
# ├── Route Tables
# ├── Security Groups
# ├── IAM Roles
# ├── EC2
# └── S3 Bucket
#
# Boas práticas implementadas
#
# ✔ Infrastructure as Code
# ✔ AWS Well-Architected Framework
# ✔ DevOps
# ✔ Cloud Engineering
# ✔ Logging
# ✔ Tratamento de Erros
# ✔ Segurança
#
###############################################################################

set -Eeuo pipefail

###############################################################################
#
# Variáveis Globais
#
###############################################################################

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

readonly LOG_DIR="${PROJECT_ROOT}/logs"
readonly LOG_FILE="${LOG_DIR}/delete.log"

readonly PROFILE="${AWS_PROFILE:-default}"
readonly REGION="${AWS_REGION:-us-east-1}"

readonly STACK_NAME="${STACK_NAME:-aws-cloudformation-lab}"

readonly ENVIRONMENT="${ENVIRONMENT:-development}"

readonly TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
readonly START_TIME="$(date +%s)"

mkdir -p "${LOG_DIR}"

###############################################################################
#
# Cores
#
###############################################################################

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

###############################################################################
#
# Banner
#
###############################################################################

print_banner() {

cat << "EOF"

============================================================
          AWS CLOUDFORMATION DELETE
============================================================

        Infrastructure Removal Utility

             AWS Cloud Foundations

============================================================

    ____       _      _
   |  _ \ ___ | | ___| |_ ___
   | |_) / _ \| |/ _ \ __/ _ \
   |  _ < (_) | |  __/ ||  __/
   |_| \_\___/|_|\___|\__\___|

============================================================

EOF

}

###############################################################################
#
# Logging
#
###############################################################################

log_info() {

    echo -e "${GREEN}[INFO]${NC} $1"

    echo "[INFO] $1" >> "${LOG_FILE}"

}

log_warn() {

    echo -e "${YELLOW}[WARNING]${NC} $1"

    echo "[WARNING] $1" >> "${LOG_FILE}"

}

log_error() {

    echo -e "${RED}[ERROR]${NC} $1"

    echo "[ERROR] $1" >> "${LOG_FILE}"

}

log_success() {

    echo -e "${CYAN}[SUCCESS]${NC} $1"

    echo "[SUCCESS] $1" >> "${LOG_FILE}"

}

###############################################################################
#
# Tratamento de Erros
#
###############################################################################

error_handler() {

    local line="$1"
    local command="$2"

    log_error "Falha durante a execução."

    log_error "Linha.....: ${line}"

    log_error "Comando...: ${command}"

    exit 1

}

trap 'error_handler ${LINENO} "$BASH_COMMAND"' ERR

###############################################################################
#
# Funções Utilitárias
#
###############################################################################

separator() {

    printf '%*s\n' "${COLUMNS:-80}" '' | tr ' ' '='

}

section() {

    separator

    echo -e "${BOLD}${BLUE}$1${NC}"

    separator

}

###############################################################################
#
# Informações do Ambiente
#
###############################################################################

show_environment() {

    section "Informações do Ambiente"

    echo "Projeto............. AWS CloudFormation Lab"

    echo "Stack............... ${STACK_NAME}"

    echo "Ambiente............ ${ENVIRONMENT}"

    echo "Diretório........... ${PROJECT_ROOT}"

    echo "Região.............. ${REGION}"

    echo "Perfil AWS.......... ${PROFILE}"

    echo "Arquivo de Log...... ${LOG_FILE}"

    echo "Data................ ${TIMESTAMP}"

    echo

}

###############################################################################
#
# Inicialização
#
###############################################################################

print_banner

show_environment

log_info "Iniciando processo de remoção da infraestrutura..."

###############################################################################
#
# Próxima Parte
#
# • Validar AWS CLI
# • Validar Credenciais
# • Validar Região
# • Validar Existência da Stack
# • Exibir Recursos
# • Proteção para Produção
# • Confirmação Dupla
#
###############################################################################

###############################################################################
#
# Validação da AWS CLI
#
###############################################################################

check_aws_cli() {

    section "Validando AWS CLI"

    if ! command -v aws >/dev/null 2>&1
    then
        log_error "AWS CLI não encontrada."

        exit 1
    fi

    local version

    version="$(aws --version 2>&1)"

    log_success "AWS CLI instalada."

    echo "${version}"

    echo

}

###############################################################################
#
# Validação das Credenciais
#
###############################################################################

check_credentials() {

    section "Validando Credenciais"

    if aws sts get-caller-identity \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_success "Credenciais válidas."

    else

        log_error "Credenciais inválidas."

        log_error "Execute: aws configure"

        exit 1

    fi

}

###############################################################################
#
# Informações da Conta
#
###############################################################################

show_account_information() {

    section "Conta AWS"

    local account
    local arn

    account="$(
        aws sts get-caller-identity \
        --profile "${PROFILE}" \
        --query Account \
        --output text
    )"

    arn="$(
        aws sts get-caller-identity \
        --profile "${PROFILE}" \
        --query Arn \
        --output text
    )"

    echo "Conta............. ${account}"

    echo "ARN............... ${arn}"

    echo

}

###############################################################################
#
# Região
#
###############################################################################

check_region() {

    section "Validando Região"

    aws ec2 describe-regions \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        >/dev/null

    log_success "Região ${REGION} validada."

}

###############################################################################
#
# Verificar Existência da Stack
#
###############################################################################

check_stack_exists() {

    section "Stack CloudFormation"

    if aws cloudformation describe-stacks \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_success "Stack localizada."

    else

        log_error "Stack não encontrada."

        exit 1

    fi

}

###############################################################################
#
# Exibir Recursos da Stack
#
###############################################################################

show_resources() {

    section "Recursos que serão removidos"

    aws cloudformation list-stack-resources \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        --query \
        "StackResourceSummaries[*].[LogicalResourceId,ResourceType,ResourceStatus]" \
        --output table

}

###############################################################################
#
# Proteção para Produção
#
###############################################################################

protect_production() {

    section "Proteção"

    if [[ "${ENVIRONMENT}" == "production" ]]
    then

        log_error "Ambiente de PRODUÇÃO detectado."

        echo

        echo "A exclusão automática foi bloqueada."

        echo

        exit 1

    fi

    log_success "Ambiente seguro para exclusão."

}

###############################################################################
#
# Primeira Confirmação
#
###############################################################################

confirm_delete() {

    section "Confirmação"

    echo

    echo "ATENÇÃO"

    echo

    echo "A Stack abaixo será REMOVIDA."

    echo

    echo "Stack........ ${STACK_NAME}"

    echo "Região....... ${REGION}"

    echo

    read -rp "Digite YES para continuar: " answer

    if [[ "${answer}" != "YES" ]]
    then

        log_warn "Operação cancelada."

        exit 0

    fi

}

###############################################################################
#
# Segunda Confirmação
#
###############################################################################

double_confirmation() {

    section "Confirmação Final"

    read -rp "Digite o nome da Stack para confirmar: " confirmation

    if [[ "${confirmation}" != "${STACK_NAME}" ]]
    then

        log_error "Nome incorreto."

        log_error "Exclusão cancelada."

        exit 1

    fi

    log_success "Confirmação validada."

}

###############################################################################
#
# Execução
#
###############################################################################

check_aws_cli

check_credentials

show_account_information

check_region

check_stack_exists

show_resources

protect_production

confirm_delete

double_confirmation

###############################################################################
#
# Próxima Parte
#
# • Delete Stack
# • Wait stack-delete-complete
# • Limpeza opcional do Bucket S3
# • Limpeza de arquivos temporários
# • Tratamento de falhas
# • Logs detalhados
#
############################################################################### 

###############################################################################
#
# Exclusão da Stack CloudFormation
#
###############################################################################

delete_stack() {

    section "Removendo Stack CloudFormation"

    log_info "Iniciando exclusão da Stack..."

    aws cloudformation delete-stack \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}"

    log_success "Solicitação de exclusão enviada."

}

###############################################################################
#
# Aguardar Exclusão
#
###############################################################################

wait_delete() {

    section "Aguardando Exclusão"

    log_info "A AWS está removendo os recursos."

    log_info "Este processo pode levar alguns minutos..."

    aws cloudformation wait stack-delete-complete \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}"

    log_success "Stack removida com sucesso."

}

###############################################################################
#
# Limpeza Opcional do Bucket S3
#
###############################################################################

cleanup_bucket() {

    section "Limpeza do Bucket S3"

    if [[ -z "${ARTIFACT_BUCKET:-}" ]]
    then

        log_warn "Bucket de artefatos não informado."

        log_warn "Limpeza ignorada."

        return

    fi

    log_info "Removendo objetos do bucket..."

    aws s3 rm \
        "s3://${ARTIFACT_BUCKET}" \
        --recursive \
        --profile "${PROFILE}" \
        --region "${REGION}"

    log_success "Objetos removidos."

}

###############################################################################
#
# Limpeza de Arquivos Temporários
#
###############################################################################

cleanup_temp_files() {

    section "Arquivos Temporários"

    local files=(
        "${PROJECT_ROOT}/packaged-template.yaml"
        "${PROJECT_ROOT}/template-export.yaml"
        "${PROJECT_ROOT}/deploy-output.json"
        "${PROJECT_ROOT}/validation-report.json"
    )

    for file in "${files[@]}"
    do

        if [[ -f "${file}" ]]
        then

            rm -f "${file}"

            log_success "Removido: $(basename "${file}")"

        fi

    done

}

###############################################################################
#
# Verificação Final
#
###############################################################################

verify_removal() {

    section "Verificação"

    if aws cloudformation describe-stacks \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_error "A Stack ainda existe."

        exit 1

    fi

    log_success "Nenhuma Stack encontrada."

}

###############################################################################
#
# Tratamento de Falhas
#
###############################################################################

check_failed_resources() {

    section "Eventos Recentes"

    aws cloudformation describe-stack-events \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        --max-items 10 \
        --output table \
        || true

}

###############################################################################
#
# Resumo da Exclusão
#
###############################################################################

show_summary() {

    section "Resumo"

    echo "Stack............... ${STACK_NAME}"

    echo "Região.............. ${REGION}"

    echo "Perfil.............. ${PROFILE}"

    echo "Ambiente............ ${ENVIRONMENT}"

    echo "Log................. ${LOG_FILE}"

    echo

}

###############################################################################
#
# Execução
#
###############################################################################

show_summary

delete_stack

wait_delete

cleanup_bucket

cleanup_temp_files

verify_removal

###############################################################################
#
# Próxima Parte
#
# • Relatório Final
# • Estatísticas
# • Tempo de Execução
# • Checklist
# • Próximos Passos
# • Encerramento
#
############################################################################### 

###############################################################################
#
# Relatório Final
#
###############################################################################

generate_report() {

    section "Relatório de Remoção"

    cat << EOF

============================================================
              RELATÓRIO DE REMOÇÃO
============================================================

Projeto............. AWS CloudFormation Lab

Stack............... ${STACK_NAME}

Ambiente............ ${ENVIRONMENT}

Região.............. ${REGION}

Perfil AWS.......... ${PROFILE}

Diretório........... ${PROJECT_ROOT}

Arquivo de Log...... ${LOG_FILE}

Data................ ${TIMESTAMP}

============================================================

EOF

}

###############################################################################
#
# Estatísticas
#
###############################################################################

show_statistics() {

    section "Estatísticas"

    echo "Infraestrutura........ AWS CloudFormation"

    echo "Operação.............. DELETE"

    echo "Status................ CONCLUÍDO"

    echo "Logs.................. ${LOG_FILE}"

    echo

}

###############################################################################
#
# Tempo de Execução
#
###############################################################################

show_execution_time() {

    section "Tempo de Execução"

    local end_time
    local elapsed

    end_time="$(date +%s)"

    elapsed=$((end_time - START_TIME))

    echo "Tempo total........... ${elapsed} segundos"

    echo

}

###############################################################################
#
# Checklist Final
#
###############################################################################

show_checklist() {

    section "Checklist"

    cat << EOF

✔ AWS CLI validada

✔ Credenciais AWS verificadas

✔ Região validada

✔ Stack localizada

✔ Recursos identificados

✔ Confirmação dupla realizada

✔ Stack removida

✔ Recursos excluídos

✔ Arquivos temporários removidos

✔ Verificação final executada

✔ Logs gerados

EOF

}

###############################################################################
#
# Próximos Passos
#
###############################################################################

show_recommendations() {

    section "Próximos Passos"

    cat << EOF

• Verificar o Console AWS para confirmar a remoção.

• Confirmar que não existem recursos órfãos.

• Revisar custos no AWS Cost Explorer.

• Atualizar a documentação do projeto.

• Registrar alterações no GitHub.

• Executar validate.sh antes do próximo deploy.

• Utilizar deploy.sh para recriar a infraestrutura.

EOF

}

###############################################################################
#
# Encerramento
#
###############################################################################

finish() {

    separator

    echo

    echo -e "${GREEN}"

    echo "Infraestrutura removida com sucesso."

    echo

    echo "Todos os recursos da Stack foram processados."

    echo

    echo "O ambiente está pronto para um novo deployment."

    echo

    echo -e "${NC}"

    separator

}

###############################################################################
#
# Execução Final
#
###############################################################################

generate_report

show_statistics

show_execution_time

show_checklist

show_recommendations

finish

###############################################################################
#
# Compatibilidade
#
###############################################################################
#
# ✔ Linux
# ✔ macOS
# ✔ Windows (WSL)
# ✔ GitHub Actions
# ✔ AWS CodeBuild
# ✔ Jenkins
# ✔ Azure DevOps
#
###############################################################################
#
# Boas Práticas Implementadas
#
###############################################################################
#
# ✔ Infrastructure as Code (IaC)
#
# ✔ AWS CloudFormation
#
# ✔ AWS Well-Architected Framework
#
# ✔ DevOps
#
# ✔ Cloud Engineering
#
# ✔ Fail Fast
#
# ✔ Logging
#
# ✔ Tratamento de Erros
#
# ✔ Modularização
#
# ✔ Reutilização
#
# ✔ Observabilidade
#
# ✔ Segurança Operacional
#
###############################################################################
#
# Evoluções Futuras
#
###############################################################################
#
# □ Exclusão automática de buckets versionados
#
# □ Remoção de objetos protegidos por MFA Delete
#
# □ Relatório em JSON
#
# □ Relatório em Markdown
#
# □ Integração com GitHub Actions
#
# □ Integração com AWS CodePipeline
#
# □ Integração com AWS Systems Manager
#
# □ Notificações via Amazon SNS
#
###############################################################################
#
# Desenvolvido para a Formação
# AWS Cloud Foundations
#
# Projeto:
# Implementando Infraestrutura Automatizada
# com AWS CloudFormation
#
# 
#
# 
#   
#
# 
#   
#   
#
###############################################################################
#
# Autor
#
# Sérgio Luiz dos Santos
#
# GitHub:
# https://github.com/Santosdevbjj
#
###############################################################################
#
# END OF FILE
#
############################################################################### 


