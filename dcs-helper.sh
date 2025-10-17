#!/bin/bash

#DCS official URL
dcs_url="https://www.digitalcombatsimulator.com/upload/iblock/959/d33ul8g3arxnzc1ejgdaa8uev8gvmew2/DCS_World_web.exe"
dcs_installer="DCS_World_web.exe"

#SRS Github URL
srs_git="https://github.com/ciribob/DCS-SimpleRadioStandalone/releases/download/2.1.1.0/DCS-SimpleRadioStandalone-2.1.1.0.zip"
srs_installer="DCS-SimpleRadioStandalone-2.1.1.0.zip"

#Wine download URL
wine_download="https://github.com/Kron4ek/Wine-Builds/releases/download/10.16/wine-10.16-staging-tkg-amd64.tar.xz"
wine_file="wine-10.16-staging-tkg-amd64.tar.xz"
wine_folder="wine-10.16-staging-tkg-amd64"

# Options lua config file download and file name
options_download="https://raw.githubusercontent.com/deleterium/dcs_on_linux/refs/heads/master/options.lua"
options_file="options.lua"

# My github location.
github="https://github.com/SkippTekk/DCS-wine-installer"



#Just check if user ran it as root aka sudo. WHICH IS A NO NO

if [ "$(id -u)" -eq 0 ]; then
    echo "This script is not supposed to be run as root!"
    exit 1
fi


# Script directory
script_dir="$(realpath "$0" | xargs -0 dirname)"

# Creates the config file. DO NOT EDIT THE SCRIPT FILE IT WILL BREAK IF YOU DO
if [ -f "$script_dir/config.cfg" ]; then
        echo "Config file found... using it"
    else
        touch "$script_dir"/config.cfg
fi

#shell config file... hopefully this works cause i need it now.... crap
source $script_dir/config.cfg

fileDownloads() {
    if [ -d "$script_dir/files" ]; then
        echo "$script_dir/files" exists. Neat
    else
        echo "$script_dir/files doesn't exist. Creating"
        mkdir "$script_dir/files"
        echo "$script_dir/files created."
    fi
    if [ -f "$script_dir/files/$dcs_installer" ]; then
        echo "File $dcs_installer exists, Skipping"
    else
        echo "File $dcs_installer doesn't exists, Downloading"
        cd "$script_dir/files"
        wget "$dcs_url" -q --show-progress
        echo "File $dcs_installer downloaded."
    fi
    if [ -f "$script_dir/files/$options_file" ]; then
        echo "File $options_file exists, Skipping"
    else
        echo "File $options_file doesn't exists, Downloading"
        cd "$script_dir/files"
        wget "$options_download" -q --show-progress
        echo "File $options_file downloaded."
    fi
    if [ -f "$script_dir/files/$wine_file" ]; then
        echo "File $wine_file exists, Skipping"
    else
        echo "File $wine_file doesn't exists, Downloading"
        cd "$script_dir/files"
        wget "$wine_download" -q --show-progress
        echo "File $wine_file downloaded."
    fi

    zenity --info --title="File Downloads" --text="Congrats, all the files are downloaded and or already downloaded."
}

directory(){
    if [ "$GAME_DIR" = "" ]; then
        install_dir="$(zenity --file-selection --directory --title="Choose your DCS install location" --filename="$HOME/" 2>/dev/null)"
        if [ -z "$install_dir" ]; then
            zenity --warning --title="Directory Choosing" --text="No installation directory selected. Exiting."
            return
        fi
            echo GAME_DIR="$install_dir" > "$script_dir"/config.cfg
            zenity --info --title="Directory choosing" --text="Location $install_dir selected "

    else
        if zenity --question --title="Directory choosing" --text="Directory already choosen. Change Directory?"; then
            install_dir="$(zenity --file-selection --directory --title="Choose your DCS install location" --filename="$HOME/" 2>/dev/null)"
            echo GAME_DIR="$install_dir" > "$script_dir"/config.cfg
        fi
    fi

}

wineCheck(){
    if command -v wine > /dev/null 2>&1; then
        echo "Wine is installed"
    else
        echo "Wine needs to be installed"
    fi
}
wineTricksCheck(){
    if command -v winetricks > /dev/null 2>&1; then
        echo "Winetricks is installed"
    else
        echo "Winetricks needs to be installed"
    fi
}



dcsInstall() {
    if [ "$GAME_DIR" = "" ]; then
        zenity --warning --title="DCS install" --text="Error, please run the Directory and the Files first before this."
    else
        echo "generating cache folder"
        cd "$GAME_DIR"
        mkdir cache runner
        echo "Created folders cache and runner"
        fileDownloads
        echo "Choosen location is $GAME_DIR, installing there."

    tar -xvf "$script_dir/files/$wine_file" -C "$GAME_DIR"/runner/ 2> /dev/null
     


        echo "setting up wine stuff"

        export WINEPREFIX="$GAME_DIR"
        export WINEDLLOVERRIDES="wbemprox=n"
        export wine_path="$WINEPREFIX/runner/$wine_folder/bin/"

        winetricks -q dxvk vcrun2017 d3dcompiler_43 d3dcompiler_47 d3dx9 dotnet8 win11

        # wine "$script_dir/files/$dcs_installer"

        "$wine_path/wineserver" -k
        "$wine_path/wine" "$script_dir/files/$dcs_installer"
        "$wine_path/wineserver" -k
    fi
}

wineCFG() {
    export WINEPREFIX="$GAME_DIR"

    wine winecfg
}

wineTricksCFG() {
    export WINEPREFIX="$GAME_DIR"

    winetricks
}


blackScreenPatch(){
    if [ -f "$GAME_DIR/drive_c/users/$USER/Saved Games/DCS/Config/$options_file" ]; then
        echo "$options_file is found, skipping"
    else
        echo "$options_file file not found, gotta move it"
            cp "$script_dir/$options_file" "$GAME_DIR/drive_c/users/$USER/Saved Games/DCS/Config/$options_file"
        echo "file moved, Please start the game up again"
    fi
}

dcsSRS() { 
    zenity --question --title="SRS install" --text="You sure you want to install SRS?"
        if [ -f "$script_dir/files/$srs_installer" ]; then
            cd "$script_dir/files"
            mkdir srs
            unzip -d srs "$srs_installer"

            zenity --error --title="SRS install" --text="DO NOT UPDATE THIS PAST THIS, currently this is the ONLY version that works on linux...."

                export WINEPREFIX="$GAME_DIR"
                export wine_path="$WINEPREFIX/runner/$wine_folder/bin/"

                "$wine_path/wine" "$script_dir/files/srs/Installer.exe"
            zenity --error --title="SRS install" --text="SRS should be installed, just remember. DO NOT UPDATE THIS"
            else
                cd "$script_dir/files"
                wget "$srs_git" -q --show-progress 
                zenity --info --title="SRS install" --text="SRS download completed, please re-run the SRS selection to install it"
        fi

        # echo "SRS downloaded, Installing it now"
        # unzip -d ./srs "$srs_installer"
        # else 


}

#menu for the selection
menu=(
    "Install Directory"
    "Depndicy check"
    "Download files"
    "dcs Install"
    " blackscreen"
    " srs"
    " winetricks"
    " wineCFG"
    " exit"
)

#menu that has FALSE at the start in the selection to allow radiocheck
Menu=( ${menu[@]/#/"FALSE"} )


while true; do
        SELECTION="$(zenity --list --title="DCS Wine helper" --height=475 --text="Choose your selection" --radiolist --column="select" --column="options" "${Menu[@]}")"
        echo "$SELECTION"
            if [ "$SELECTION" = "Directory" ]; then
                directory
            elif [ "$SELECTION" = "check" ]; then
            wineCheck
            wineTricksCheck
                # zenity --info Installed--title="Pre-set check" --text "$wine"
            elif [ "$SELECTION" = "files" ]; then
                fileDownloads
            elif [ "$SELECTION" = "Install" ]; then
                dcsInstall
            elif [ "$SELECTION" = "blackscreen" ]; then
                blackScreenPatch
            elif [ "$SELECTION" = "srs" ]; then
                dcsSRS
            elif [ "$SELECTION" = "wineCFG" ]; then
                wineCFG
            elif [ "$SELECTION" = "winetricks" ]; then
                wineTricksCFG
            elif [ "$SELECTION" = "exit" ]; then
                exit 1
            else
                exit 1
        fi
done


⢀⣤⠴⠖⠋⠉⠓⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣄⠀⠂⠀⢶⣿⣇⡙⠷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠈⢳⡝⠢⡀⠀⠁⠀⠙⠦⣈⢻⡄⠀⠀⠀⠀⣠⢖⣶⡶⠶⠚⠛⠉⣉⠭⠝⠛⠋⠉⠉⠉⠛⠛⠓⠒⠶⠤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠙⣦⠈⠲⠄⣀⠀⢾⡏⠑⠿⡦⣤⣴⠞⠛⢉⣁⣀⠠⠤⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠓⠶⣤⡀⠀⠀⠀⠀
⠀⠀⠀⠈⠳⣄⡀⠀⠙⢓⡆⠠⢲⢾⣖⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠀⢦⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠳⣄⠀⠀
⠀⠀⠀⠀⠀⠀⠉⢳⣦⣿⣷⣾⣿⡿⢏⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⠀⣗⠛⠋⠉⠉⠉⠙⠛⠒⠶⢤⣄⡀⠀⠀⠈⢳⡄
⠀⠀⠀⠀⠀⠀⠀⡾⢅⣻⡟⢛⡏⠁⠃⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⠓⢦⠀⠈⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠳⣄⠀⢸⢻
⠀⠀⠀⠀⠀⠀⡼⠁⠀⡇⠑⠧⣌⡉⠉⠑⣌⡉⠋⠛⠛⠶⠶⠶⠶⠶⢋⡴⠃⠀⠈⣷⣤⠟⣒⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣦⠆⣸
⠀⠀⢀⣀⣀⣸⠁⢀⡞⠁⠀⠀⠀⠉⠳⣄⠀⠙⢶⠶⠤⣤⣀⣠⡴⠞⠋⠀⠀⠀⠀⢇⣷⣄⣾⣝⣧⡀⠀⠀⠀⠀⠀⢀⣀⡴⠟⢁⡴⠃
⠀⢸⢷⠯⡽⡋⠀⡚⡇⠀⠀⠀⠀⠀⠀⠈⠢⣤⠄⢣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⣿⠻⡇⠹⡇⣀⣤⠴⠒⣛⣉⡥⠴⠚⠉⠀⠀
⠀⠸⢹⡿⠤⠲⣾⠗⠃⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⢳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⣴⡿⠿⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠈⠀⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣻⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⣾⡛⣧⡄⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣟⡿⠭⣥⢚⣨⣤⡽⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠀⠸⣞⠉⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀