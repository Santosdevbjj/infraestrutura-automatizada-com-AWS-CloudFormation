#!/usr/bin/env bash
###############################################################################
#
# Projeto:
# Implementando Infraestrutura Automatizada com AWS CloudFormation
#
# Arquivo:
# scripts/validate.sh
#
# Descrição:
# Script responsável por validar o ambiente de execução e os templates
# CloudFormation antes do deployment da infraestrutura.
#
# Objetivos:
# • Validar dependências
# • Validar AWS CLI
# • Validar credenciais AWS
# • Validar estrutura do projeto
# • Validar templates CloudFormation
# • Gerar relatório de validação
#
# Boas práticas:
# ✔ AWS Well-Architected Framework
# ✔ Infrastructure as Code (IaC)
# ✔ DevOps
# ✔ Cloud Engineering
# ✔ Meigarom Lopes
# ✔ Luiz Café
#
###############################################################################

set -Eeuo pipefail

###############################################################################
# Variáveis Globais
###############################################################################

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

readonly TEMPLATE_DIR="${PROJECT_ROOT}/templates"
readonly LOG_DIR="${PROJECT_ROOT}/logs"
readonly LOG_FILE="${LOG_DIR}/validate.log"

readonly PROFILE="${AWS_PROFILE:-default}"
readonly REGION="${AWS_REGION:-us-east-1}"

readonly TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
readonly START_TIME="$(date +%s)"

mkdir -p "${LOG_DIR}"

###############################################################################
# Templates do Projeto
###############################################################################

readonly TEMPLATES=(
    "main.yaml"
    "complete-lab.yaml"
    "vpc.yaml"
    "ec2.yaml"
    "iam-role.yaml"
    "security-group.yaml"
    "s3-bucket.yaml"
)

###############################################################################
# Cores
###############################################################################

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

###############################################################################
# Banner
###############################################################################

print_banner() {

cat << "EOF"

============================================================
        AWS CLOUDFORMATION VALIDATION
============================================================

      Infrastructure as Code Validation Tool

             AWS Cloud Foundations

============================================================

 __      __    _ _     _       _
 \ \    / /_ _| (_)___| | __ _| |_ ___
  \ \/\/ / _` | | / -_) |/ _` |  _/ -_)
   \_/\_/\__,_|_|_\___|_|\__,_|\__\___|

============================================================

EOF

}

###############################################################################
# Logging
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
# Tratamento de Erros
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
# Funções Utilitárias
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
# Verificação de Dependências
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
# Informações do Ambiente
###############################################################################

show_environment() {

    section "Informações do Ambiente"

    echo "Projeto............. AWS CloudFormation Lab"

    echo "Diretório.......... ${PROJECT_ROOT}"

    echo "Templates.......... ${TEMPLATE_DIR}"

    echo "Região............. ${REGION}"

    echo "Perfil AWS......... ${PROFILE}"

    echo "Logs............... ${LOG_FILE}"

    echo "Data............... ${TIMESTAMP}"

    echo

}

###############################################################################
# Inicialização
###############################################################################

print_banner

show_environment

log_info "Iniciando validação da infraestrutura..."

###############################################################################
#
# Próxima Parte
#
# • Validar AWS CLI
# • Validar Credenciais AWS
# • Validar Região
# • Validar Estrutura do Projeto
# • Validar Existência dos Templates
# • Validar Permissões dos Scripts
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

    log_success "AWS CLI instalada."

    echo "${version}"

    echo

}

###############################################################################
#
# Validação das Credenciais AWS
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

    user="$(
        aws sts get-caller-identity \
        --profile "${PROFILE}" \
        --query UserId \
        --output text
    )"

    echo "Conta............. ${account}"
    echo "Usuário........... ${user}"
    echo "ARN............... ${arn}"

    echo

}

###############################################################################
#
# Validação da Região
#
###############################################################################

check_region() {

    section "Validando Região AWS"

    if aws ec2 describe-regions \
        --region "${REGION}" \
        --profile "${PROFILE}" \
        >/dev/null 2>&1
    then

        log_success "Região ${REGION} validada."

    else

        log_error "Região inválida."

        exit 1

    fi

}

###############################################################################
#
# Estrutura do Projeto
#
###############################################################################

check_project_structure() {

    section "Estrutura do Projeto"

    local directories=(
        templates
        scripts
        docs
        diagrams
        images
    )

    for dir in "${directories[@]}"
    do

        if [[ -d "${PROJECT_ROOT}/${dir}" ]]
        then

            log_success "Diretório encontrado: ${dir}"

        else

            log_warn "Diretório ausente: ${dir}"

        fi

    done

}

###############################################################################
#
# Existência dos Templates
#
###############################################################################

check_templates() {

    section "Templates CloudFormation"

    local missing=0

    for template in "${TEMPLATES[@]}"
    do

        if [[ -f "${TEMPLATE_DIR}/${template}" ]]
        then

            log_success "${template}"

        else

            log_error "${template} não encontrado."

            missing=$((missing + 1))

        fi

    done

    if [[ "${missing}" -gt 0 ]]
    then

        log_error "Existem templates ausentes."

        exit 1

    fi

}

###############################################################################
#
# Permissões dos Scripts
#
###############################################################################

check_script_permissions() {

    section "Permissões"

    local scripts=(
        deploy.sh
        validate.sh
    )

    for script in "${scripts[@]}"
    do

        if [[ -x "${SCRIPT_DIR}/${script}" ]]
        then

            log_success "${script} executável."

        else

            log_warn "${script} sem permissão de execução."

            chmod +x "${SCRIPT_DIR}/${script}"

            log_success "Permissão aplicada."

        fi

    done

}

###############################################################################
#
# Espaço em Disco
#
###############################################################################

check_disk_space() {

    section "Espaço em Disco"

    df -h "${PROJECT_ROOT}"

    echo

}

###############################################################################
#
# Variáveis de Ambiente
#
###############################################################################

check_environment_variables() {

    section "Variáveis de Ambiente"

    echo "AWS_PROFILE..... ${PROFILE}"

    echo "AWS_REGION...... ${REGION}"

    echo "PROJECT_ROOT.... ${PROJECT_ROOT}"

    echo "TEMPLATE_DIR.... ${TEMPLATE_DIR}"

    echo

}

###############################################################################
#
# Execução das Validações
#
###############################################################################

check_aws_cli

check_credentials

show_account_information

check_region

check_project_structure

check_templates

check_script_permissions

check_disk_space

check_environment_variables

###############################################################################
#
# Próxima Parte
#
# • Validação da sintaxe YAML
# • aws cloudformation validate-template
# • Validação dos parâmetros
# • Verificação de Ref
# • Verificação de GetAtt
# • Verificação de ImportValue
# • Boas práticas de CloudFormation
#
############################################################################### 

###############################################################################
#
# Validação da Sintaxe YAML
#
###############################################################################

validate_yaml() {

    section "Validação da Sintaxe YAML"

    check_command python3

    for template in "${TEMPLATES[@]}"
    do

        log_info "Validando ${template}"

        python3 <<EOF
import yaml
import sys

try:
    with open("${TEMPLATE_DIR}/${template}", "r") as f:
        yaml.safe_load(f)
    print("OK")
except Exception as e:
    print(e)
    sys.exit(1)
EOF

        log_success "${template} possui sintaxe YAML válida."

    done

}

###############################################################################
#
# CloudFormation Validate Template
#
###############################################################################

validate_cloudformation() {

    section "CloudFormation Validate"

    for template in "${TEMPLATES[@]}"
    do

        log_info "CloudFormation: ${template}"

        aws cloudformation validate-template \
            --template-body file://"${TEMPLATE_DIR}/${template}" \
            --profile "${PROFILE}" \
            >/dev/null

        log_success "${template} validado."

    done

}

###############################################################################
#
# Validação dos Parameters
#
###############################################################################

validate_parameters() {

    section "Parameters"

    for template in "${TEMPLATES[@]}"
    do

        echo

        echo "Arquivo: ${template}"

        grep "^Parameters:" \
            "${TEMPLATE_DIR}/${template}" \
            >/dev/null \
            && log_success "Parameters encontrados." \
            || log_warn "Nenhum Parameters encontrado."

    done

}

###############################################################################
#
# Ref
#
###############################################################################

validate_ref() {

    section "Referências Ref"

    for template in "${TEMPLATES[@]}"
    do

        local count

        count=$(grep -c "Ref:" "${TEMPLATE_DIR}/${template}" || true)

        echo "${template}: ${count} referência(s) Ref"

    done

}

###############################################################################
#
# GetAtt
#
###############################################################################

validate_getatt() {

    section "Referências GetAtt"

    for template in "${TEMPLATES[@]}"
    do

        local count

        count=$(grep -c "GetAtt" "${TEMPLATE_DIR}/${template}" || true)

        echo "${template}: ${count} referência(s) GetAtt"

    done

}

###############################################################################
#
# ImportValue
#
###############################################################################

validate_importvalue() {

    section "ImportValue"

    for template in "${TEMPLATES[@]}"
    do

        local count

        count=$(grep -c "ImportValue" "${TEMPLATE_DIR}/${template}" || true)

        echo "${template}: ${count} referência(s) ImportValue"

    done

}

###############################################################################
#
# Outputs
#
###############################################################################

validate_outputs() {

    section "Outputs"

    for template in "${TEMPLATES[@]}"
    do

        if grep "^Outputs:" \
            "${TEMPLATE_DIR}/${template}" \
            >/dev/null
        then

            log_success "${template} possui Outputs."

        else

            log_warn "${template} não possui Outputs."

        fi

    done

}

###############################################################################
#
# Tags
#
###############################################################################

validate_tags() {

    section "Tags"

    for template in "${TEMPLATES[@]}"
    do

        if grep "Tags:" \
            "${TEMPLATE_DIR}/${template}" \
            >/dev/null
        then

            log_success "${template} utiliza Tags."

        else

            log_warn "${template} sem Tags."

        fi

    done

}

###############################################################################
#
# Version
#
###############################################################################

validate_version() {

    section "Template Version"

    for template in "${TEMPLATES[@]}"
    do

        if grep "AWSTemplateFormatVersion" \
            "${TEMPLATE_DIR}/${template}" \
            >/dev/null
        then

            log_success "${template} possui versão."

        else

            log_warn "${template} sem versão."

        fi

    done

}

###############################################################################
#
# Descrição
#
###############################################################################

validate_description() {

    section "Description"

    for template in "${TEMPLATES[@]}"
    do

        if grep "^Description:" \
            "${TEMPLATE_DIR}/${template}" \
            >/dev/null
        then

            log_success "${template} possui Description."

        else

            log_warn "${template} sem Description."

        fi

    done

}

###############################################################################
#
# Execução
#
###############################################################################

validate_yaml

validate_cloudformation

validate_parameters

validate_ref

validate_getatt

validate_importvalue

validate_outputs

validate_tags

validate_version

validate_description

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



