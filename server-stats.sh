#!/bin/bash

show_system_info() {
    local os_version=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    local kernel_version=$(uname -r)
    local uptime=$(uptime -p | sed 's/up //')
    local users_logged_in=$(who)
    
    echo "System Information:"
    echo "OS Version: ${os_version}"
    echo "Kernel Version: ${kernel_version}"
    echo -e "\nSystem Uptime: $uptime"
    echo -e "Logged in users:\n${users_logged_in}"
}

show_cpu_usage() {
    local cpu_stats=$(top -bn1 | grep 'Cpu(s)' | cut -d"," -f4 | awk '{print 100-$1 "%"}')

    echo -e "\nCPU Usage: ${cpu_stats}"
}

show_memory_usage() {
    local mem_total mem_used mem_free
    read mem_total mem_used mem_free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
    local mem_usedperc=$(awk "BEGIN {printf \"%.2f%%\", $mem_used/$mem_total * 100}")
    local mem_freeperc=$(awk "BEGIN {printf \"%.2f%%\", 100 - $mem_used/$mem_total * 100}")

    echo -e "\nMemory Usage:"
    echo "Total Memory: ${mem_total} MB"
    echo "Used Memory: ${mem_used} MB (${mem_usedperc})"
    echo "Free Memory: ${mem_free} MB (${mem_freeperc})"
}

show_disk_usage() { 
    local str_total str_used str_free str_usedperc
    read str_total str_used str_free str_usedperc <<< $(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
    local str_freeperc=$(awk "BEGIN {printf \"%.0f%%\", 100 - ${str_usedperc%\%}}")

    echo -e "\nDisk Usage:"
    echo "Total Storage: ${str_total}B"
    echo "Used Storage: ${str_used}B (${str_usedperc})"
    echo -e "Free Storage: ${str_free}B (${str_freeperc})"
}

show_top_processes() {
    echo -e "\nTop Processes by RAM Usage:"
    ps aux --sort -%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'

    echo -e "\nTop Processes by CPU Usage:"
    ps aux --sort -%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $3 "\t" $11}'
}

show_system_info
show_cpu_usage
show_memory_usage
show_disk_usage
show_top_processes
