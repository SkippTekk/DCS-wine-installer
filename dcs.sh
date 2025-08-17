#!/usr/bin/env bash

# Prereqs: Wine, winetricks, zenity


# Script directory
script_dir="$(realpath "$0" | xargs -0 dirname)"
# Wine runner path
wine_location="$install_dir/runner/bin"
#Wine download URL
wine_download="https://github.com/starcitizen-lug/raw-wine/releases/download/10.10/"
wine_file="raw-wine-10.10.tar.gz"
#download path
#download_url="$(curl -s "")"
# DCS Download url
dcs_url="https://www.digitalcombatsimulator.com/en/downloads/world/stable/"
dcs_installer="DCS_World_web.exe"

if zenity --question --no-wrap --text="Welcome to the installer. Other info here! Yay go yay! Ready to install?" --title="DCS Installer"; then
    # Make sure we have the installer
    installer_found="false"
    header_text="The first step is to download the DCS install exe"
    while [ "$installer_found" = "false" ]; do
        zenity --info --no-wrap --text="$header_text\n\nDownload the DCS installer from the website into the following directory:\n$script_dir\n\nWebsite link:\n<a href='$dcs_url'>$dcs_url</a>" --title="DCS Installer"
        if [ -f "$script_dir/$dcs_installer" ]; then
            installer_found="true"
        else
            header_text="The DCS install exe could not be located!"
        fi
    done
    
    zenity --info --no-wrap --text="Next, choose your install location" --title="DCS Installer"

    # Set the install dir
    install_dir="$(zenity --file-selection --directory --title="Choose your DCS install location" --filename="$HOME/" 2>/dev/null)"

    zenity --info --no-wrap --text"Now setting up wine... This may take a bit" --title"DCS wine setup"
    
    echo "DEBUG: Install dir is $install_dir"
    export WINEPREFIX="$install_dir"
    export WINEDLLOVERRIDES="dxwebsetup.exe,dotNetFx45_Full_setup.exe,winemenubuilder.exe=d,wbemprox=n"

    # Install verbs into the prefix with winetricks
    winetricks -q dxvk vcrun2017 d3dcompiler_43 d3dcompiler_47

    # Run the DCS installer
    
    
    download_found="false"
    while [ "$download_found" = "false" ]; do
        zenity --info --no-wrap --text="Awesome, thanks for throwing it into the correct spot. \n Now i'm going to download the pure wine and toss it into the directory $install_dir/runner" --title"Wine runner download"
        if [ -f "$script_dir/$wine_file" ]; then
            download_found="true"
            cp $wine_file "$install_dir/runner"
        else
            header_text="Downloading the Runner file now...."
            zenity --progress --pulsate --no-cancel --auto-close --title"DCS Helper" --text="download and extracting $wine_file"
            cd $script_dir && mkdir -p "$install_dir/runner"
            curl "$wine_download/$wine_file" 
        fi
    done
    $wine_path="$wine_location" "$script_dir/$dcs_installer"
fi