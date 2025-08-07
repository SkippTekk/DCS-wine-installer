#!/bin/bash

# Script directory

if [ "$(id -u)" -eq 0 ]; then
    echo "This script is not supposed to be run as root!"
    exit 1
fi

script_dir="$(realpath "$0" | xargs -0 dirname)"

#DCS official URL
dcs_url="https://www.digitalcombatsimulator.com/en/downloads/world/stable/"
dcs_installer="DCS_World_web.exe"

#SRS Github URL
srs_git="https://github.com/ciribob/DCS-SimpleRadioStandalone/releases"
srs_installer="SRS-AutoUpdater.exe"
#Wine download URL
wine_download="https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz"
wine_file="wine-lutris-GE-Proton8-26-x86_64.tar.xz"

function option1 {
    echo "Alright, so you wanted to installed DCS on wine... Lets get to it!" 
    echo "Alright, where you wanna install it."
    install_dir="$(zenity --file-selection --directory --title="Choose your DCS install location" --filename="$HOME/" 2>/dev/null)"

        cd "$install_dir"
        mkdir runner 
        echo "unzipping "$wine_file""
        tar -xf "$script_dir"/tmp/"$wine_file" -C runner/
        

    export wine_path=""$install_dir"/runner/lutris-GE-Proton8-26-x86_64/bin"

    echo "awesome, your game SHOULD be installing into "$install_dir" now..."

    echo "DEBUG: Install dir is "$install_dir" and is running it's task."
    export WINEPREFIX="$install_dir"
    export WINEDLLOVERRIDES="wbemprox=n"

    # Install verbs into the prefix with winetricks
    winetricks -q dxvk vcrun2017 d3dcompiler_43 d3dcompiler_47 d3dx9 win10

    "$wine_path"/wineserver -k
    "$wine_path"/wine ""$script_dir"/tmp/"$dcs_installer""
    "$wine_path"/wineserver -k
    
    exit
}

function option3 {
    installer_found="false"
    while [ "$installer_found" = "false" ]; do
    if [ -f ""$script_dir"/tmp/"$wine_file"" ]; then
            installer_found="true"
            echo "Runner already downloaded, ignoring"
        else
            echo "Runner not found, installing now."
        echo "Downloading runner from RawFox"
        echo "Moving into "$script_dir""
            cd "$script_dir"
        echo "creating tmp directory"
            mkdir "$script_dir"/tmp
        echo "moving into tmp"
            cd "$script_dir"/tmp
        echo "downloading file"
            wget $wine_download -q --show-progress
    fi

    if [ -f ""$script_dir"/tmp/"$dcs_installer"" ]; then
        installer_found="true"
            echo "just to make sure, that "$dcs_installer" existed, and it does!" && echo "\o/ woot. \o/" && echo "Now for the next steps"
        else
            echo ""$dcs_installer" not found... Please download it manually from "$dcs_url". And place into "$script_dir"/tmp folder"
    fi
    if [ -f "$script_dir/tmp/$srs_installer" ]; then
        installer_found="true"
            echo "just to make sure, that "$srs_installer" existed, and it does!"
    else
        echo ""$srs_installer" not found... Please download it manually from "$srs_git" and place into "$script_dir"/tmp folder"
    fi
    done


}

options=("Install DCS on pure wine" "Download DCS and SRS into tmp folder." "Get help (discord)" "Exit")

PS3="Please select on what you need: "

select opt in "${options[@]}"; do

    case $REPLY in
    1) option1 ;;
    2) option3 ;;
    3) echo "Join the Community Discord and ask for the Linux channel! https://discord.gg/7NFYC73med " ;;
    4) echo "good bye, thanks for using this! " && exit ;;
    *) echo "Invalid option, please use a number that is listed"
        
    esac
done