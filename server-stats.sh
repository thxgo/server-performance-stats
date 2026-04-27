#!/bin/bash


echo -e "Informações do sistema:"

OS_VERSION=$(lsb_release -a | awk '/Description:/ {print $2, $3, $4}')

echo -e "Versão do Sistema Operacional: ${OS_VERSION}"

echo -e "\nUptime:"

UPTIME=$(uptime -p | sed 's/up //')

echo "Tempo de atividade do sistema: $UPTIME"

echo -e "\nStatus do CPU do sistema:"

CPU_STATS=$(top -bn1 | grep 'Cpu(s)' | cut -d"," -f4 | awk '{print 100-$1 "%"}')

echo "Uso do CPU: ${CPU_STATS}"

echo -e "\nStatus da memória do sistema:"

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USEDPERC=$(free -m | awk '/Mem:/ {printf "%.2f%%\n", $3/$2 * 100}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREEPERC=$(free -m | awk '/Mem:/ {printf "%.2f%%\n", 100 - $3/$2 * 100'})

echo "Memoria total: ${MEM_TOTAL} MB"
echo "Memoria usada: ${MEM_USED} MB (${MEM_USEDPERC})"
echo "Memoria livre: ${MEM_FREE} MB (${MEM_FREEPERC})"

echo -e "\n\nStatus do disco do sistema:"
# remover redundancia usando read TOTAL USED <<< df  etc.. mesma coisa pro MEM
STR_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
STR_USED=$(df -h / | awk 'NR==2 {print $3}') 
STR_USEDPERC=$(df -h / | awk 'NR==2 {print $5}')
STR_FREE=$(df -h / | awk 'NR==2 {print $4}')
STR_FREEPERC=$(df -h / | awk 'NR==2 {printf 100 - $5 "%"}')

echo "Armazenamento total: ${STR_TOTAL}B"
echo "Armazenamento usado: ${STR_USED}B (${STR_USEDPERC})"
echo -e "Armazenamento livre: ${STR_FREE}B (${STR_FREEPERC})"

echo -e "\n\nProcessos com maior uso de RAM:"

ps aux --sort -%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'

echo -e "\n\nProcessos com maior uso de CPU:"

ps aux --sort -%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $3 "\t" $11}'
