# Gerenciador de Servidores Remotos

Sistema completo em shell script para acesso remoto e manutenção de servidores, otimizado para uso no Termux/Android.

## 🚀 Recursos

- **Conexões SSH seguras** com suporte a chaves personalizadas
- **Gerenciamento de múltiplos servidores** com sistema de favoritos
- **Interface amigável** otimizada para telas de celular
- **Ferramentas de manutenção** integradas
- **Sistema de backup** e restauração de configurações
- **Logs detalhados** de todas as operações
- **Teste de conectividade** antes de conectar

## 📋 Requisitos

### Para Termux/Android:
```bash
pkg update && pkg upgrade
pkg install openssh ping net-tools tar nc
```

### Para Linux:
```bash
# Debian/Ubuntu
sudo apt update && sudo apt install openssh-client ping netcat-openbsd tar

# CentOS/RHEL
sudo yum install openssh-clients iputils nc tar

# Fedora
sudo dnf install openssh-clients iputils nmap-ncat tar
```

## 🛠️ Instalação

1. Clone ou baixe os arquivos:
```bash
git clone <repositório>
cd Meu-sh
```

2. Dê permissão de execução:
```bash
chmod +x server-manager.sh
```

3. Execute o sistema:
```bash
./server-manager.sh
```

## 📖 Como Usar

### Menu Principal
- **1) Conectar via SSH**: Conecte-se aos servidores configurados
- **2) Adicionar servidor**: Configure novos servidores remotos
- **3) Listar servidores**: Veja todos os servidores salvos
- **4) Remover servidor**: Exclua servidores da lista
- **5) Ferramentas de manutenção**: Acesso a utilitários do sistema
- **6) Configurações**: Gerencie o sistema

### Adicionando um Servidor
1. Escolha "Adicionar servidor" no menu
2. Informe:
   - Nome identificador
   - Endereço IP ou domínio
   - Porta SSH (padrão: 22)
   - Usuário SSH
   - Caminho da chave SSH (opcional)

### Conectando via SSH
1. Selecione "Conectar via SSH"
2. Escolha o servidor da lista
3. Use `exit` para retornar ao menu

## 🎯 Ferramentas de Manutenção

### Status dos Servidores
- Verifica conectividade de todos os servidores
- Teste de ping e porta SSH

### Monitoramento de Recursos
Comandos úteis para executar via SSH:
- `htop` - Monitor de processos avançado
- `top` - Processos em tempo real
- `df -h` - Uso de disco
- `free -h` - Uso de memória
- `uptime` - Tempo de atividade

### Sistema de Logs
- Logs do próprio gerenciador
- Logs do sistema via SSH
- `journalctl -f` - Logs do systemd
- `tail -f /var/log/syslog` - Logs do sistema

### Backup e Restauração
- Backup automático das configurações
- Exportação/importação de servidores
- Histórico de operações

## 📁 Estrutura de Arquivos

```
~/.server_manager/
├── servers.conf          # Configuração dos servidores
├── server_manager.log    # Logs do sistema
└── backups/              # Backups automáticos
    └── servers_backup_YYYYMMDD_HHMMSS.tar.gz
```

## 🔧 Configurações Avançadas

### Formato do Arquivo de Servidores
```
nome|host|porta|usuario|chave_ssh
```

Exemplo:
```
servidor-web|192.168.1.100|22|admin|/storage/emulated/0/keys/web_key
servidor-db|db.example.com|2222|root|
```

### Variáveis de Ambiente
- `TERMUX_VERSION`: Detecta automaticamente o Termux
- `SSH_CONFIG`: Arquivo de configuração SSH personalizado

## 🚨 Dicas de Uso no Termux

### Teclas de Atalho
- `Ctrl+C`: Cancelar operação
- `Ctrl+Z`: Suspender processo
- `Ctrl+D`: Sair da sessão SSH

### Otimizações para Celular
- Interface com cores e menus numerados
- Pausas automáticas para leitura
- Validação de entrada de dados
- Compatibilidade com tela sensível ao toque

### Gerenciamento de Chaves SSH
```bash
# Gerar chave no Termux
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Copiar chave para servidor
ssh-copy-id user@server

# Usar chave personalizada
ssh -i /path/to/key user@server
```

## 🔒 Segurança

- Senhas não são armazenadas
- Suporte completo a chaves SSH
- Logs de acesso registrados
- Validação de endereços IP
- Teste de conectividade antes de conectar

## 🐛 Solução de Problemas

### Erro Comum: "ssh: command not found"
```bash
pkg install openssh
```

### Erro Comum: "nc: command not found"
```bash
pkg install nettools
```

### Conexão Recusada
- Verifique se o servidor SSH está rodando
- Confirme a porta correta
- Teste conectividade com `ping host`

### Problemas com Chaves SSH
- Verifique permissões: `chmod 600 key_file`
- Teste manualmente: `ssh -i key user@host`

## 📝 Logs e Depuração

O sistema mantém logs detalhados em `~/.server_manager/server_manager.log`:
- Timestamp de cada operação
- Servidores conectados
- Erros e avisos
- Alterações de configuração

## 🔄 Atualizações

Para atualizar o sistema:
1. Faça backup das configurações
2. Substitua o arquivo `server-manager.sh`
3. Mantenha o diretório `~/.server_manager/`

## 📞 Suporte

Em caso de problemas:
1. Verifique os logs em `~/.server_manager/server_manager.log`
2. Confirme as dependências instaladas
3. Teste a conectividade manualmente

## 📄 Licença

Este projeto é open-source e pode ser modificado conforme necessidade.

---

**Desenvolvido para administradores de sistemas que precisam de mobilidade e eficiência na gestão de servidores remotos.**
# SSHCLIENTE-BASH
