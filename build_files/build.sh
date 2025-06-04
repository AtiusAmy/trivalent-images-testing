#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf config-manager --add-repo "https://repo.secureblue.dev/secureblue.repo"
dnf config-manager --set-disabled "secureblue"
dnf -y --enablerepo "secureblue" --nogpgcheck  install trivalent


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#echo "Installing secureblue Trivalent selinux policy"
#echo "Install 'selinux-policy-devel' build package & it's dependencies"
#dnf -y install selinux-policy-devel
#echo "Downloading secureblue Trivalent selinux policy"
#mkdir -p ./selinux/trivalent
#cd ./selinux/trivalent
#SELINUX_POLICY_URL="https://raw.githubusercontent.com/secureblue/secureblue/refs/heads/live/files/scripts/selinux/trivalent"
#curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.fc" --output-dir "${PWD}"
#curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.if" --output-dir "${PWD}"
#curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.te" --output-dir "${PWD}"
#curl -fLs --create-dirs -O "${SELINUX_POLICY_URL}/trivalent.sh" --output-dir "${PWD}"
#echo "Executing trivalent.sh script"
#bash "${PWD}/trivalent.sh"
#cd ../..
#echo "Cleaning up build package 'selinux-policy-devel' & it's dependencies"
#dnf -y remove selinux-policy-devel

echo "Assure that network sandbox is always disabled by default (to ensure that login data remains)"
echo "https://github.com/fedora-silverblue/issue-tracker/issues/603"
echo -e '\nCHROMIUM_FLAGS+=" --disable-features=NetworkServiceSandbox"' >> /etc/trivalent/trivalent.conf

echo "Enable middle-click scrolling by default"
sed -i '/CHROMIUM_FLAGS+=" --enable-features=\$FEATURES"/d' /etc/trivalent/trivalent.conf
echo -e '\nFEATURES+=",MiddleClickAutoscroll"\nCHROMIUM_FLAGS+=" --enable-features=$FEATURES"' >> /etc/trivalent/trivalent.conf
