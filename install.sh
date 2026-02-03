#!/bin/bash

# Script de Instalação do Gerenciador de Servidores Remotos
# Para Termux/Android e Linux

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Função para detectar ambiente
detect_environment() {
    if [[ -n "$TERMUX_VERSION" ]]; then
        echo "termux"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Função para instalar dependências no Termux
install_termux_deps() {
    echo -e "${BLUE}Instalando dependências para Termux...${NC}"
    
    # Atualizar pacotes
    pkg update -y && pkg upgrade -y
    
    # Instalar dependências básicas
    local deps=("openssh" "ping" "net-tools" "tar" "nc" "curl" "wget")
    
    for dep in "${deps[@]}"; do
        echo -e "${YELLOW}Instalando $dep...${NC}"
        pkg install -y "$dep"
    done
    
    echo -e "${GREEN}✓ Dependências do Termux instaladas!${NC}"
}

# Função para instalar dependências no Linux
install_linux_deps() {
    echo -e "${BLUE}Instalando dependências para Linux...${NC}"
    
    # Detectar gerenciador de pacotes
    if command -v apt >/dev/null 2>&1; then
        echo -e "${YELLOW}Usando apt (Debian/Ubuntu)...${NC}"
        sudo apt update
        sudo apt install -y openssh-client iputils-ping netcat-openbsd tar curl wget
        
    elif command -v yum >/dev/null 2>&1; then
        echo -e "${YELLOW}Usando yum (CentOS/RHEL)...${NC}"
        sudo yum install -y openssh-clients iputils nc tar curl wget
        
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "${YELLOW}Usando dnf (Fedora)...${NC}"
        sudo dnf install -y openssh-clients iputils nc tar curl wget
        
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "${YELLOW}Usando pacman (Arch Linux)...${NC}"
        sudo pacman -S --noconfirm openssh iputils gnu-netcat tar curl wget
        
    else
        echo -e "${RED}Gerenciador de pacotes não detectado. Instale manualmente:${NC}"
        echo -e "${WHITE}openssh-client, ping, netcat, tar, curl, wget${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✓ Dependências do Linux instaladas!${NC}"
}

# Função para criar diretórios
setup_directories() {
    echo -e "${BLUE}Configurando diretórios...${NC}"
    
    local config_dir="$HOME/.server_manager"
    local backups_dir="$config_dir/backups"
    
    # Criar diretórios
    mkdir -p "$config_dir"
    mkdir -p "$backups_dir"
    
    # Criar arquivo de configuração vazio se não existir
    if [[ ! -f "$config_dir/servers.conf" ]]; then
        touch "$config_dir/servers.conf"
        echo -e "${GREEN}✓ Arquivo de configuração criado${NC}"
    fi
    
    # Criar arquivo de log
    if [[ ! -f "$config_dir/server_manager.log" ]]; then
        touch "$config_dir/server_manager.log"
        echo -e "${GREEN}✓ Arquivo de log criado${NC}"
    fi
    
    echo -e "${GREEN}✓ Diretórios configurados!${NC}"
}

# Função para configurar permissões
setup_permissions() {
    echo -e "${BLUE}Configurando permissões...${NC}"
    
    # Tornar o script executável
    chmod +x server-manager.sh
    
    # Configurar permissões do diretório de configuração
    chmod 755 "$HOME/.server_manager"
    chmod 644 "$HOME/.server_manager/servers.conf"
    chmod 644 "$HOME/.server_manager/server_manager.log"
    
    echo -e "${GREEN}✓ Permissões configuradas!${NC}"
}

# Função para criar atalho
create_shortcut() {
    echo -e "${BLUE}Criando atalho de acesso...${NC}"
    
    local script_dir="$(pwd)"
    local script_path="$script_dir/server-manager.sh"
    local shortcut_path="$HOME/.local/bin/server-manager"
    
    # Criar diretório .local/bin se não existir
    mkdir -p "$HOME/.local/bin"
    
    # Criar link simbólico
    if [[ ! -L "$shortcut_path" ]]; then
        ln -sf "$script_path" "$shortcut_path"
        echo -e "${GREEN}✓ Atalho criado: $shortcut_path${NC}"
    else
        echo -e "${YELLOW}Atalho já existe${NC}"
    fi
    
    # Adicionar ao PATH se necessário
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo -e "${YELLOW}Adicionando $HOME/.local/bin ao PATH...${NC}"
        
        # Detectar shell
        local shell_config=""
        if [[ -f "$HOME/.bashrc" ]]; then
            shell_config="$HOME/.bashrc"
        elif [[ -f "$HOME/.zshrc" ]]; then
            shell_config="$HOME/.zshrc"
        elif [[ -f "$HOME/.profile" ]]; then
            shell_config="$HOME/.profile"
        fi
        
        if [[ -n "$shell_config" ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_config"
            echo -e "${GREEN}✓ PATH atualizado em $shell_config${NC}"
            echo -e "${YELLOW}Recarregue o terminal ou execute: source $shell_config${NC}"
        fi
    fi
}

# Função para criar alias no Termux
create_termux_alias() {
    echo -e "${BLUE}Criando alias para Termux...${NC}"
    
    local script_dir="$(pwd)"
    
    # Adicionar ao .bashrc do Termux
    if ! grep -q "server-manager" "$HOME/.bashrc" 2>/dev/null; then
        echo "alias sm='$script_dir/server-manager.sh'" >> "$HOME/.bashrc"
        echo -e "${GREEN}✓ Alias 'sm' criado${NC}"
        echo -e "${YELLOW}Use 'sm' para executar o gerenciador${NC}"
    else
        echo -e "${YELLOW}Alias já existe${NC}"
    fi
}

# Função para verificar instalação
verify_installation() {
    echo -e "${BLUE}Verificando instalação...${NC}"
    
    local errors=0
    
    # Verificar script principal
    if [[ ! -f "server-manager.sh" ]]; then
        echo -e "${RED}✗ Script principal não encontrado${NC}"
        ((errors++))
    else
        echo -e "${GREEN}✓ Script principal encontrado${NC}"
    fi
    
    # Verificar dependências
    local deps=("ssh" "ping" "nc" "tar")
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ $dep disponível${NC}"
        else
            echo -e "${RED}✗ $dep não encontrado${NC}"
            ((errors++))
        fi
    done
    
    # Verificar diretórios
    if [[ -d "$HOME/.server_manager" ]]; then
        echo -e "${GREEN}✓ Diretório de configuração criado${NC}"
    else
        echo -e "${RED}✗ Diretório de configuração não encontrado${NC}"
        ((errors++))
    fi
    
    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✓ Instalação verificada com sucesso!${NC}"
        return 0
    else
        echo -e "${RED}✗ $errors erros encontrados${NC}"
        return 1
    fi
}

# Função principal de instalação
main() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}          INSTALADOR - GERENCIADOR DE SERVIDORES          ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Detectar ambiente
    local env=$(detect_environment)
    echo -e "${BLUE}Ambiente detectado: ${YELLOW}$env${NC}"
    echo ""
    
    # Verificar se está no diretório correto
    if [[ ! -f "server-manager.sh" ]]; then
        echo -e "${RED}Erro: Execute o instalador no mesmo diretório do server-manager.sh${NC}"
        exit 1
    fi
    
    # Instalar dependências
    case $env in
        "termux")
            install_termux_deps
            create_termux_alias
            ;;
        "linux")
            install_linux_deps
            create_shortcut
            ;;
        "macos")
            echo -e "${YELLOW}Para macOS, instale manualmente com Homebrew:${NC}"
            echo -e "${WHITE}brew install openssh netcat tar${NC}"
            ;;
        *)
            echo -e "${RED}Ambiente não suportado automaticamente${NC}"
            echo -e "${YELLOW}Instale manualmente: openssh, ping, netcat, tar${NC}"
            ;;
    esac
    
    echo ""
    
    # Configurar sistema
    setup_directories
    setup_permissions
    
    echo ""
    
    # Verificar instalação
    if verify_installation; then
        echo ""
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${WHITE}                    INSTALAÇÃO CONCLUÍDA!                  ${GREEN}║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${CYAN}Para executar o sistema:${NC}"
        
        if [[ "$env" == "termux" ]]; then
            echo -e "${WHITE}• Execute: ${YELLOW}./server-manager.sh${NC}"
            echo -e "${WHITE}• Ou use: ${YELLOW}sm${NC} (depois de recarregar o terminal)"
        else
            echo -e "${WHITE}• Execute: ${YELLOW}./server-manager.sh${NC}"
            echo -e "${WHITE}• Ou globalmente: ${YELLOW}server-manager${NC}"
        fi
        
        echo ""
        echo -e "${CYAN}Primeiros passos:${NC}"
        echo -e "${WHITE}1. Execute o sistema${NC}"
        echo -e "${WHITE}2. Adicione seus servidores${NC}"
        echo -e "${WHITE}3. Conecte-se via SSH${NC}"
        echo ""
        echo -e "${YELLOW}Documentação disponível em: README.md${NC}"
    else
        echo -e "${RED}Instalação incompleta. Verifique os erros acima.${NC}"
        exit 1
    fi
}

# Executar instalação
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
