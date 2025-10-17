#!/usr/bin/env bash
source ./config.cfg

export WINEPREFIX="$GAME_DIR" #sets the game location DO NOT EDIT THIS
# export WINEDLLOVERRIDES="wbemprox=n" # needed for the wbem to work properly (not sure why, just a thing we need)
export WINEDEBUG=-all # Cut down on console debug messages



# Mesa (AMD/Intel) shader cache options
export MESA_SHADER_CACHE_DIR="$WINEPREFIX/cache"
export MESA_SHADER_CACHE_MAX_SIZE="10G"

#DXVK cache for easy clean up
export DXVK_STATE_CACHE_PATH="$WINEPREFIX/cache"

#Custom wine running cause of the Debug issue
# export wine_path="$WINEPREFIX/runner/wine-10.16-x86/bin/"


# Optional HUDs
#export DXVK_HUD=fps,compiler
export MANGOHUD=1


wine "$WINEPREFIX/drive_c/Program Files/Eagle Dynamics/DCS World/bin/DCS_updater.exe"