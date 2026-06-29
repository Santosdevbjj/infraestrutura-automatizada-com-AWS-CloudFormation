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
