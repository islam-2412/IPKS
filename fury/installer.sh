#!/bin/sh
#
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/islam-2412/IPKS/refs/heads/main/fury/installer.sh -O - | /bin/sh

# ==============================================================================
# تعريف الألوان
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

# دالة لتثبيت الإضافات
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
# بداية التثبيت
# ==============================================================================
clear
print_divider
echo -e "${GREEN}          ✨ Installing Fury-FHD Skin & Extensions (Smart Install) ✨    ${NC}"
echo -e "${MAGENTA}                 Maintainer: Islam Salama (Abou Yassin)               ${NC}"
print_divider
echo ""

# 1. تنظيف الإصدارات القديمة من الإسكين
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

# 2. التأكد من وجود curl
print_info "Checking and installing curl if not already installed..."
opkg install curl > /dev/null 2>&1
print_success "Dependencies ready."
echo ""

# 3. التعرف على بيانات النظام (الجهاز، الصورة، إصدار البايثون)
print_info "Detecting System Information..."

# استخراج اسم الجهاز الحقيقي (الأولوية لـ hwmodel لتخطي وهم dm8000)
if [ -f /proc/stb/info/hwmodel ]; then
    DEVICE_NAME=$(cat /proc/stb/info/hwmodel)
elif [ -f /proc/stb/info/vumodel ]; then
    DEVICE_NAME=$(cat /proc/stb/info/vumodel)
elif [ -f /proc/stb/info/boxtype ]; then
    DEVICE_NAME=$(cat /proc/stb/info/boxtype)
elif [ -f /proc/stb/info/model ]; then
    DEVICE_NAME=$(cat /proc/stb/info/model)
else
    DEVICE_NAME="Unknown"
fi

# فخ أخير: لو لسه مصر إنه dm8000، هنسحب الاسم من الهوست نيم بتاع الجهاز
if [ "$DEVICE_NAME" = "dm8000" ] && [ -f /etc/hostname ]; then
    DEVICE_NAME=$(cat /etc/hostname)
fi

print_success "Detected Device: ${YELLOW}${DEVICE_NAME}${NC}"

# استخراج اسم الصورة الفعلي
if [ -f /etc/issue ]; then
    IMAGE_NAME=$(sed -n '1p' /etc/issue | sed -e 's/[Ww]elcome to //g' -e 's/\\n//g' -e 's/\\l//g' | awk '{print $1}')
else
    IMAGE_NAME="Unknown"
fi
print_success "Detected Image: ${YELLOW}${IMAGE_NAME}${NC}"

# التعرف على إصدار البايثون
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

# 5. تحميل وتثبيت الإضافات
if [ -n "$PYTHON_VERSION" ]; then
    install_extension "DataMonitor" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/DataMonitor/datamonitor_py${PYTHON_VERSION}.ipk"
    install_extension "FuryDisk" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/FuryDisk/furydisk_py${PYTHON_VERSION}.ipk"
    install_extension "AIFury" "https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/AIFury/aifury_py${PYTHON_VERSION}.ipk"
fi

# ==============================================================================
# نهاية التثبيت
# ==============================================================================
print_divider
echo -e "${GREEN}             🎉 Fury-FHD & Extensions Installed/Updated Successfully! 🎉 ${NC}"
echo -e "${CYAN}             Please restart your Enigma2 GUI to apply changes.          ${NC}"
print_divider
exit 0
