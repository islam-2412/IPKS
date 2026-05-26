#!/bin/sh

# ==============================================================================
NEW_VER=$(wget -qO- "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/furyversion.txt" | tr -d '\0\r\n' | awk '{$1=$1};1')

if [ -z "$NEW_VER" ]; then
    NEW_VER="Latest"
fi
# ==============================================================================

echo "==================================="
echo "   Installing Fury-FHD (v$NEW_VER) "
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
echo "==================================="

SKINDIR='/usr/share/enigma2/Fury-FHD'
MAINDIR="$SKINDIR/main"
LOGODIR="$SKINDIR/image_logo"
set +e

echo "Detecting System Image & Adjusting Logos..."

# 1. تحديد فولدر اللوجو المناسب بناءً على الصورة
IMG_FOLDER="main" # القيمة الافتراضية لو الصورة مش مدعومة

if grep -qs -i "openATV" /etc/image-version; then IMG_FOLDER="openatv"
elif grep -qs -i "egami" /etc/image-version; then IMG_FOLDER="egami"
elif grep -qs -i "PURE2" /etc/image-version; then IMG_FOLDER="pure2"
elif grep -qs -i "OpenSPA" /etc/image-version; then IMG_FOLDER="openspa"
elif grep -qs -i "openBH" /etc/image-version; then IMG_FOLDER="openbh"
elif grep -qs -i "openViX" /etc/image-version; then IMG_FOLDER="openvix"
elif grep -qs -i "openDroid" /etc/image-version; then IMG_FOLDER="opendroid"
elif grep -qs -i "openpli" /etc/issue; then
    if grep -qs -i "GCC-15.1" /etc/issue; then IMG_FOLDER="foxbob"
    else IMG_FOLDER="openpli"
    fi
elif grep -qs -i "Corvoboys" /etc/issue; then IMG_FOLDER="corvoboys"
elif grep -qs -i "TNAP" /etc/issue; then IMG_FOLDER="tnap"
elif grep -qs -i "teamblue" /etc/issue; then IMG_FOLDER="teamblue"
elif grep -qs -i "foxbob" /etc/issue; then IMG_FOLDER="openplifoxbob"
fi

echo ">> Applied Image Profile: $IMG_FOLDER"

# 2. تطبيق لوجو الصورة (أمر واحد فقط بيشتغل بذكاء)
if [ "$IMG_FOLDER" != "main" ] && [ -d "$LOGODIR/$IMG_FOLDER" ]; then
    mv -f "$LOGODIR/$IMG_FOLDER/imagelogo.png" "$SKINDIR/" > /dev/null 2>&1
    mv -f "$LOGODIR/$IMG_FOLDER/top_logo.png" "$SKINDIR/" > /dev/null 2>&1
else
    cp -f "$MAINDIR/top_logo.png" "$SKINDIR/top_logo.png" > /dev/null 2>&1
fi

# 3. تطبيق صورة الجهاز (Box Image)
if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ]; then
    cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
else
    cp -f "$MAINDIR/boximage.png" "$SKINDIR/boximage.png" > /dev/null 2>&1
fi

# ==============================================================================
# Clean Up & Finish
# ==============================================================================
sleep 1
echo "removing some temporary files.... " 
rm -rf "$LOGODIR" > /dev/null 2>&1
rm -rf /control /CONTROL > /dev/null 2>&1

echo "enigma2-plugin-skins-Fury-fhd (v$NEW_VER) was installed successfully"
sleep 1
echo ">>>>>>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<<<<<<<<"
echo ">>>>>>>>>>Fury-FHD Skin by Islam Salama (( 2026 ))<<<<<<<<<<"
exit 0
