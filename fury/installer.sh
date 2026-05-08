#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh -O - | /bin/sh #

echo "------------------------------------------------------------------------"
echo "           Installing Fury-FHD Skin & Extensions (Smart Install)        "
echo "------------------------------------------------------------------------"

# 1. تنظيف الإصدارات القديمة من الإسكين
echo "Removing the previous version of Fury-FHD... "
sleep 2;
if [ -d /usr/share/enigma2/Fury-FHD ] ; then
    opkg remove enigma2-plugin-skins-fury-fhd > /dev/null 2>&1
    rm -rf /usr/share/enigma2/Fury-FHD > /dev/null 2>&1
    echo 'Skin package removed.'
else
    echo "There are no previous versions of Fury-FHD."
fi
echo ""

# 2. التأكد من وجود curl
echo "Checking and installing curl if not already installed..."
opkg install curl > /dev/null 2>&1
sleep 2

# 3. التعرف على إصدار البايثون في الصورة
echo "Detecting Python version..."
PYTHON_VERSION=$(python3 -c 'import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))' 2>/dev/null)

if [ -z "$PYTHON_VERSION" ]; then
    PYTHON_VERSION=$(python -c 'import sys; print(str(sys.version_info[0]) + "." + str(sys.version_info[1]))' 2>/dev/null)
fi

if [ -z "$PYTHON_VERSION" ]; then
    echo "⚠️ Warning: Python version could not be detected. Plugins might not install correctly."
else
    echo "✅ Detected Python Version: $PYTHON_VERSION"
fi
echo ""

cd /tmp

# 4. تحميل وتثبيت الإسكين الأساسي
echo "Downloading Fury-FHD skin package..."
curl -s -k -L "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/fury.ipk" -o /tmp/fury.ipk

if [ -f /tmp/fury.ipk ]; then
    echo "Installing Fury-FHD Skin..."
    opkg install --force-reinstall --force-overwrite /tmp/fury.ipk
    rm -f /tmp/fury.ipk
else
    echo "❌ Error downloading Fury-FHD"
fi
sleep 1
echo ""

# 5. تحميل وتثبيت DataMonitor
if [ -n "$PYTHON_VERSION" ]; then
    echo "Downloading DataMonitor for Python ${PYTHON_VERSION}..."
    curl -s -k -L "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/DataMonitor/datamonitor_py${PYTHON_VERSION}.ipk" -o /tmp/datamonitor.ipk
    
    if grep -q "Not Found" /tmp/datamonitor.ipk || [ ! -s /tmp/datamonitor.ipk ]; then
        echo "⚠️ DataMonitor IPK not found for Python ${PYTHON_VERSION} on GitHub. Skipping..."
        rm -f /tmp/datamonitor.ipk
    else
        echo "Installing DataMonitor..."
        opkg install --force-reinstall --force-overwrite /tmp/datamonitor.ipk
        rm -f /tmp/datamonitor.ipk
    fi
fi
sleep 1
echo ""

# 6. تحميل وتثبيت FuryDisk
if [ -n "$PYTHON_VERSION" ]; then
    echo "Downloading FuryDisk for Python ${PYTHON_VERSION}..."
    curl -s -k -L "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/FuryDisk/furydisk_py${PYTHON_VERSION}.ipk" -o /tmp/furydisk.ipk
    
    if grep -q "Not Found" /tmp/furydisk.ipk || [ ! -s /tmp/furydisk.ipk ]; then
        echo "⚠️ FuryDisk IPK not found for Python ${PYTHON_VERSION} on GitHub. Skipping..."
        rm -f /tmp/furydisk.ipk
    else
        echo "Installing FuryDisk..."
        opkg install --force-reinstall --force-overwrite /tmp/furydisk.ipk
        rm -f /tmp/furydisk.ipk
    fi
fi
sleep 1
echo ""

# 7. تحميل وتثبيت AlFury
if [ -n "$PYTHON_VERSION" ]; then
    echo "Downloading AlFury for Python ${PYTHON_VERSION}..."
    curl -s -k -L "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/AlFury/alfury_py${PYTHON_VERSION}.ipk" -o /tmp/alfury.ipk
    
    if grep -q "Not Found" /tmp/alfury.ipk || [ ! -s /tmp/alfury.ipk ]; then
        echo "⚠️ AlFury IPK not found for Python ${PYTHON_VERSION} on GitHub. Skipping..."
        rm -f /tmp/alfury.ipk
    else
        echo "Installing AlFury..."
        opkg install --force-reinstall --force-overwrite /tmp/alfury.ipk
        rm -f /tmp/alfury.ipk
    fi
fi
sleep 1
echo ""

echo "------------------------------------------------------------------------"
echo "                              Abou Yassin                               "
echo "         Fury-FHD & Extensions Installed/Updated Successfully           "
echo "------------------------------------------------------------------------"
echo "   "
exit 0
