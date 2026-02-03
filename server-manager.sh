#!/bin/bash

# Sistema de Menu para Gerenciamento de Servidores Remotos
# Versão Avançada v2.0 - Otimizado para Termux/Android
# Autor: Sistema de Administração

# Cores para melhor visualização
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Cores neon para look tecnológico
NEON_GREEN='\033[38;5;82m'
NEON_CYAN='\033[38;5;87m'
NEON_PINK='\033[38;5;201m'
NEON_ORANGE='\033[38;5;208m'

# Diretório de configuração
CONFIG_DIR="$HOME/.server_manager"
SERVERS_FILE="$CONFIG_DIR/servers.conf"
LOG_FILE="$CONFIG_DIR/server_manager.log"

# Versão do sistema
VERSION="2.0"

# Criar diretório de configuração se não existir
mkdir -p "$CONFIG_DIR"

# Função para limpar tela (compatível com Termux)
clear_screen() {
    if command -v clear >/dev/null 2>&1; then
        clear
    else
        printf '\033[2J\033[H'
    fi
}

# Função para exibir barra de status
show_status_bar() {
    local date_time=$(date '+%d/%m/%Y %H:%M')
    local server_count=$(count_servers)
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${WHITE}DATA:${NC} $date_time${NC}    ${WHITE}SERVIDORES:${NC} $server_count${NC}    ${WHITE}VERSÃO:${NC} $VERSION${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
}

# Função para contar servidores
count_servers() {
    if [[ -f "$SERVERS_FILE" ]]; then
        wc -l < "$SERVERS_FILE"
    else
        echo "0"
    fi
}

# Função para exibir cabeçalho com estilo tecnológico
show_header() {
    clear_screen
    echo -e "${NEON_CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NC}     ${BOLD}${NEON_GREEN}███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}     ${BOLD}${NEON_GREEN}████╗  ████║ ██╔══██╗████╗  ██║ ██╔══██╗ ██╔════╝ ██╔════╝${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}     ${BOLD}${NEON_GREEN}██╔████╔██║ ███████║██╔██╗ ██║ ███████║ ██║  ███╗███████╗${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}     ${BOLD}${NEON_GREEN}██║╚██╔╝██║ ██╔══██║██║╚██╗██║ ██╔══██║ ██║   ██║╚════██║${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}     ${BOLD}${NEON_GREEN}██║ ╚═╝ ██║ ██║  ██║██║ ╚████║ ██║  ██║ ╚██████╔╝███████║${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}     ${BOLD}${NEON_GREEN}╚═╝     ╚═╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═╝   ╚═╝  ╚═════╝ ╚══════╝${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${BOLD}GERENCIADOR DE SERVIDORES REMOTOS v${VERSION}${NC}                  ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}            ${YELLOW}Otimizado para Termux/Android${NC}                       ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    show_status_bar
    echo ""
}

# Função para pausar com opções
pause_with_options_with_options() {
    echo ""
    echo -e "${WHITE}[Enter] Voltar${NC}    ${WHITE}[0] Menu Anterior${NC}    ${WHITE}[Q] Sair${NC}"
    read -r -n 1 -t 10 key 2>/dev/null || true
    echo ""
    
    case "$key" in
        0)
            return 1
            ;;
        q|Q)
            exit_graceful
            ;;
        *)
            return 0
            ;;
    esac
}

# Função para sair graciosamente
exit_graceful() {
    show_header
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}                                                              ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}           ${WHITE}Obrigado por usar o Gerenciador!${NC}              ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}                                                              ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    log_action "Sistema encerrado pelo usuário"
    exit 0
}

# Função para voltar ao menu anterior
go_back() {
    return 0
}

# Função para exibir SSH salvos em mini painel (header fixo)
show_quick_ssh_panel() {
    if [[ ! -f "$SERVERS_FILE" ]] || [[ ! -s "$SERVERS_FILE" ]]; then
        return
    fi
    
    local count=0
    local max_show=3
    
    echo -e "${NEON_PINK}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PINK}║${NC}  ${BOLD}${WHITE}⚡ CONEXÕES RÁPIDAS:${NC}                                         ${NEON_PINK}║${NC}"
    echo -e "${NEON_PINK}║${NC}  ${WHITE}────────────────────────────────────────────────────────────${NC}  ${NEON_PINK}║${NC}"
    
    while IFS='|' read -r name host port user key && [[ $count -lt $max_show ]]; do
        local status="${RED}● OFF${NC}"
        if ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
            status="${GREEN}● ON${NC}"
        fi
        printf "${NEON_PINK}║${NC}  [${WHITE}%d${NC}] ${CYAN}%-12s${NC} │ ${WHITE}%s:${NC}%s │ %-20s ${NEON_PINK}║${NC}\n" "$((count+1))" "$name" "$host" "$port" "$status"
        ((count++))
    done < "$SERVERS_FILE"
    
    local total=$(wc -l < "$SERVERS_FILE" 2>/dev/null || echo 0)
    local remaining=$((total - max_show))
    if [[ $remaining -gt 0 ]]; then
        echo -e "${NEON_PINK}║${NC}  ${YELLOW}+ $remaining servidor(es) adicional(is) - Veja em 'Listar Servidores'${NC}          ${NEON_PINK}║${NC}"
    fi
    
    echo -e "${NEON_PINK}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Função para log
log_action() {
    local action="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $action" >> "$LOG_FILE"
}

# Função para validar endereço IP
validate_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Função para testar conexão
test_connection() {
    local host="$1"
    local port="${2:-22}"
    
    echo -e "${BLUE}Testando conexão com $host:$port...${NC}"
    
    if ping -c 1 -W 3 "$host" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Host responde ao ping${NC}"
        if nc -z -w3 "$host" "$port" 2>/dev/null; then
            echo -e "${GREEN}✓ Porta $port está aberta${NC}"
            return 0
        else
            echo -e "${RED}✗ Porta $port está fechada${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Host não responde${NC}"
        return 1
    fi
}

# Função para adicionar servidor
add_server() {
    show_header
    echo -e "${GREEN}=== ADICIONAR NOVO SERVIDOR ===${NC}"
    echo ""
    
    read -p "Nome do servidor: " name
    if [[ -z "$name" ]]; then
        echo -e "${RED}Nome não pode ser vazio!${NC}"
        pause_with_options
        return
    fi
    
    read -p "Endereço IP ou domínio: " host
    if [[ -z "$host" ]]; then
        echo -e "${RED}Endereço não pode ser vazio!${NC}"
        pause_with_options
        return
    fi
    
    read -p "Porta SSH (22): " port
    port=${port:-22}
    
    read -p "Usuário SSH: " user
    if [[ -z "$user" ]]; then
        echo -e "${RED}Usuário não pode ser vazio!${NC}"
        pause_with_options
        return
    fi
    
    read -p "Chave SSH (opcional): " key
    
    # Testar conexão
    if test_connection "$host" "$port"; then
        # Salvar no arquivo de configuração
        echo "$name|$host|$port|$user|$key" >> "$SERVERS_FILE"
        echo -e "${GREEN}✓ Servidor '$name' adicionado com sucesso!${NC}"
        log_action "Servidor adicionado: $name ($host:$port)"
    else
        echo -e "${RED}Não foi possível conectar ao servidor. Deseja adicionar mesmo assim? (s/N)${NC}"
        read -r confirm
        if [[ $confirm =~ ^[Ss]$ ]]; then
            echo "$name|$host|$port|$user|$key" >> "$SERVERS_FILE"
            echo -e "${YELLOW}Servidor adicionado sem teste de conexão.${NC}"
            log_action "Servidor adicionado sem teste: $name ($host:$port)"
        fi
    fi
    
    pause_with_options
}

# Função para listar servidores
list_servers() {
    show_header
    echo -e "${GREEN}=== SERVIDORES CONFIGURADOS ===${NC}"
    echo ""
    
    if [[ ! -f "$SERVERS_FILE" ]] || [[ ! -s "$SERVERS_FILE" ]]; then
        echo -e "${YELLOW}Nenhum servidor configurado.${NC}"
        pause_with_options
        return
    fi
    
    local count=1
    while IFS='|' read -r name host port user key; do
        echo -e "${WHITE}$count) ${CYAN}$name${NC}"
        echo -e "   ${BLUE}Host:${NC} $host:$port"
        echo -e "   ${BLUE}Usuário:${NC} $user"
        if [[ -n "$key" ]]; then
            echo -e "   ${BLUE}Chave:${NC} $key"
        fi
        echo ""
        ((count++))
    done < "$SERVERS_FILE"
    
    pause_with_options
}

# Função para conectar via SSH
ssh_connect() {
    while true; do
        show_header
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}                    ${BOLD}CONEXÃO SSH${NC}                         ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        
        if [[ ! -f "$SERVERS_FILE" ]] || [[ ! -s "$SERVERS_FILE" ]]; then
            echo -e "${GREEN}║${NC}                                                              ${GREEN}║${NC}"
            echo -e "${GREEN}║${NC}   ${YELLOW}Nenhum servidor configurado.${NC}                          ${GREEN}║${NC}"
            echo -e "${GREEN}║${NC}   ${WHITE}Adicione servidores antes de conectar.${NC}                 ${GREEN}║${NC}"
            echo -e "${GREEN}║${NC}                                                              ${GREEN}║${NC}"
            echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
            echo ""
            pause_with_options
            return
        fi
        
        show_quick_ssh_panel
        
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}                    ${BOLD}CONEXÃO SSH${NC}                         ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        
        # Listar servidores para seleção
        local count=1
        declare -a servers
        while IFS='|' read -r name host port user key; do
            local status="${RED}OFF${NC}"
            if ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
                status="${GREEN}ON${NC}"
            fi
            echo -e "${GREEN}║${NC}  ${WHITE}[$count]${NC} ${CYAN}%-15s${NC} │ ${WHITE}%s:${NC}%s │ ${status}              ${GREEN}║${NC}" "$name" "$host" "$port"
            servers[$count]="$name|$host|$port|$user|$key"
            ((count++))
        done < "$SERVERS_FILE"
        
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[0]${NC} Voltar ao menu principal                         ${GREEN}║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        read -p "Selecione o servidor (1-$((count-1)) ou 0 para voltar): " choice
        
        if [[ "$choice" == "0" ]]; then
            return
        fi
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -lt $count ]]; then
            IFS='|' read -r name host port user key <<< "${servers[$choice]}"
            
            echo ""
            echo -e "${BLUE}Conectando a $name ($host:$port)...${NC}"
            log_action "Conexão SSH: $name ($host:$port)"
            
            # Construir comando SSH
            local ssh_cmd="ssh"
            if [[ -n "$key" ]]; then
                ssh_cmd="$ssh_cmd -i $key"
            fi
            ssh_cmd="$ssh_cmd -p $port $user@$host"
            
            echo -e "${YELLOW}Use 'exit' para desconectar e voltar a este menu${NC}"
            echo ""
            
            eval "$ssh_cmd"
            
            echo ""
            echo -e "${GREEN}Retornando ao menu de conexão SSH...${NC}"
            sleep 1
        else
            echo -e "${RED}Opção inválida!${NC}"
            sleep 1
        fi
    done
}

# Função para remover servidor
remove_server() {
    show_header
    echo -e "${GREEN}=== REMOVER SERVIDOR ===${NC}"
    echo ""
    
    if [[ ! -f "$SERVERS_FILE" ]] || [[ ! -s "$SERVERS_FILE" ]]; then
        echo -e "${YELLOW}Nenhum servidor configurado.${NC}"
        pause_with_options
        return
    fi
    
    # Listar servidores para seleção
    local count=1
    declare -a servers
    while IFS='|' read -r name host port user key; do
        echo -e "${WHITE}$count) ${CYAN}$name${NC} - $host:$port"
        servers[$count]="$name"
        ((count++))
    done < "$SERVERS_FILE"
    
    echo ""
    read -p "Selecione o servidor para remover (1-$((count-1))): " choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -lt $count ]]; then
        local server_name="${servers[$choice]}"
        
        echo -e "${RED}Tem certeza que deseja remover '$server_name'? (s/N)${NC}"
        read -r confirm
        
        if [[ $confirm =~ ^[Ss]$ ]]; then
            # Criar arquivo temporário sem o servidor removido
            local temp_file=$(mktemp)
            local removed=false
            
            while IFS='|' read -r name host port user key; do
                if [[ "$name" != "$server_name" ]]; then
                    echo "$name|$host|$port|$user|$key" >> "$temp_file"
                else
                    removed=true
                fi
            done < "$SERVERS_FILE"
            
            mv "$temp_file" "$SERVERS_FILE"
            
            if $removed; then
                echo -e "${GREEN}✓ Servidor '$server_name' removido com sucesso!${NC}"
                log_action "Servidor removido: $server_name"
            else
                echo -e "${RED}Erro ao remover servidor.${NC}"
            fi
        fi
    else
        echo -e "${RED}Opção inválida!${NC}"
    fi
    
    pause_with_options
}

# Função para ferramentas de manutenção
maintenance_tools() {
    while true; do
        show_header
        show_quick_ssh_panel
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}              ${BOLD}FERRAMENTAS DE MANUTENÇÃO${NC}                ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[1]${NC} Verificar status de servidores                    ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[2]${NC} Monitorar recursos (CPU, Memória, Disco)        ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[3]${NC} Verificar logs do sistema                       ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[4]${NC} Backup de configurações                         ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[5]${NC} Limpeza de sistema                            ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[6]${NC} Atualizar sistema                             ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[0]${NC} Voltar ao menu principal                       ${GREEN}║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${WHITE}ATALHOS:${NC} ${CYAN}[1-6]${NC} Seleção direta  │  ${CYAN}[0]${NC} Voltar"
        echo ""
        
        read -p "Escolha uma opção: " choice
        
        case $choice in
            1) check_servers_status ;;
            2) monitor_resources ;;
            3) view_logs ;;
            4) backup_configs ;;
            5) cleanup_system ;;
            6) update_system ;;
            0) break ;;
            *) echo -e "${RED}Opção inválida!${NC}"; pause_with_options_with_options ;;
        esac
    done
}

# Função para verificar status dos servidores
check_servers_status() {
    show_header
    echo -e "${GREEN}=== STATUS DOS SERVIDORES ===${NC}"
    echo ""
    
    if [[ ! -f "$SERVERS_FILE" ]] || [[ ! -s "$SERVERS_FILE" ]]; then
        echo -e "${YELLOW}Nenhum servidor configurado.${NC}"
        pause_with_options
        return
    fi
    
    while IFS='|' read -r name host port user key; do
        echo -e "${CYAN}Verificando $name ($host:$port)...${NC}"
        if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Online${NC}"
        else
            echo -e "${RED}✗ Offline${NC}"
        fi
        echo ""
    done < "$SERVERS_FILE"
    
    pause_with_options
}

# Função para monitorar recursos
monitor_resources() {
    show_header
    echo -e "${GREEN}=== MONITORAR RECURSOS ===${NC}"
    echo ""
    echo -e "${BLUE}Este recurso requer conexão SSH ativa.${NC}"
    echo -e "${YELLOW}Use a opção de conexão SSH primeiro, depois execute:${NC}"
    echo ""
    echo -e "${WHITE}• htop${NC} - Monitor de processos"
    echo -e "${WHITE}• top${NC} - Processos em tempo real"
    echo -e "${WHITE}• df -h${NC} - Uso de disco"
    echo -e "${WHITE}• free -h${NC} - Uso de memória"
    echo -e "${WHITE}• uptime${NC} - Tempo de atividade"
    echo ""
    
    pause_with_options
}

# Função para visualizar logs
view_logs() {
    show_header
    echo -e "${GREEN}=== VISUALIZAR LOGS ===${NC}"
    echo ""
    echo -e "${BLUE}Logs disponíveis:${NC}"
    echo ""
    
    if [[ -f "$LOG_FILE" ]]; then
        echo -e "${CYAN}=== Log do Gerenciador ===${NC}"
        tail -20 "$LOG_FILE"
        echo ""
    fi
    
    echo -e "${YELLOW}Para logs do sistema via SSH:${NC}"
    echo -e "${WHITE}• journalctl -f${NC} - Logs do systemd"
    echo -e "${WHITE}• tail -f /var/log/syslog${NC} - Logs do sistema"
    echo -e "${WHITE}• tail -f /var/log/auth.log${NC} - Logs de autenticação"
    
    pause_with_options
}

# Função para backup de configurações
backup_configs() {
    show_header
    echo -e "${GREEN}=== BACKUP DE CONFIGURAÇÕES ===${NC}"
    echo ""
    
    local backup_dir="$CONFIG_DIR/backups"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_file="$backup_dir/servers_backup_$timestamp.tar.gz"
    
    mkdir -p "$backup_dir"
    
    if [[ -f "$SERVERS_FILE" ]]; then
        tar -czf "$backup_file" -C "$CONFIG_DIR" servers.conf server_manager.log 2>/dev/null
        echo -e "${GREEN}✓ Backup criado: $backup_file${NC}"
        log_action "Backup criado: $backup_file"
    else
        echo -e "${YELLOW}Nenhuma configuração para backup.${NC}"
    fi
    
    pause_with_options
}

# Função para limpeza do sistema
cleanup_system() {
    show_header
    echo -e "${GREEN}=== LIMPEZA DO SISTEMA ===${NC}"
    echo ""
    echo -e "${YELLOW}Comandos de limpeza para executar via SSH:${NC}"
    echo ""
    echo -e "${WHITE}• apt autoremove -y${NC} - Remover pacotes não usados"
    echo -e "${WHITE}• apt autoclean${NC} - Limpar cache do apt"
    echo -e "${WHITE}• docker system prune -a${NC} - Limpar Docker"
    echo -e "${WHITE}• journalctl --vacuum-time=7d${NC} - Limpar logs antigos"
    echo -e "${WHITE}• find /tmp -type f -atime +7 -delete${NC} - Limpar temp"
    
    pause_with_options
}

# Função para atualizar sistema
update_system() {
    show_header
    echo -e "${GREEN}=== ATUALIZAR SISTEMA ===${NC}"
    echo ""
    echo -e "${YELLOW}Comandos de atualização para executar via SSH:${NC}"
    echo ""
    echo -e "${WHITE}• apt update && apt upgrade -y${NC} - Atualizar sistema"
    echo -e "${WHITE}• apt dist-upgrade -y${NC} - Atualização completa"
    echo -e "${WHITE}• snap refresh${NC} - Atualizar snaps"
    echo -e "${WHITE}• yum update -y${NC} - Para CentOS/RHEL"
    echo -e "${WHITE}• dnf update -y${NC} - Para Fedora"
    
    pause_with_options
}

# Menu principal
main_menu() {
    while true; do
        show_header
        show_quick_ssh_panel
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}                     ${BOLD}MENU PRINCIPAL${NC}                        ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[1]${NC} Conectar via SSH                                      ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[2]${NC} Adicionar novo servidor                                ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[3]${NC} Listar servidores salvos                             ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[4]${NC} Remover servidor                                     ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[5]${NC} Ferramentas de manutenção                            ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[6]${NC} Configurações do sistema                             ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[0]${NC} Sair do sistema                                      ${GREEN}║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${WHITE}ATALHOS:${NC} ${CYAN}[1-6]${NC} Seleção direta  │  ${CYAN}[0]${NC} Sair  │  ${CYAN}[Q]${NC} Sair rápido"
        echo ""
        
        read -p "Escolha uma opção: " choice
        
        case $choice in
            1) ssh_connect ;;
            2) add_server ;;
            3) list_servers ;;
            4) remove_server ;;
            5) maintenance_tools ;;
            6) settings ;;
            q|Q) exit_graceful ;;
            0) 
                echo -e "${GREEN}Saindo do sistema...${NC}"
                log_action "Sistema finalizado"
                exit 0
                ;;
            *) 
                echo -e "${RED}Opção inválida!${NC}"
                pause_with_options_with_options
                ;;
        esac
    done
}

# Função de configurações
settings() {
    while true; do
        show_header
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}                  ${BOLD}CONFIGURAÇÕES${NC}                          ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[1]${NC} Verificar dependências                               ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[2]${NC} Limpar logs                                       ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[3]${NC} Exportar configurações                             ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[4]${NC} Importar configurações                             ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[5]${NC} Sobre o sistema                                  ${GREEN}║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ${WHITE}[0]${NC} Voltar ao menu principal                           ${GREEN}║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${WHITE}ATALHOS:${NC} ${CYAN}[1-5]${NC} Seleção direta  │  ${CYAN}[0]${NC} Voltar"
        echo ""
        
        read -p "Escolha uma opção: " choice
        
        case $choice in
            1) check_dependencies ;;
            2) clear_logs ;;
            3) export_configs ;;
            4) import_configs ;;
            5) show_about ;;
            0) break ;;
            *) echo -e "${RED}Opção inválida!${NC}"; pause_with_options_with_options ;;
        esac
    done
}

# Verificar dependências
check_dependencies() {
    show_header
    echo -e "${GREEN}=== VERIFICAR DEPENDÊNCIAS ===${NC}"
    echo ""
    
    local deps=("ssh" "ping" "nc" "tar")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ $dep${NC}"
        else
            echo -e "${RED}✗ $dep${NC}"
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo ""
        echo -e "${YELLOW}Dependências faltando: ${missing[*]}${NC}"
        echo -e "${YELLOW}Instale com: pkg install ${missing[*]}${NC}"
    else
        echo ""
        echo -e "${GREEN}Todas as dependências estão instaladas!${NC}"
    fi
    
    pause_with_options
}

# Limpar logs
clear_logs() {
    show_header
    echo -e "${GREEN}=== LIMPAR LOGS ===${NC}"
    echo ""
    
    if [[ -f "$LOG_FILE" ]]; then
        echo -e "${RED}Tem certeza que deseja limpar os logs? (s/N)${NC}"
        read -r confirm
        
        if [[ $confirm =~ ^[Ss]$ ]]; then
            > "$LOG_FILE"
            echo -e "${GREEN}✓ Logs limpos com sucesso!${NC}"
            log_action "Logs limpos pelo usuário"
        fi
    else
        echo -e "${YELLOW}Nenhum log para limpar.${NC}"
    fi
    
    pause_with_options
}

# Exportar configurações
export_configs() {
    show_header
    echo -e "${GREEN}=== EXPORTAR CONFIGURAÇÕES ===${NC}"
    echo ""
    
    local export_file="$HOME/server_manager_export.tar.gz"
    
    if [[ -f "$SERVERS_FILE" ]] || [[ -f "$LOG_FILE" ]]; then
        tar -czf "$export_file" -C "$CONFIG_DIR" servers.conf server_manager.log 2>/dev/null
        echo -e "${GREEN}✓ Configurações exportadas: $export_file${NC}"
        log_action "Configurações exportadas"
    else
        echo -e "${YELLOW}Nenhuma configuração para exportar.${NC}"
    fi
    
    pause_with_options
}

# Importar configurações
import_configs() {
    show_header
    echo -e "${GREEN}=== IMPORTAR CONFIGURAÇÕES ===${NC}"
    echo ""
    
    local import_file="$HOME/server_manager_export.tar.gz"
    
    if [[ -f "$import_file" ]]; then
        echo -e "${RED}Tem certeza que deseja importar? Isso substituirá as configurações atuais. (s/N)${NC}"
        read -r confirm
        
        if [[ $confirm =~ ^[Ss]$ ]]; then
            tar -xzf "$import_file" -C "$CONFIG_DIR"
            echo -e "${GREEN}✓ Configurações importadas com sucesso!${NC}"
            log_action "Configurações importadas"
        fi
    else
        echo -e "${YELLOW}Arquivo de importação não encontrado: $import_file${NC}"
    fi
    
    pause_with_options
}

# Sobre o sistema
show_about() {
    show_header
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}                    ${BOLD}SOBRE O SISTEMA${NC}                      ${GREEN}║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}                                                              ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${NEON_CYAN}███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${NEON_CYAN}████╗  ████║ ██╔══██╗████╗  ██║ ██╔══██╗ ██╔════╝ ██╔════╝${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${NEON_CYAN}██╔████╔██║ ███████║██╔██╗ ██║ ███████║ ██║  ███╗███████╗${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${NEON_CYAN}██║╚██╔╝██║ ██╔══██║██║╚██╗██║ ██╔══██║ ██║   ██║╚════██║${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${NEON_CYAN}██║ ╚═╝ ██║ ██║  ██║██║ ╚████║ ██║  ██║ ╚██████╔╝███████║${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${NEON_CYAN}╚═╝     ╚═╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═╝   ╚═╝  ╚═════╝ ╚══════╝${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}                                                              ${GREEN}║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}Versão:${NC} ${WHITE}$VERSION${NC}                                            ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}Plataforma:${NC} Shell Script (Bash)                          ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}Otimizado para:${NC} Termux/Android                           ${GREEN}║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}   ${WHITE}Recursos do Sistema:${NC}                                   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   • Conexões SSH seguras                              ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   • Gerenciamento de múltiplos servidores             ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   • Mini painel de conexões rápidas                   ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   • Ferramentas de manutenção integradas               ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   • Sistema de backup e restauração                    ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   • Interface tecnológica com atalhos                  ${GREEN}║${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}Diretório:${NC} $CONFIG_DIR                       ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}Servidores:${NC} $SERVERS_FILE                       ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}Logs:${NC} $LOG_FILE                     ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    pause_with_options_with_options
}

# Verificar se está rodando no Termux
check_termux() {
    if [[ -n "$TERMUX_VERSION" ]]; then
        echo -e "${GREEN}Detectado Termux v$TERMUX_VERSION${NC}"
        return 0
    else
        echo -e "${YELLOW}Executando em ambiente Linux padrão${NC}"
        return 1
    fi
}

# Função principal
main() {
    # Verificar ambiente
    check_termux
    
    # Iniciar log
    log_action "Sistema iniciado"
    
    # Exibir mensagem de boas-vindas
    show_header
    echo -e "${GREEN}Bem-vindo ao Gerenciador de Servidores Remotos!${NC}"
    echo ""
    pause_with_options
    
    # Iniciar menu principal
    main_menu
}

# Tratamento de sinais
trap 'echo -e "\n${RED}Sistema interrompido pelo usuário${NC}"; exit 1' INT TERM

# Iniciar sistema
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
