#!/bin/bash

# Check if user has root privileges
if [[ $EUID -ne 0 ]]; then
echo "You must run the script as root or using sudo"
   exit 1
fi

create_and_enter_tmp_directory(){
    cd $(mktemp -d -t sapi5-XXXXXXXXXX)
}

install_apt_requires(){
    apt update
    apt install --reinstall wine64 wine32 winetricks wget unzip
}

install_requires(){
    install_apt_requires
    create_and_enter_tmp_directory
    get_installation_files

    mkdir ~/.sapi5
}

get_installation_files(){
    wget -O Daniel_MLG.exe https://archive.org/download/DanielMLGEnglishVoiceForBalabolka90mb/Daniel%20MLG%20english%20voice%20for%20balabolka%2090mb.exe
    wget -O balcon.zip http://www.cross-plus-a.com/balcon.zip
    echo "Unzipping..."
    unzip -q balcon.zip -d ./balcon
}

install_requires