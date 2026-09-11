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

# دالة تحميل متوافقة مع أغلب الصور، وخصوصا OpenBH التي قد لا تحتوي على curl
# يتم استخدام curl إن وجد، وإلا wget، وإن لم يوجد أيهما يحاول تثبيت wget ثم يعيد المحاولة.
download_file() {
    URL="$1"
    OUT_FILE="$2"

    rm -f "$OUT_FILE"

    if command -v curl >/dev/null 2>&1; then
        curl -s -k -L "$URL" -o "$OUT_FILE"
        return $?
    fi

    if command -v wget >/dev/null 2>&1; then
        wget -q --no-check-certificate -O "$OUT_FILE" "$URL"
        return $?
    fi

    print_warning "curl/wget not found. Trying to install wget..."
    opkg update >/dev/null 2>&1
    opkg install wget >/dev/null 2>&1

    if command -v wget >/dev/null 2>&1; then
        wget -q --no-check-certificate -O "$OUT_FILE" "$URL"
        return $?
    fi

    if command -v curl >/dev/null 2>&1; then
        curl -s -k -L "$URL" -o "$OUT_FILE"
        return $?
    fi

    return 1
}

# محاولة تثبيت إضافة Bitrate لو كانت متاحة في Feed الصورة.
# لو غير متاحة في OpenBH يتم تجاهلها بصمت، ثم يتم تثبيت الإسكين لاحقا بدون إظهار تحذير.
install_bitrate_if_available() {
    opkg install enigma2-plugin-extensions-bitrate >/dev/null 2>&1 && return 0
    opkg install enigma2-plugin-extensions-bitrateviewer >/dev/null 2>&1 && return 0
    return 0
}

# ==============================================================================
# بداية التثبيت
# ==============================================================================
clear
print_divider
echo -e "${GREEN}                      Installing Fury-FHD Skin      ${NC}"
echo -e "${YELLOW}                      Islam Salama (Abou Yassin)               ${NC}"
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

# حذف ملفات وإضافات Fury القديمة بالكامل قبل تثبيت النسخة الجديدة
print_info "Removing old AIFury and Fury Data files..."
rm -rf "/usr/lib/enigma2/python/Plugins/Extensions/AIFury" > /dev/null 2>&1
rm -rf "/usr/lib/enigma2/python/Plugins/Extensions/Fury Data" > /dev/null 2>&1
print_success "Old AIFury and Fury Data files removed."
echo ""

# 2. التأكد من وجود أداة تحميل متوافقة
print_info "Checking download tools..."
if command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1; then
    print_success "Download tool is ready."
else
    print_warning "No download tool found. Trying to install wget..."
    opkg update > /dev/null 2>&1
    opkg install wget > /dev/null 2>&1
    if command -v wget >/dev/null 2>&1 || command -v curl >/dev/null 2>&1; then
        print_success "Download tool is ready."
    else
        print_error "Could not find curl or wget. The installer cannot continue."
        exit 1
    fi
fi
echo ""

# 3. قراءة إصدار الإسكين المتاح على GitHub من ملف furyversion.txt
print_info "Checking available Fury-FHD version on Server..."
VERSION_TMP="/tmp/furyversion.txt"
download_file "$VERSION_FILE_URL" "$VERSION_TMP"
VERSION_DATA=$(tr -d '\r' < "$VERSION_TMP" 2>/dev/null | sed -n '1p')
rm -f "$VERSION_TMP"

if [ -n "$VERSION_DATA" ] && ! echo "$VERSION_DATA" | grep -qi "Not Found"; then
    # تنسيق الملف المتوقع: 7.2# أو 7.2#رابط_الحزمة
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
    print_warning "Could not read furyversion.txt from GitHub. Installing with default package link."
fi
echo ""

# 4. التعرف على بيانات النظام (الجهاز، الصورة، إصدار البايثون)
print_info "Detecting System Information..."

# استخراج اسم الجهاز بشكل أدق
# بعض الصور تعرض /proc/stb/info/model بشكل غير صحيح مثل dm8000،
# لذلك يتم فحص أكثر من مصدر وترجيح sf8008 عند ظهوره في أي مصدر.
RAW_DEVICE_INFO=""
for DEVICE_FILE in     /proc/stb/info/boxtype     /proc/stb/info/boxmodel     /proc/stb/info/machinebuild     /proc/stb/info/model     /proc/stb/info/vumodel     /proc/stb/info/displaymodel     /proc/stb/info/oem     /proc/device-tree/model     /etc/hostname     /etc/model     /etc/boxmodel; do
    if [ -f "$DEVICE_FILE" ]; then
        RAW_DEVICE_INFO="$RAW_DEVICE_INFO $(cat "$DEVICE_FILE" 2>/dev/null | tr '\000' ' ')"
    fi
done
RAW_DEVICE_INFO="$RAW_DEVICE_INFO $(hostname 2>/dev/null)"
NORMALIZED_DEVICE_INFO=$(echo "$RAW_DEVICE_INFO" | tr '[:upper:]' '[:lower:]')

case "$NORMALIZED_DEVICE_INFO" in
    *sf8008mini*)
        DEVICE_NAME="Octagon SF8008 Mini"
        ;;
    *sf8008m*)
        DEVICE_NAME="Octagon SF8008M"
        ;;
    *sf8008*)
        DEVICE_NAME="Octagon SF8008"
        ;;
    *)
        if [ -f /proc/stb/info/boxtype ]; then
            DEVICE_NAME=$(cat /proc/stb/info/boxtype 2>/dev/null)
        elif [ -f /proc/stb/info/model ]; then
            DEVICE_NAME=$(cat /proc/stb/info/model 2>/dev/null)
        elif [ -f /proc/stb/info/vumodel ]; then
            DEVICE_NAME=$(cat /proc/stb/info/vumodel 2>/dev/null)
        else
            DEVICE_NAME="Unknown"
        fi
        ;;
esac
print_success "Detected Device: ${YELLOW}${DEVICE_NAME}${NC}"

# استخراج اسم الصورة الفعلي (تجاهل كلمة Welcome)
if [ -f /etc/issue ]; then
    IMAGE_NAME=$(sed -n '1p' /etc/issue | sed -e 's/[Ww]elcome to //g' -e 's/\\n//g' -e 's/\\l//g' | awk '{print $1}')
else
    IMAGE_NAME="Unknown"
fi
print_success "Detected Image: ${YELLOW}${IMAGE_NAME}${NC}"

# التعرف على إصدار البايثون بنفس الطريقة الموثوقة
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

# تجهيز اعتماد Bitrate إن كان متاحا في Feed الصورة، بدون إظهار أي تحذيرات إذا لم يكن متاحا.
print_info "Checking Bitrate dependency..."
install_bitrate_if_available
print_success "Bitrate dependency check completed."
echo ""

# 5. تحميل وتثبيت الإسكين الأساسي
print_info "Downloading Fury-FHD skin package${VERSION_LABEL} from Server..."
download_file "${SKIN_URL}" /tmp/fury.ipk

if [ -s /tmp/fury.ipk ] && ! grep -q "Not Found" /tmp/fury.ipk 2>/dev/null; then
    print_info "Installing Fury-FHD Skin${VERSION_LABEL}..."
    INSTALL_LOG="/tmp/fury_install.log"
    opkg install --force-reinstall --force-overwrite /tmp/fury.ipk > "$INSTALL_LOG" 2>&1
    INSTALL_STATUS=$?

    # OpenBH fix:
    # بعض صور OpenBH لا توفر الحزمة باسم enigma2-plugin-extensions-bitrate،
    # رغم أن الإسكين يطلبها كاعتماد داخل ملف ipk.
    # لو الفشل سببه هذا الاعتماد فقط، يتم إعادة التثبيت مع تجاهل الاعتماد المفقود بصمت
    # حتى لا يظهر تحذير Bitrate أثناء التثبيت.
    if [ "$INSTALL_STATUS" != "0" ] && grep -q "enigma2-plugin-extensions-bitrate" "$INSTALL_LOG" 2>/dev/null; then
        opkg install --force-reinstall --force-overwrite --force-depends /tmp/fury.ipk > "$INSTALL_LOG" 2>&1
        INSTALL_STATUS=$?
    fi

    rm -f /tmp/fury.ipk

    if [ "$INSTALL_STATUS" = "0" ]; then
        print_success "Fury-FHD Skin${VERSION_LABEL} Installed Successfully."
        rm -f "$INSTALL_LOG"
    else
        print_error "Fury-FHD installation failed. Showing opkg error:"
        cat "$INSTALL_LOG"
        print_error "Log saved at: $INSTALL_LOG"
        exit 1
    fi
else
    rm -f /tmp/fury.ipk
    print_error "Error downloading Fury-FHD from Server."
    exit 1
fi
echo ""

# 6. تحميل وتثبيت إضافة AIFury فقط بالمعمارية الصحيحة
if [ -n "$PYTHON_VERSION" ]; then
    print_info "Detecting Architecture for AIFury Plugin..."
    SYS_ARCH=$(uname -m)
    if [ "$SYS_ARCH" = "aarch64" ]; then
        BASE_ARCH="aarch64"
    elif echo "$SYS_ARCH" | grep -q "mips"; then
        BASE_ARCH="mipsel"
    else
        BASE_ARCH="arm"
    fi
    print_success "Detected Architecture: ${YELLOW}${BASE_ARCH}${NC}"

    AIFURY_URL="https://raw.githubusercontent.com/islam-2412/IPKS/main/fury/AIFury/aifury_py${PYTHON_VERSION}_${BASE_ARCH}.ipk"
    AIFURY_FILE="/tmp/aifury.ipk"

    print_info "Downloading AIFury for Python ${PYTHON_VERSION} and Arch ${BASE_ARCH}..."
    download_file "$AIFURY_URL" "$AIFURY_FILE"

    if [ -s "$AIFURY_FILE" ] && ! grep -q "Not Found" "$AIFURY_FILE" 2>/dev/null; then
        print_info "Installing AIFury..."
        opkg install --force-reinstall --force-overwrite "$AIFURY_FILE" > /dev/null 2>&1
        rm -f "$AIFURY_FILE"
        print_success "AIFury Installed Successfully."
    else
        rm -f "$AIFURY_FILE"
        print_warning "AIFury IPK not found on Server for this architecture/Python version. Skipping..."
    fi
    echo ""
fi

# ==============================================================================
# نهاية التثبيت
# ==============================================================================
print_divider
echo -e "${GREEN}              Fury-FHD${VERSION_LABEL} Installed/Updated Successfully!  ${NC}"
echo -e "${MAGENTA}                           Long live Egypt.               ${NC}"
echo -e "${CYAN}             Please restart your Enigma2 GUI to apply changes.          ${NC}"
print_divider
exit 0
