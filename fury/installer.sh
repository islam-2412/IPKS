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

# روابط ملفات الإسكين على GitHub
VERSION_FILE_URL="https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/furyversion.txt"
DEFAULT_SKIN_URL="https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/fury.ipk"
SKIN_URL="$DEFAULT_SKIN_URL"
SKIN_VERSION=""
VERSION_LABEL=""

# ==============================================================================
# دوال الطباعة الجمالية (Functions)
# ==============================================================================
print_info() { echo -e "${BLUE}[ INFO ]${NC} $1"; }
print_success() { echo -e "${GREEN}[ SUCCESS ]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[ WARNING ]${NC} $1"; }
print_error() { echo -e "${RED}[ ERROR ]${NC} $1"; }
print_divider() { echo -e "${CYAN}========================================================================${NC}"; }

# ==============================================================================
# بداية التثبيت
# ==============================================================================
clear
print_divider
echo -e "${GREEN}                       Installing Skin Fury-FHD  2025     ${NC}"
echo -e "${MAGENTA}                         Islam Salama (Abou Yassin)               ${NC}"
print_divider
echo ""

# 1. تنظيف الإصدارات القديمة من الإسكين
print_info "Removing the previous version of Fury-FHD..."
sleep 1
if [ -d /usr/share/enigma2/Fury-FHD ] ; then
    # إضافة force-depends لضمان الحذف السلس على صور مثل OpenBH
    opkg remove enigma2-plugin-skins-fury-fhd --force-depends > /dev/null 2>&1
    rm -rf /usr/share/enigma2/Fury-FHD > /dev/null 2>&1
    print_success "Skin package removed."
else
    print_info "There are no previous versions of Fury-FHD."
fi
echo ""

# 2. التأكد من توفر أدوات التحميل (curl / wget)
print_info "Checking downloading tools..."
if ! command -v curl > /dev/null 2>&1; then
    opkg update > /dev/null 2>&1
    opkg install curl > /dev/null 2>&1
fi
print_success "Dependencies ready."
echo ""

# 3. قراءة إصدار الإسكين المتاح على GitHub من ملف furyversion.txt
print_info "Checking available Fury-FHD version on Server... "
# استخدام wget كخيار أساسي لأنه مدعوم افتراضياً، و curl كاحتياطي
VERSION_DATA=$(wget -qO- --no-check-certificate "$VERSION_FILE_URL" || curl -s -k -L "$VERSION_FILE_URL")
VERSION_DATA=$(echo "$VERSION_DATA" | tr -d '\r' | sed -n '1p')

if [ -n "$VERSION_DATA" ] && ! echo "$VERSION_DATA" | grep -qi "Not Found"; then
    SKIN_VERSION=$(echo "$VERSION_DATA" | cut -d'#' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    VERSION_SKIN_URL=$(echo "$VERSION_DATA" | cut -s -d'#' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [ -n "$VERSION_SKIN_URL" ]; then
        SKIN_URL="$VERSION_SKIN_URL"
    fi

    if [ -n "$SKIN_VERSION" ]; then
        VERSION_LABEL=" v${SKIN_VERSION}"
        print_success "Available Fury-FHD Version on Server: ${YELLOW}${SKIN_VERSION}${NC}"
    else
        VERSION_LABEL=""
        print_warning "furyversion.txt was found, but the version value is empty."
    fi
else
    VERSION_LABEL=""
    print_warning "Could not read furyversion.txt from Server. Installing with default package link."
fi
echo ""

# 4. التعرف على بيانات النظام (الجهاز، الصورة، إصدار البايثون)
print_info "Detecting System Information..."

RAW_DEVICE_INFO=""
for DEVICE_FILE in /proc/stb/info/boxtype /proc/stb/info/machinebuild /proc/stb/info/model /proc/stb/info/vumodel /proc/stb/info/oem /etc/hostname; do
    if [ -f "$DEVICE_FILE" ]; then
        RAW_DEVICE_INFO="$RAW_DEVICE_INFO $(cat "$DEVICE_FILE" 2>/dev/null)"
    fi
done
RAW_DEVICE_INFO="$RAW_DEVICE_INFO $(hostname 2>/dev/null)"
NORMALIZED_DEVICE_INFO=$(echo "$RAW_DEVICE_INFO" | tr '[:upper:]' '[:lower:]')

case "$NORMALIZED_DEVICE_INFO" in
    *sf8008mini*) DEVICE_NAME="Octagon SF8008 Mini" ;;
    *sf8008m*) DEVICE_NAME="Octagon SF8008M" ;;
    *sf8008*) DEVICE_NAME="Octagon SF8008" ;;
    *)
        if [ -f /proc/stb/info/boxtype ]; then DEVICE_NAME=$(cat /proc/stb/info/boxtype 2>/dev/null)
        elif [ -f /proc/stb/info/model ]; then DEVICE_NAME=$(cat /proc/stb/info/model 2>/dev/null)
        elif [ -f /proc/stb/info/vumodel ]; then DEVICE_NAME=$(cat /proc/stb/info/vumodel 2>/dev/null)
        else DEVICE_NAME="Unknown"
        fi
        ;;
esac
print_success "Detected Device: ${YELLOW}${DEVICE_NAME}${NC}"

if [ -f /etc/issue ]; then
    IMAGE_NAME=$(sed -n '1p' /etc/issue | sed -e 's/[Ww]elcome to //g' -e 's/\\n//g' -e 's/\\l//g' | awk '{print $1}')
else
    IMAGE_NAME="Unknown"
fi
print_success "Detected Image: ${YELLOW}${IMAGE_NAME}${NC}"

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

# 5. تحميل وتثبيت الإسكين الأساسي
print_info "Downloading Fury-FHD skin package${VERSION_LABEL} from Server..."
wget -q --no-check-certificate "${SKIN_URL}" -O /tmp/fury.ipk || curl -s -k -L "${SKIN_URL}" -o /tmp/fury.ipk

if [ -s /tmp/fury.ipk ] && ! grep -q "Not Found" /tmp/fury.ipk 2>/dev/null; then
    print_info "Installing Fury-FHD Skin${VERSION_LABEL}..."
    
    # محاولة التثبيت الافتراضية مع فرض تخطي مشاكل الـ dependencies لصورة OpenBH
    opkg install --force-reinstall --force-overwrite --force-depends /tmp/fury.ipk > /dev/null 2>&1
    
    # المعالجة الخاصة بصورة OpenBH (التثبيت الإجباري عن طريق فك الضغط اليدوي إذا رفض opkg)
    if [ ! -d /usr/share/enigma2/Fury-FHD ]; then
        print_warning "Standard installation blocked by Image (OpenBH). Extracting manually..."
        cd /tmp
        ar x /tmp/fury.ipk data.tar.gz data.tar.xz 2>/dev/null
        if [ -f /tmp/data.tar.gz ]; then
            tar -xzf /tmp/data.tar.gz -C / > /dev/null 2>&1
        elif [ -f /tmp/data.tar.xz ]; then
            tar -xJf /tmp/data.tar.xz -C / > /dev/null 2>&1
        fi
        # تنظيف ملفات الفك اليدوي
        rm -f /tmp/data.tar.gz /tmp/data.tar.xz /tmp/control.tar.gz /tmp/debian-binary
    fi

    # التحقق النهائي من نجاح التثبيت (سواء بالـ opkg أو بالفك اليدوي)
    if [ -d /usr/share/enigma2/Fury-FHD ]; then
        rm -f /tmp/fury.ipk
        print_success "Fury-FHD Skin${VERSION_LABEL} Installed Successfully."
    else
        rm -f /tmp/fury.ipk
        print_error "Failed to install Fury-FHD Skin. System rejected extraction."
    fi
else
    rm -f /tmp/fury.ipk
    print_error "Error downloading Fury-FHD from Server."
fi
echo ""

# ==============================================================================
# نهاية التثبيت
# ==============================================================================
print_divider
echo -e "${GREEN}             ✅ Fury-FHD${VERSION_LABEL} Installed Successfully! ✅ ${NC}"
# ==============================================================================

echo -e "${CYAN}             Please restart your Enigma2 GUI to apply changes.          ${NC}"
print_divider
exit 0
