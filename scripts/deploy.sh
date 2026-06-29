#!/usr/bin/env bash
###############################################################################
#
# Projeto:
# Implementando Infraestrutura Automatizada com AWS CloudFormation
#
# Arquivo:
# scripts/deploy.sh
#
# Descrição:
# Script responsável pelo provisionamento automatizado da infraestrutura AWS
# utilizando AWS CloudFormation.
#
# Objetivos
#
# • Validar ambiente
# • Validar AWS CLI
# • Validar Templates
# • Executar Deploy
# • Exibir Outputs
# • Registrar Logs
#
# Desenvolvido seguindo boas práticas de:
#
# ✔ AWS Well-Architected Framework
# ✔ Infrastructure as Code
# ✔ DevOps
# ✔ Cloud Engineering
# ✔ Meigarom Lopes
# ✔ Luiz Café
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

readonly TEMPLATE_FILE="${PROJECT_ROOT}/templates/complete-lab.yaml"

readonly LOG_DIR="${PROJECT_ROOT}/logs"

readonly LOG_FILE="${LOG_DIR}/deploy.log"

readonly STACK_NAME="${STACK_NAME:-aws-cloudformation-lab}"

readonly REGION="${AWS_REGION:-us-east-1}"

readonly PROFILE="${AWS_PROFILE:-default}"

readonly ENVIRONMENT="${ENVIRONMENT:-dev}"

readonly TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"

readonly START_TIME="$(date +%s)"

###############################################################################
#
# Cores
#
###############################################################################

readonly RED='\033[0;31m'

readonly GREEN='\033[0;32m'

readonly YELLOW='\033[1;33m'

readonly BLUE='\033[0;34m'

readonly MAGENTA='\033[0;35m'

readonly CYAN='\033[0;36m'

readonly BOLD='\033[1m'

readonly NC='\033[0m'

###############################################################################
#
# Criação do diretório de logs
#
###############################################################################

mkdir -p "${LOG_DIR}"

###############################################################################
#
# Banner
#
###############################################################################

print_banner() {

cat << "EOF"

============================================================

      AWS CLOUDFORMATION DEPLOYMENT

      Infrastructure as Code

      AWS Cloud Foundations

============================================================

        ____ _                 _ _____
       / ___| | ___  _   _  __| |  ___|
      | |   | |/ _ \| | | |/ _` | |_
      | |___| | (_) | |_| | (_| |  _|
       \____|_|\___/ \__,_|\__,_|_|

        CloudFormation Deployment

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

    log_error "Erro detectado."

    log_error "Linha.......: ${line}"

    log_error "Comando.....: ${command}"

    log_error "Script interrompido."

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
# Verificação de Dependências
#
###############################################################################

check_command() {

    local command="$1"

    if ! command -v "${command}" >/dev/null 2>&1
    then

        log_error "Dependência não encontrada: ${command}"

        exit 1

    fi

    log_success "${command} encontrado."

}

###############################################################################
#
# Informações do Ambiente
#
###############################################################################

show_environment() {

    section "Informações do Ambiente"

    echo "Projeto.............: AWS CloudFormation Lab"

    echo "Stack...............: ${STACK_NAME}"

    echo "Região..............: ${REGION}"

    echo "Perfil AWS..........: ${PROFILE}"

    echo "Ambiente............: ${ENVIRONMENT}"

    echo "Template............: ${TEMPLATE_FILE}"

    echo "Logs................: ${LOG_FILE}"

    echo "Data................: ${TIMESTAMP}"

    echo

}

###############################################################################
#
# Início
#
###############################################################################

print_banner

show_environment

log_info "Inicializando processo de deployment..."

###############################################################################
#
# Próxima Parte
#
# • Verificar AWS CLI
# • Validar Credenciais
# • Validar Região
# • Validar Template
# • Criar Bucket de Artefatos
#
###############################################################################

###############################################################################
#
# Validação da AWS CLI
#
###############################################################################

check_aws_cli() {

    section "Validando AWS CLI"

    check_command aws

    local version

    version="$(aws --version 2>&1)"

    log_success "AWS CLI encontrada."

    echo "${version}"

}

###############################################################################
#
# Verificação das Credenciais AWS
#
###############################################################################

check_aws_credentials() {

    section "Validando Credenciais AWS"

    if aws sts get-caller-identity \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_success "Credenciais válidas."

    else

        log_error "Credenciais AWS inválidas."

        log_error "Execute: aws configure"

        exit 1

    fi

}

###############################################################################
#
# Informações da Conta AWS
#
###############################################################################

show_account_information() {

    section "Conta AWS"

    local account

    local arn

    local user

    account="$(aws sts get-caller-identity \
        --profile "${PROFILE}" \
        --query Account \
        --output text)"

    arn="$(aws sts get-caller-identity \
        --profile "${PROFILE}" \
        --query Arn \
        --output text)"

    user="$(aws sts get-caller-identity \
        --profile "${PROFILE}" \
        --query UserId \
        --output text)"

    echo "Conta AWS......: ${account}"

    echo "Usuário........: ${user}"

    echo "ARN............: ${arn}"

    echo

}

###############################################################################
#
# Validação da Região
#
###############################################################################

check_region() {

    section "Validando Região"

    if aws ec2 describe-regions \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_success "Região ${REGION} disponível."

    else

        log_error "Região inválida."

        exit 1

    fi

}

###############################################################################
#
# Validação do Template CloudFormation
#
###############################################################################

validate_template() {

    section "Validando Template"

    if [[ ! -f "${TEMPLATE_FILE}" ]]
    then

        log_error "Template não encontrado."

        log_error "${TEMPLATE_FILE}"

        exit 1

    fi

    aws cloudformation validate-template \
        --template-body "file://${TEMPLATE_FILE}" \
        --profile "${PROFILE}" \
        >/dev/null

    log_success "Template validado com sucesso."

}

###############################################################################
#
# Verificação da Stack
#
###############################################################################

check_stack() {

    section "Verificando Stack"

    if aws cloudformation describe-stacks \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_warn "Stack existente."

        STACK_EXISTS=true

    else

        log_info "Nova Stack será criada."

        STACK_EXISTS=false

    fi

}

###############################################################################
#
# Bucket de Artefatos
#
###############################################################################

ARTIFACT_BUCKET="${STACK_NAME}-artifacts-${REGION}"

create_artifact_bucket() {

    section "Bucket de Artefatos"

    if aws s3api head-bucket \
        --bucket "${ARTIFACT_BUCKET}" \
        >/dev/null 2>&1
    then

        log_success "Bucket já existe."

    else

        log_info "Criando bucket..."

        if [[ "${REGION}" == "us-east-1" ]]
        then

            aws s3 mb \
                "s3://${ARTIFACT_BUCKET}" \
                --profile "${PROFILE}"

        else

            aws s3api create-bucket \
                --bucket "${ARTIFACT_BUCKET}" \
                --region "${REGION}" \
                --create-bucket-configuration \
                LocationConstraint="${REGION}" \
                --profile "${PROFILE}"

        fi

        log_success "Bucket criado."

    fi

}

###############################################################################
#
# Execução das Validações
#
###############################################################################

check_aws_cli

check_aws_credentials

show_account_information

check_region

validate_template

check_stack

create_artifact_bucket

###############################################################################
#
# Próxima Parte
#
# • CloudFormation Package
# • Upload para Amazon S3
# • CloudFormation Deploy
# • CAPABILITY_IAM
# • CAPABILITY_NAMED_IAM
# • Tratamento de Rollback
#
############################################################################### 

###############################################################################
#
# Template Empacotado
#
###############################################################################

PACKAGED_TEMPLATE="${PROJECT_ROOT}/templates/packaged-template.yaml"

###############################################################################
#
# CloudFormation Package
#
###############################################################################

package_template() {

    section "Empacotando Template"

    if grep -q "CodeUri\|TemplateURL\|AWS::Lambda" "${TEMPLATE_FILE}" 2>/dev/null
    then

        log_info "Recursos empacotáveis detectados."

        aws cloudformation package \
            --template-file "${TEMPLATE_FILE}" \
            --s3-bucket "${ARTIFACT_BUCKET}" \
            --output-template-file "${PACKAGED_TEMPLATE}" \
            --region "${REGION}" \
            --profile "${PROFILE}"

        DEPLOY_TEMPLATE="${PACKAGED_TEMPLATE}"

        log_success "Template empacotado."

    else

        log_info "Empacotamento não necessário."

        DEPLOY_TEMPLATE="${TEMPLATE_FILE}"

    fi

}

###############################################################################
#
# Confirmação para Produção
#
###############################################################################

confirm_production() {

    if [[ "${ENVIRONMENT}" == "prod" ]]
    then

        separator

        echo

        echo "ATENÇÃO"

        echo

        echo "Você está realizando deploy em PRODUÇÃO."

        echo

        read -rp "Deseja continuar? (yes/no): " answer

        if [[ "${answer}" != "yes" ]]
        then

            log_warn "Deploy cancelado."

            exit 0

        fi

    fi

}

###############################################################################
#
# CloudFormation Deploy
#
###############################################################################

deploy_stack() {

    section "Executando Deploy"

    log_info "Iniciando deployment..."

    aws cloudformation deploy \
        --template-file "${DEPLOY_TEMPLATE}" \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        --capabilities \
            CAPABILITY_IAM \
            CAPABILITY_NAMED_IAM \
            CAPABILITY_AUTO_EXPAND \
        --parameter-overrides \
            Environment="${ENVIRONMENT}" \
        --no-fail-on-empty-changeset

    log_success "Deployment concluído."

}

###############################################################################
#
# Espera pela Finalização
#
###############################################################################

wait_stack() {

    section "Aguardando Finalização"

    if [[ "${STACK_EXISTS}" == true ]]
    then

        aws cloudformation wait stack-update-complete \
            --stack-name "${STACK_NAME}" \
            --region "${REGION}" \
            --profile "${PROFILE}"

    else

        aws cloudformation wait stack-create-complete \
            --stack-name "${STACK_NAME}" \
            --region "${REGION}" \
            --profile "${PROFILE}"

    fi

    log_success "Stack finalizada."

}

###############################################################################
#
# Rollback
#
###############################################################################

rollback_information() {

    section "Rollback"

    local status

    status="$(
        aws cloudformation describe-stacks \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        --query "Stacks[0].StackStatus" \
        --output text
    )"

    echo

    echo "Status atual: ${status}"

    echo

    case "${status}" in

        *ROLLBACK*)

            log_warn "CloudFormation executou rollback."

            ;;

        *FAILED*)

            log_error "Deploy falhou."

            ;;

        *)

            log_success "Nenhum rollback detectado."

            ;;

    esac

}

###############################################################################
#
# Eventos da Stack
#
###############################################################################

show_recent_events() {

    section "Últimos Eventos"

    aws cloudformation describe-stack-events \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        --max-items 10 \
        --query "StackEvents[*].[Timestamp,LogicalResourceId,ResourceStatus]" \
        --output table

}

###############################################################################
#
# Execução
#
###############################################################################

package_template

confirm_production

deploy_stack

wait_stack

rollback_information

show_recent_events

###############################################################################
#
# Próxima Parte
#
# • Exibir Outputs
# • Tempo de execução
# • Estatísticas
# • Resumo do Deploy
# • Encerramento
#
############################################################################### 


