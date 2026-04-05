#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "🛠️ Starting Ultimate Customization..."

# 1. إضافة المستودعات (Waydroid + Wine + MX Linux Tools)
sudo dpkg --add-architecture i386
wget -qO- https://repo.waydro.id | sudo bash || true
# إضافة مستودع MX Tools (لأدوات الصيانة)
sudo add-apt-repository ppa:mx-linux/mx-tools -y || true
sudo apt-get update || true

# 2. تثبيت الحزم المطلوبة (XFCE + Yaru + Wine + Waydroid + MX)
sudo apt-get install -y xubuntu-desktop yaru-theme-gtk yaru-theme-icon \
    zram-config waydroid bottles winehq-staging htop plymouth-theme-ubuntu-logo \
    xfce4-docklike-plugin xfce4-panel --fix-missing

# 3. سحر الـ Double Click (APK, EXE, MSI)
# ملف الـ APK
sudo bash -c 'cat <<EOF > /usr/share/applications/waydroid-install.desktop
[Desktop Entry]
Type=Application
Name=Install APK
Exec=waydroid app install %f
Icon=android-sdk
MimeType=application/vnd.android.package-archive;
EOF'

# ربط الصيغ ببرامجها أوتوماتيكياً
echo "application/vnd.android.package-archive=waydroid-install.desktop" | sudo tee -a /usr/share/applications/defaults.list
echo "application/x-ms-dos-executable=bottles.desktop" | sudo tee -a /usr/share/applications/defaults.list
echo "application/x-msi=bottles.desktop" | sudo tee -a /usr/share/applications/defaults.list

# 4. شكل أوبونتو (Panel على الشمال + الثيم البرتقالي)
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cat <<EOF > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Yaru-dark"/>
    <property name="IconThemeName" type="string" value="Yaru"/>
  </property>
</channel>
EOF

# 5. تظبيط الـ Plymouth (لوجو أوبونتو عند الفتح)
sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.plymouth || true

# 6. الـ Performance Tweaks (منع عمليات الخلفية + ZRAM)
sudo apt-get purge -y snapd unattended-upgrades # مسح الـ Snap والخدمات التقيلة
echo "ALGO=lz4" | sudo tee /etc/default/zramswap
echo "PERCENT=60" | sudo tee -a /etc/default/zramswap
echo "vm.swappiness=150" | sudo tee -a /etc/sysctl.conf

# تعطيل الخدمات غير الضرورية لسرعة الـ HP G62
sudo systemctl disable cups.service bluetooth.service || true

echo "✅ ALL DONE! Ultimate ISO is ready."
