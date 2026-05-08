#!/bin/sh
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh -O - | /bin/sh

# ==============================================================================
# Define Colors
# ==============================================================================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# ==============================================================================
# Formatting Functions
# ==============================================================================
print_info() { echo -e "${BLUE}[ INFO ]${NC} $1"; }
print_success() { echo -e "${GREEN}[ SUCCESS ]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[ WARNING ]${NC} $1"; }
print_error() { echo -e "${RED}[ ERROR ]${NC} $1"; }
print_divider() { echo -e "${CYAN}========================================================================${NC}"; }

# Function to install extensions
install_extension() {
    local ext_name=$1
    local ext_url=$2
    local ext_file="/tmp/${ext_name}.ipk"

    print_info "Downloading ${ext_name} for Python ${PYTHON_VERSION}..."
    curl -s -k -L "${ext_url}" -o "${ext_file}"
    
    if grep -q "Not Found" "${ext_file}" || [ ! -s "${ext_file}" ]; then
        print_warning "${ext_name} IPK not found for Python ${PYTHON_VERSION} on GitHub. Skipping..."
        rm -f "${ext_file}"
    else
        print_info "Installing ${ext_name}..."
        opkg install --force-reinstall --force-overwrite "${ext_file}" > /dev/null 2>&1
        rm -f "${ext_file}"
        print_success "${ext_name} Installed Successfully."
    fi
    echo ""
}

# ==============================================================================
# Start Installation
# ==============================================================================
clear
print_divider
echo -e "${GREEN}          ✨ Installing Fury-FHD Skin & Extensions (Smart Install) ✨    ${NC}"
echo -e "${MAGENTA}                 Maintainer: Islam Salama (Abou Yassin)               ${NC}"
print_divider
echo ""

# 1. Remove old versions of the skin
print_info "Removing the previous version of Fury-FHD..."
sleep 1
if [ -d /usr/share/enigma2/Fury-FHD ] ; then
    opkg remove enigma2-plugin-skins-fury-fhd > /dev/null 2>&1
    rm -rf /usr/share/enigma2/Fury-FHD > /dev/null 2>&1
    print_success "Skin package removed."
else
    print_info "There are no previous versions of Fury-FHD."
fi
echo ""

# 2. Check for curl dependency
print_info "Checking and installing curl if not already installed..."
opkg install curl > /dev/null 2>&1
print_success "Dependencies ready."
echo ""

# 3. Detect System Information (Device, Image, Python version)
print_info "Detecting System Information..."

# Extract the real device name (Cleaned from hidden characters)
if [ -f /proc/stb/info/hwmodel ]; then
    DEVICE_NAME=$(cat /proc/stb/info/hwmodel | tr -d '\r\n')
elif [ -f /proc/stb/info/vumodel ]; then
    DEVICE_NAME=$(cat /proc/stb/info/vumodel | tr -d '\r\n')
elif [ -f /proc/stb/info/boxtype ]; then
    DEVICE_NAME=$(cat /proc/stb/info/boxtype | tr -d '\r\n')
elif [ -f /proc/stb/info/model ]; then
    DEVICE_NAME=$(cat /proc/stb/info/model | tr -d '\r\n')
else
    DEVICE_NAME="Unknown"
fi

# Final fallback: If it still returns dm8000, extract the name from the hostname
if [ "$DEVICE_NAME" = "dm8000" ] && [ -f /etc/hostname ]; then
    DEVICE_NAME=$(cat /etc/hostname | tr -d '\r\n')
fi

# Print Device Name in Yellow
echo -e "${GREEN}[ SUCCESS ]${NC} Detected Device: ${YELLOW}${DEVICE_NAME}${NC}"

# Extract the actual image name (Cleaned from hidden characters)
if [ -f /etc/issue ]; then
    IMAGE_NAME=$(sed -n '1p' /etc/issue | sed -e 's/[Ww]elcome to //g' -e 's/\\n//g' -e 's/\\l//g' | tr -d '\r\n' | awk '{print $1}')
else
    IMAGE_NAME="Unknown"
fi

# Print Image Name in Green
echo -e "${GREEN}[ SUCCESS ]${NC} Detected Image: ${GREEN}${IMAGE_NAME}${NC}"

# Detect Python version (Cleaned from hidden characters)
PYTHON_VERSION=$(python3 -c 'import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))' 2>/dev/null | tr -d '\r\n')

if [ -z "$PYTHON_VERSION" ]; then
    PYTHON_VERSION=$(python -c 'import sys; print(str(sys.version_info[0]) + "." + str(sys.version_info[1]))' 2>/dev/null | tr -d '\r\n')
fi

if [ -z "$PYTHON_VERSION" ]; then
    print_warning "Python version could not be detected. Plugins might not install correctly."
else
    # Print Python Version in Yellow
    echo -e "${GREEN}[ SUCCESS ]${NC} Detected Python Version: ${YELLOW}${PYTHON_VERSION}${NC}"
fi
echo ""

cd /tmp || exit

# 4. Download and install the main skin
print_info "Downloading Fury-FHD skin package..."
curl -s -k -L "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/fury.ipk" -o /tmp/fury.ipk

if [ -f /tmp/fury.ipk ]; then
    print_info "Installing Fury-FHD Skin..."
    opkg install --force-reinstall --force-overwrite /tmp/fury.ipk > /dev/null 2>&1
    rm -f /tmp/fury.ipk
    print_success "Fury-FHD Skin Installed Successfully."
else
    print_error "Error downloading Fury-FHD"
fi
echo ""

# 5. Download and install extensions
if [ -n "$PYTHON_VERSION" ]; then
    install_extension "DataMonitor" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/DataMonitor/datamonitor_py${PYTHON_VERSION}.ipk"
    install_extension "FuryDisk" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/FuryDisk/furydisk_py${PYTHON_VERSION}.ipk"
    install_extension "AIFury" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/AIFury/aifury_py${PYTHON_VERSION}.ipk"
fi

# ==============================================================================
# End Installation
# ==============================================================================
print_divider
echo -e "${GREEN}             🎉 Fury-FHD & Extensions Installed/Updated Successfully! 🎉 ${NC}"
echo -e "${CYAN}             Please restart your Enigma2 GUI to apply changes.          ${NC}"
print_divider
exit 0
