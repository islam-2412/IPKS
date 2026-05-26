#!/bin/sh
echo "==================================="

# ---- Device Model ----
BOXMODEL=$(cat /etc/hostname 2>/dev/null || echo "unknown")
printf "Device Model : %s\033\n" "$BOXMODEL"

# ---- Python Version Check ----
if command -v python3 >/dev/null 2>&1; then
    PYVER=$(python3 --version 2>&1)
elif command -v python >/dev/null 2>&1; then
    PYVER=$(python --version 2>&1)
else
    PYVER="Python: Not installed"
fi
echo "Version: $PYVER"

sleep 1
echo "==================================="

SKINDIR='/usr/share/enigma2/Fury-FHD'
TMPDIR='/tmp'
BOXMODEL=$(cat /etc/hostname)
set +e

echo " Images Support"
echo "1 OpenATV All Version"
echo "2 Egami All Version"
echo "3 PurE2 Version"
echo "4 OpenSPA Version"
echo "5 OpenBH 5.4 & 5.5.1"
echo "6 OpenViX 6.7"
echo "7 OpenDroid 7.5 & 8.0"
echo "8 OpenPli Foxbob"
echo "9 OpenPLi 9.0 & OpenPLi 9.1"
echo "10 OpenPLi Develop builds & OpenPLi Scarthgap builds"
echo "11 Corvoboys"
echo "12 TNAP"
echo "13 TeamBlue"
sleep 2
echo "Identify your image ...."
sleep 2

if grep -qs -i "openATV" /etc/image-version; then
    echo "You have OpenAtv image"
    mv -f "$SKINDIR/image_logo/openatv/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openatv/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "egami" /etc/image-version; then
    echo "You have Egami image"
    mv -f "$SKINDIR/image_logo/egami/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/egami/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi
	
elif grep -qs -i "PURE2" /etc/image-version; then
    echo "You have PURE2 image"
    mv -f "$SKINDIR/image_logo/pure2/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/pure2/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "OpenSPA" /etc/image-version; then
    echo "You have OpenSPA image"
    mv -f "$SKINDIR/image_logo/openspa/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openspa/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "openBH" /etc/image-version; then
    echo "You have OpenBH image"
    mv -f "$SKINDIR/image_logo/openbh/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openbh/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "openViX" /etc/image-version; then
    echo "You have OpenViX image"
    mv -f "$SKINDIR/image_logo/openvix/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openvix/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi
	
elif grep -qs -i "openDroid" /etc/image-version; then
    echo "You have OpenDroid image"
    mv -f "$SKINDIR/image_logo/opendroid/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/opendroid/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "openpli" /etc/issue; then
    if grep -qs -i "GCC-15.1" /etc/issue; then
        echo "You have Foxbob GCC-15.1 image"
        mv -f "$SKINDIR/image_logo/foxbob/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
        mv -f "$SKINDIR/image_logo/foxbob/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    else
        echo "You have OpenPli image"
        mv -f "$SKINDIR/image_logo/openpli/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
        mv -f "$SKINDIR/image_logo/openpli/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    fi
	
elif grep -qs -i "Corvoboys" /etc/issue; then
    echo "You have Corvoboys image"
    mv -f "$SKINDIR/image_logo/corvoboys/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/corvoboys/top_logo.png" "$SKINDIR" > /dev/null 2>&1
	
elif grep -qs -i "TNAP" /etc/issue; then
    echo "You have TNAP image"
    mv -f "$SKINDIR/image_logo/tnap/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/tnap/top_logo.png" "$SKINDIR" > /dev/null 2>&1
	
elif grep -qs -i "teamblue" /etc/issue; then
    echo "You have teamblue image"
    mv -f "$SKINDIR/image_logo/teamblue/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/teamblue/top_logo.png" "$SKINDIR" > /dev/null 2>&1

elif grep -qs -i "foxbob" /etc/issue; then
    echo "You have OpenPli foxbob image"
	mv $SKINDIR/image_logo/openplifoxbob/imagelogo.png $SKINDIR > /dev/null 2>&1
	mv $SKINDIR/image_logo/openplifoxbob/top_logo.png $SKINDIR > /dev/null 2>&1
	
else
    echo "Even you do not have a supported image, you can try Fury-FHD"
	cp /usr/share/enigma2/Fury-FHD/main/boximage.png $SKINDIR/boximage.png > /dev/null 2>&1
	cp /usr/share/enigma2/Fury-FHD/main/top_logo.png $SKINDIR/top_logo.png > /dev/null 2>&1
fi

# ==============================================================================
# Clean Up & Finish
# ==============================================================================
sleep 2
echo "removing some temporary files.... " 
rm -rf $SKINDIR/image_logo  > /dev/null 2>&1
rm -rf /control  > /dev/null 2>&1
echo "enigma2-plugin-skins-Fury-fhd was installed successfully "
sleep 2
echo ">>>>>>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<<<<<<<<"
echo ">>>>>>>>>>Fury-FHD Skin by Islam Salama (( 2025 ))<<<<<<<<<<"
exit 0
