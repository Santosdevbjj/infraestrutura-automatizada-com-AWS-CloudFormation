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
