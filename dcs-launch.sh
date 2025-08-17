#!/usr/bin/env bash

export WINEPREFIX="/mnt/2tbgaming/dcs"
launch_log=""$WINEPREFIX"dcs-launch.log"

export WINEDLLOVERRIDES="wbemprox=n" # needed for the wbem to work properly (not sure why, just a thing we need)
export WINEDEBUG=-all # Cut down on console debug messages

# Mesa (AMD/Intel) shader cache options
export MESA_SHADER_CACHE_DIR="$WINEPREFIX"
export MESA_SHADER_CACHE_MAX_SIZE="10G"

#DXVK cache for easy clean up
export DXVK_STATE_CACHE_PATH="$WINEPREFIX"
# Optional HUDs
#export DXVK_HUD=fps,compiler
#export MANGOHUD=1

case "$1" in
    "shell")
        echo "Entering Wine prefix maintenance shell. Type 'exit' when done."
        export PATH="$wine_path:$PATH"; export PS1="Wine: "
        cd "$WINEPREFIX"; pwd; /usr/bin/env bash --norc; exit 0
        ;;
    "config")
        /usr/bin/env bash --norc -c "${wine_path}/winecfg"; exit 0
        ;;
    "controllers")
        /usr/bin/env bash --norc -c "${wine_path}/wine control joy.cpl"; exit 0
        ;;
esac


# update_check() {
#     while "$wine_path"/winedbg --command "info proc" | grep -qi "rsi.*setup"; do
#         sleep 2
#     done
# }
#trap "update_check; \"$wine_path\"/wineserver -k" EXIT

umu-run "$WINEPREFIX/drive_c/Program Files/Eagle Dynamics/DCS World/bin/DCS_updater.exe"
