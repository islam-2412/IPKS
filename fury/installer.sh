#!/bin/sh
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh -O - | /bin/sh

# ==============================================================================
# تعريف الألوان وتنسيقات النصوص
# ==============================================================================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m' # بدون لون

# ==============================================================================
# دوال الطباعة الجمالية (Functions)
# ==============================================================================
print_info() { echo -e "${BLUE}[ INFO ]${NC} $1"; }
print_success() { echo -e "${GREEN}[ SUCCESS ]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[ WARNING ]${NC} $1"; }
print_error() { echo -e "${RED}[ ERROR ]${NC} $1"; }
print_divider() { echo -e "${CYAN}========================================================================${NC}"; }

# دالة لتثبيت الإضافات اختصاراً لتكرار الكود
install_extension() {
    local ext_name=$1
    local ext_url=$2
    local ext_file="/tmp/${ext_name}.ipk"

    print_info "Downloading ${ext_name} for Python ${PYTHON_VERSION}..."
    curl -s -k -L "${ext_url}" -o "${ext_file}"
    
    if grep -q "Not Found" "${ext_file}" || [ ! -s "${ext_file}" ]; then
        print_warning "${ext_name} IPK not found for Python ${PYTHON_VERSION}. Skipping..."
        rm -f "${ext_file}"
    else
        print_info "Installing ${ext_name}..."
        opkg install --force-overwrite "${ext_file}" > /dev/null 2>&1
        rm -f "${ext_file}"
        print_success "${ext_name} Installed Successfully."
    fi
    echo ""
}

# ==============================================================================
# بداية التثبيت
# ==============================================================================
clear
print_divider
echo -e "${GREEN}              ✨ Installing Fury-FHD Skin & Extensions ✨              ${NC}"
echo -e "${MAGENTA}                 Maintainer: Islam Salama (Abou Yassin)               ${NC}"
print_divider
echo ""

# 1. تنظيف الإصدارات القديمة من الإسكين
print_info "Checking for previous versions of Fury-FHD..."
sleep 1
if [ -d /usr/share/enigma2/Fury-FHD ] ; then
    opkg remove enigma2-plugin-skins-fury-fhd > /dev/null 2>&1
    rm -rf /usr/share/enigma2/Fury-FHD > /dev/null 2>&1
    print_success "Old Skin package removed."
else
    print_info "No previous versions found. Clean start!"
fi
echo ""

# 2. التأكد من وجود curl
print_info "Checking system dependencies (curl)..."
opkg install curl > /dev/null 2>&1
print_success "Dependencies ready."
echo ""

# 3. التعرف على إصدار البايثون في الصورة
print_info "Detecting System Architecture & Python Version..."
PYTHON_VERSION=$(python3 -c 'import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))' 2>/dev/null)

if [ -z "$PYTHON_VERSION" ]; then
    PYTHON_VERSION=$(python -c 'import sys; print(str(sys.version_info[0]) + "." + str(sys.version_info[1]))' 2>/dev/null)
fi

if [ -z "$PYTHON_VERSION" ]; then
    print_warning "Python version could not be detected. Plugins might not install correctly."
else
    print_success "Detected Python Version: ${YELLOW}${PYTHON_VERSION}${NC}"
fi
echo ""

cd /tmp || exit

# 4. تحميل وتثبيت الإسكين الأساسي
print_info "Downloading Main Skin: Fury-FHD..."
curl -s -k -L "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/fury.ipk" -o /tmp/fury.ipk

if [ -f /tmp/fury.ipk ]; then
    print_info "Installing Fury-FHD Skin..."
    opkg install --force-overwrite /tmp/fury.ipk > /dev/null 2>&1
    rm -f /tmp/fury.ipk
    print_success "Fury-FHD Skin Installed Successfully."
else
    print_error "Failed to download Fury-FHD"
fi
echo ""

# 5. تحميل وتثبيت الإضافات بناءً على إصدار البايثون باستخدام الدالة المخصصة
if [ -n "$PYTHON_VERSION" ]; then
    install_extension "DataMonitor" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/DataMonitor/datamonitor_py${PYTHON_VERSION}.ipk"
    install_extension "FuryDisk" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/FuryDisk/furydisk_py${PYTHON_VERSION}.ipk"
    install_extension "AIFury" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/AlFury/alfury_py${PYTHON_VERSION}.ipk"
fi

# ==============================================================================
# نهاية التثبيت
# ==============================================================================
print_divider
echo -e "${GREEN}             🎉 Installation Completed Successfully! 🎉                 ${NC}"
echo -e "${CYAN}             Please restart your Enigma2 GUI to apply changes.          ${NC}"
print_divider
exit 0
