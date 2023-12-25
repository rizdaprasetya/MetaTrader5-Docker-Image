#!/bin/bash

# Determine the current user
current_user=$(whoami)
# Change ownership of the Wine folder to the current user
sudo chown -R $current_user:$current_user /config/.wine

mt5exe='/config/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe'
WINEPREFIX=/config/.wine

# Test if Wine Mono installed, then skip, else install it
if [ -e "/config/.wine/drive_c/windows/mono" ]; then
    echo "MONO is already installed"
else
    curl -o ~/.wine/drive_c/mono-8.0.0.msi https://dl.winehq.org/wine/wine-mono/8.0.0/wine-mono-8.0.0-x86.msi
    WINEDLLOVERRIDES=mscoree=d wine msiexec /i ~/.wine/drive_c/mono-8.0.0.msi /qn
    rm ~/.wine/drive_c/mono-8.0.0.msi
    echo "Installed MONO"
fi

# Test if MT5 executable file already exists
if [ -e "$mt5exe" ]; then
    echo "File $mt5exe already exists"
else
    echo "File $mt5exe does not exist"
    # Run "wine install.exe" if mt5 does not exists
    mkdir -p /config/.wine/drive_c
    curl -o /config/.wine/drive_c/mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe
    # todo move mono install outside this parent if
    exec wine "/config/.wine/drive_c/mt5setup.exe" "/auto" &
    wait
fi

# Check that file exists now
if [ -e "$mt5exe" ]; then
    echo "MT5 is installed"
    # Delete MT5 setup file
    rm -f /config/.wine/drive_c/mt5setup.exe
    # run mt5 with portable mode, to centralize app data inside mt5 install folder too
    # run `wine "terminal64.exe" "/portable"`
    wine "$mt5exe" "/portable"
else
    echo "File {$mt5exe} does not exist yet. This is probably caused by an installation error. MT5 cannot run"
fi
