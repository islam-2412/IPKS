#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/popking159/skins/refs/heads/main/Furyatv/installer.sh -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "              You are going to install Fury-FHD                       "
echo "------------------------------------------------------------------------"
echo "removing the previous version of Fury-FHD... "
sleep 2;
if [ -d /usr/share/enigma2/Fury-FHD ] ; then
    opkg remove enigma2-plugin-skins-fury-fhd
    rm -rf /usr/share/enigma2/Fury-FHD > /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Fury-FHD"
fi
echo ""
# Install curl if not already installed
echo "Install curl if not already installed "
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Fury-FHD skin package..."
curl -s -k -L "https://raw.githubusercontent.com/popking159/skins/main/Furyatv/Furyatv.ipk" -o /tmp/Furyatv.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Fury-FHD"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/Furyatv.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Fury-FHD"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/Furyatv.ipk ]; then
    rm -f /tmp/Furyatv.ipk
fi

echo "Done"
#
echo "------------------------------------------------------------------------"
echo "                            CONGRATULATIONS                             "
echo "                   Fury-FHD Installed Successfully                    "
echo "------------------------------------------------------------------------"
echo "   "
exit 0
