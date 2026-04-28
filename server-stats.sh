#!/bin/bash

show_system_info() {
    local os_version=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    local kernel_version=$(uname -r)
    local uptime=$(uptime -p | sed 's/up //')
    local users_logged_in=$(who)
    
    echo "Informações do sistema:"
    echo "Versão do Sistema Operacional: ${os_version}"
    echo "Versão do Kernel: ${kernel_version}"
    echo -e "\nTempo de atividade do sistema: $uptime"
    echo -e "Usuários logados:\n${users_logged_in}"
}

show_cpu_usage() {
    local cpu_stats=$(top -bn1 | grep 'Cpu(s)' | cut -d"," -f4 | awk '{print 100-$1 "%"}')

    echo -e "\nStatus do CPU do sistema:"
    echo "Uso do CPU: ${cpu_stats}"
}

show_memory_usage() {
    local mem_total mem_used mem_free
    read mem_total mem_used mem_free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
    local mem_usedperc=$(awk "BEGIN {printf \"%.2f%%\", $mem_used/$mem_total * 100}")
    local mem_freeperc=$(awk "BEGIN {printf \"%.2f%%\", 100 - $mem_used/$mem_total * 100}")

    echo -e "\nStatus da memória do sistema:"
    echo "Memoria total: ${mem_total} MB"
    echo "Memoria usada: ${mem_used} MB (${mem_usedperc})"
    echo "Memoria livre: ${mem_free} MB (${mem_freeperc})"
}

show_disk_usage() {
    local str_total str_used str_free str_usedperc
    read str_total str_used str_free str_usedperc <<< $(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
    local str_freeperc=$(awk "BEGIN {printf \"%.0f%%\", 100 - ${str_usedperc%\%}}")

    echo -e "\nStatus do disco do sistema:"
    echo "Armazenamento total: ${str_total}B"
    echo "Armazenamento usado: ${str_used}B (${str_usedperc})"
    echo -e "Armazenamento livre: ${str_free}B (${str_freeperc})"
}

show_top_processes() {
    echo -e "\nProcessos com maior uso de RAM:"
    ps aux --sort -%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'

    echo -e "\nProcessos com maior uso de CPU:"
    ps aux --sort -%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $3 "\t" $11}'
}

show_system_info
show_cpu_usage
show_memory_usage
show_disk_usage
show_top_processes
