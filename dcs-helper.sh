#!/bin/bash




#Just check if user ran it as root aka sudo. WHICH IS A NO NO

if [ "$(id -u)" -eq 0 ]; then
    echo "This script is not supposed to be run as root!"
    exit 1
fi



# Script directory
script_dir="$(realpath "$0" | xargs -0 dirname)"

# Creates the config file. DO NOT EDIT THE SCRIPT FILE IT WILL BREAK IF YOU DO
if [ -f ""$script_dir"/config.cfg" ]; then
        echo "Config file found... using it"
    else
        touch "$script_dir"/config.cfg
fi

#shell config file... hopefully this works cause i need it now.... crap
source $script_dir/config.cfg


#DCS official URL
dcs_url="https://www.digitalcombatsimulator.com/en/downloads/world/stable/"
dcs_installer="DCS_World_web.exe"

#SRS Github URL
srs_git="https://github.com/ciribob/DCS-SimpleRadioStandalone/releases"
srs_installer="SRS-AutoUpdater.exe"
#Wine download URL
wine_download="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-12/GE-Proton10-12.tar.gz"
wine_file="GE-Proton10-12.tar.gz"

# Options lua config file download and file name
options_download="https://raw.githubusercontent.com/deleterium/dcs_on_linux/refs/heads/master/options.lua"
options_file="options.lua"

# My github location.
github="https://github.com/SkippTekk/DCS-wine-installer"

function dcsInstall {
    echo "Alright, so you wanted to install DCS on Wine... Let's get to it!"
    echo "Where do you want to install it?"

    # Prompt user for installation directory
    install_dir="$(zenity --file-selection --directory --title="Choose your DCS install location" --filename="$HOME/" 2>/dev/null)"

    # Check if the user selected a directory
    if [ -z "$install_dir" ]; then
        echo "No installation directory selected. Exiting."
        return
    fi

    # Create the runner directory
    echo GAME_DIR="$install_dir" > "$script_dir"/config.cfg
    # mkdir -p "$install_dir/runner"
    # echo "Unzipping $wine_file..."
    # tar -xf "$script_dir/tmp/$wine_file" -C "$install_dir/runner/"

    # Set up Wine environment variables
    #export wine_path="$install_dir/runner/GE-Proton10-11/files/bin"
    export WINEPREFIX="$install_dir"
    export WINEDLLOVERRIDES="wbemprox=n"

    echo "Awesome, your game SHOULD be installing into $install_dir now..."
    echo "DEBUG: Install dir is $install_dir and is running its task."

    # Install necessary components with winetricks
    winetricks -q dxvk vcrun2017 d3dcompiler_43 d3dcompiler_47 d3dx9 win10

    # Restart the Wine server and run the DCS installer
    
    umu-run "$script_dir/tmp/$dcs_installer"
    
    # "$wine_path/wineserver" -k
    # "$wine_path/wine" "$script_dir/tmp/$dcs_installer"
    # "$wine_path/wineserver" -k
}


function fileDownloads {

    #Checks if user has installed Wine runner.
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
    # checks if the user has downloaded DCS official download
    if [ -f ""$script_dir"/tmp/"$dcs_installer"" ]; then
        installer_found="true"
            echo "just to make sure, that "$dcs_installer" existed, and it does!" && echo "\o/ woot. \o/" && echo "Now for the next steps"
        else
            echo ""$dcs_installer" not found... Please download it manually from "$dcs_url". And place into "$script_dir"/tmp folder"
    fi
    # Checks if user has downloaded SRS
    if [ -f "$script_dir/tmp/$srs_installer" ]; then
        installer_found="true"
            echo "just to make sure, that "$srs_installer" existed, and it does!"
    else
        echo ""$srs_installer" not found... Please download it manually from "$srs_git" and place into "$script_dir"/tmp folder"
    fi
    done


}
# currently a HUGE bug in this one... DO NOT RUN UNTIL YOU HAVE FULLY INSTALLED THE GAME. Basically have the base game files and at the launch script stage. Otherwise it WILL spam your console with errors.
function blackScreenPatch {

    patch_found="false"

    while [ "$patch_found" = "false" ]; do
        if [ -f "$GAME_DIR/drive_c/users/steamuser/Saved Games/DCS/Config/$options_file" ]; then
            patch_found="true"
                echo "Awesome, patch file found. You can now sign in and play!"
                exit
            else
                echo ""$options_file" not found...Moving it over for you."
                    file_found="false"
                    while [ "$file_found" = "false" ]; do
                    if [ -f ""$script_dir"/"$options_file"" ]; then
                        file_found="true"
                        echo "File found... Moving for you"
                            cp "$script_dir"/"$options_file" ""$GAME_DIR"/drive_c/users/steamuser/Saved Games/DCS/Config/"
                        echo ""$options_file" has been moved too "$GAME_DIR"/drive_c/users/steamuser/Saved Games/DCS/Config/"
                            else
                                echo ""$options_file" not found, Please download it from the github. "$github" and place it into "$script_dir""
                                
                    fi
                    done
        fi
        done


}

function dependencies {
    if [ ! -x "winetricks --version" ]; then
        winetricks --version
        echo "winetricks is installed. Woot" 
    else
        echo "winetricks not installed, Please install it"
    fi
}

options=("Install DCS on pure wine" "Download DCS and SRS into tmp folder." "Black screen patch (after full install)" "Get help (discord)" "Exit")

PS3="Please select on what you need: "

select opt in "${options[@]}"; do

    case $REPLY in
    1) dcsInstall ;;
    2) fileDownloads ;;
    3) blackScreenPatch && exit;;
    4) echo "Join the Community Discord and ask for the Linux channel! https://discord.gg/7NFYC73med " ;;
    5) echo "good bye, thanks for using this! " && exit ;;
    6) dependencies ;;
    *) echo "Invalid option, please use a number that is listed"
        
    esac
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