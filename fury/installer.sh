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

# ==============================================================================
# Auto Detect Image
# ==============================================================================
echo "Detecting System Image..."

if [ -f /etc/issue ]; then
    IMAGE_NAME=$(sed -n '1p' /etc/issue | sed -e 's/[Ww]elcome to //g' -e 's/\\n//g' -e 's/\\l//g' | tr -d '\0\r\n' | awk '{print $1}')
else
    IMAGE_NAME="Unknown"
fi

echo ">> Detected Image: $IMAGE_NAME"
echo ">> Adjusting files for your image..."
sleep 2

# ==============================================================================
# Apply Image Logos
# ==============================================================================
if grep -qs -i "openATV" /etc/image-version; then
    mv -f "$SKINDIR/image_logo/openatv/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openatv/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "egami" /etc/image-version; then
    mv -f "$SKINDIR/image_logo/egami/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/egami/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi
	
elif grep -qs -i "PURE2" /etc/image-version; then
    mv -f "$SKINDIR/image_logo/pure2/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/pure2/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "OpenSPA" /etc/image-version; then
    mv -f "$SKINDIR/image_logo/openspa/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openspa/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "openBH" /etc/image-version; then
    mv -f "$SKINDIR/image_logo/openbh/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openbh/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi

elif grep -qs -i "openViX" /etc/image-version; then
    mv -f "$SKINDIR/image_logo/openvix/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/openvix/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ] ; then
        cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
    else
        cp -f "/usr/share/enigma2/Fury-FHD/main/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
        cp -f "/usr/share/enigma2/Fury-FHD/main/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
    fi
	
elif grep -qs -i "openDroid" /etc/image-version; then
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
        mv -f "$SKINDIR/image_logo/foxbob/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
        mv -f "$SKINDIR/image_logo/foxbob/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    else
        mv -f "$SKINDIR/image_logo/openpli/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
        mv -f "$SKINDIR/image_logo/openpli/top_logo.png" "$SKINDIR" > /dev/null 2>&1
    fi
	
elif grep -qs -i "Corvoboys" /etc/issue; then
    mv -f "$SKINDIR/image_logo/corvoboys/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/corvoboys/top_logo.png" "$SKINDIR" > /dev/null 2>&1
	
elif grep -qs -i "TNAP" /etc/issue; then
    mv -f "$SKINDIR/image_logo/tnap/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/tnap/top_logo.png" "$SKINDIR" > /dev/null 2>&1
	
elif grep -qs -i "teamblue" /etc/issue; then
    mv -f "$SKINDIR/image_logo/teamblue/imagelogo.png" "$SKINDIR" > /dev/null 2>&1
    mv -f "$SKINDIR/image_logo/teamblue/top_logo.png" "$SKINDIR" > /dev/null 2>&1

elif grep -qs -i "foxbob" /etc/issue; then
	mv $SKINDIR/image_logo/openplifoxbob/imagelogo.png $SKINDIR > /dev/null 2>&1
	mv $SKINDIR/image_logo/openplifoxbob/top_logo.png $SKINDIR > /dev/null 2>&1
	
else
	cp /usr/share/enigma2/Fury-FHD/main/boximage.png $SKINDIR/boximage.png > /dev/null 2>&1
	cp /usr/share/enigma2/Fury-FHD/main/top_logo.png $SKINDIR/top_logo.png > /dev/null 2>&1
fi

# ==============================================================================
# Clean Up & Finish
# ==============================================================================
sleep 1
echo "removing some temporary files.... " 
rm -rf $SKINDIR/image_logo  > /dev/null 2>&1
rm -rf /control  > /dev/null 2>&1
echo "enigma2-plugin-skins-Fury-fhd was installed successfully "
sleep 1
echo ">>>>>>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<<<<<<<<"
echo ">>>>>>>>>>Fury-FHD Skin by Islam Salama (( 2025 ))<<<<<<<<<<"
exit 0
