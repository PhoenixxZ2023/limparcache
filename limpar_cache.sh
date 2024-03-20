#!/bin/bash

# Função para limpar o cache
limpar_cache() {
    sudo sysctl -w vm.drop_caches=3 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Cache liberado com sucesso."
    else
        echo "Ocorreu um erro ao liberar o cache."
    fi
}

# Função para instalar o script
instalar_script() {
    # Verifica se o usuário é root
    if [[ $EUID -ne 0 ]]; then
        echo "Este script precisa ser executado com privilégios de superusuário (root)." 
        exit 1
    fi

    # Cria um diretório para o script
    mkdir -p /usr/local/bin/limpar_cache

    # Cria o script dentro do diretório
    echo '#!/bin/bash' > /usr/local/bin/limpar_cache/limpar_cache.sh
    echo 'sudo sysctl -w vm.drop_caches=3 > /dev/null 2>&1' >> /usr/local/bin/limpar_cache/limpar_cache.sh
    chmod +x /usr/local/bin/limpar_cache/limpar_cache.sh

    # Cria um link simbólico para o script
    ln -s /usr/local/bin/limpar_cache/limpar_cache.sh /usr/local/bin/limpar_cache

    echo "Script de limpeza de cache instalado com sucesso."
}

# Verifica se o script foi chamado com a opção "install"
if [ "$1" == "install" ]; then
    instalar_script
else
    limpar_cache
fi
