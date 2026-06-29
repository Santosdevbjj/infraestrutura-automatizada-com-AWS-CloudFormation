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
