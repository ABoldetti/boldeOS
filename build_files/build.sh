#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1


dnf5 install -y \
	plasma-desktop \
	plasma-login-manager \
	kitty \
	dolphin \
	plasma-nm \
	plasma-pa \
    okular \
    vlc \
    flatpak \
    git \
    toolbox \
    zsh \
    firefox \
    fastfetch \
    plasma-workspace \
    kf6-kirigami \
    kf6-krunner \
    kf6-kcmutils \
    kf6-qqc2-desktop-style \
    qt6-qt5compat \
    qt6-qtdeclarative \
    breeze-gtk \
    plasma-breeze \
    power-profiles-daemon
	--setopt=install_weak_deps=False

# Use a COPR Example:
rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add the VS Code repository
cat << 'EOF' > /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

dnf5 install -y code

rm -f /etc/yum.repos.d/vscode.repo

#flatpak setup
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


#oh my zsh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /usr/share/oh-my-zsh

#make zsh default shell
sed -i 's|^SHELL=.*|SHELL=/usr/bin/zsh|' /etc/default/useradd
# Rebrand OS name for fastfetch, desktop settings, and bootloader entries
sed -i 's|^NAME=.*|NAME="BoldeOS"|' /usr/lib/os-release
sed -i 's|^PRETTY_NAME=.*|PRETTY_NAME="BoldeOS (Fedora Atomic)"|' /usr/lib/os-release
sed -i 's|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="boldeos"|' /usr/lib/os-release
sed -i 's|^HOME_URL=.*|HOME_URL="https://github.com/aboldetti/boldeos"|' /usr/lib/os-release

systemctl enable --force plasmalogin
systemctl set-default graphical.target
systemctl enable power-profiles-daemon.service 
systemctl enable bootc-fetch-apply-updates.timer
   

dnf5 clean all
