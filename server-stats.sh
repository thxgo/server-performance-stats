#!/bin/bash

echo "Informações do sistema:"

OS_VERSION=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
KERNEL_VERSION=$(uname -r)

echo "Versão do Sistema Operacional: ${OS_VERSION}"
echo "Versão do Kernel: ${KERNEL_VERSION}"

UPTIME=$(uptime -p | sed 's/up //')
USERS_LOGGED_IN=$(who)

echo -e  "\nTempo de atividade do sistema: $UPTIME"
echo -e "Usuários logados:\n${USERS_LOGGED_IN}" 

echo -e "\nStatus do CPU do sistema:"

CPU_STATS=$(top -bn1 | grep 'Cpu(s)' | cut -d"," -f4 | awk '{print 100-$1 "%"}')

echo "Uso do CPU: ${CPU_STATS}"

echo -e "\nStatus da memória do sistema:"

read MEM_TOTAL MEM_USED MEM_FREE <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
MEM_USEDPERC=$(awk "BEGIN {printf \"%.2f%%\", $MEM_USED/$MEM_TOTAL * 100}")
MEM_FREEPERC=$(awk "BEGIN {printf \"%.2f%%\", 100 - $MEM_USED/$MEM_TOTAL * 100}")

echo "Memoria total: ${MEM_TOTAL} MB"
echo "Memoria usada: ${MEM_USED} MB (${MEM_USEDPERC})"
echo "Memoria livre: ${MEM_FREE} MB (${MEM_FREEPERC})"

echo -e "\n\nStatus do disco do sistema:"

read STR_TOTAL STR_USED STR_FREE STR_USEDPERC <<< $(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
STR_FREEPERC=$(awk "BEGIN {printf \"%.0f%%\", 100 - ${STR_USEDPERC%\%}}")

echo "Armazenamento total: ${STR_TOTAL}B"
echo "Armazenamento usado: ${STR_USED}B (${STR_USEDPERC})"
echo -e "Armazenamento livre: ${STR_FREE}B (${STR_FREEPERC})"

echo -e "\n\nProcessos com maior uso de RAM:"

ps aux --sort -%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'

echo -e "\n\nProcessos com maior uso de CPU:"

ps aux --sort -%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $3 "\t" $11}'
