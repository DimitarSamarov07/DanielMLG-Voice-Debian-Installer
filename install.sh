#!/bin/bash

# Check if user has root privileges
if [[ $EUID -ne 0 ]]; then
echo "You must run the script as root or using sudo"
   exit 1
fi


if test $SUDO_USER -gt 0; then
eval wine_prefix_path=~$USER/.sapi5
curr_user=$USER
else
eval wine_prefix_path=~$SUDO_USER/.sapi5
curr_user=$SUDO_USER
fi

mkdir $wine_prefix_path


create_and_enter_tmp_directory(){
    cd $(mktemp -d -t sapi5-XXXXXXXXXX)
}

install_apt_requires(){
    dpkg --add-architecture i386
    apt update
    apt install --reinstall wine64 wine32 wine-development winetricks wget unzip
}

install_requires(){
    install_apt_requires
    create_and_enter_tmp_directory
    get_installation_files
}

get_installation_files(){
    wget -O Daniel_MLG.exe https://archive.org/download/DanielMLGEnglishVoiceForBalabolka90mb/Daniel%20MLG%20english%20voice%20for%20balabolka%2090mb.exe
    wget -O balcon.zip http://www.cross-plus-a.com/balcon.zip
    echo "Unzipping..."
    unzip -q balcon.zip -d ./balcon
}

create_wine_prefix(){
    WINEPREFIX=$wine_prefix_path WINEARCH=win32 winecfg
}

move_files_to_prefix_and_change_dir(){
    mv ./Daniel_MLG.exe $wine_prefix_path
    mv ./balcon $wine_prefix_path/drive_c
    cd $wine_prefix_path
}

run_installation_files(){
    WINEPREFIX=$wine_prefix_path winetricks speechsdk
    WINEPREFIX=$wine_prefix_path wine Daniel_MLG.exe
}

change_wine_owner(){
    chown -R $curr_user $wine_prefix_path
}

do_wine_magic(){
    create_wine_prefix
    move_files_to_prefix_and_change_dir
    run_installation_files
    change_wine_owner  
}

install_requires
do_wine_magic
