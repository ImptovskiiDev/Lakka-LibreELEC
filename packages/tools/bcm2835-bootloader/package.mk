# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bcm2835-bootloader"
PKG_VERSION="543692d23dff7075915bc9c7e34abb3fe28e1c46"
PKG_SHA256="718389513a36ce7073ee26666dfbdfeb259a7e88beaac603c3b7d1f5bde067a2"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.broadcom.com"
PKG_URL="${DISTRO_SRC}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux bcmstat"
PKG_LONGDESC="bcm2835-bootloader: Tool to create a bootable kernel for RaspberryPi"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/bootloader
    cp -PRv LICENCE* ${INSTALL}/usr/share/bootloader
    cp -PRv bootcode.bin ${INSTALL}/usr/share/bootloader
    if [ "${DEVICE:0:4}" = "RPi4" ]; then
      cp -PRv fixup4x.dat ${INSTALL}/usr/share/bootloader/fixup.dat
      cp -PRv start4x.elf ${INSTALL}/usr/share/bootloader/start.elf
    else
      cp -PRv fixup_x.dat ${INSTALL}/usr/share/bootloader/fixup.dat
      cp -PRv start_x.elf ${INSTALL}/usr/share/bootloader/start.elf
    fi

    find_file_path bootloader/update.sh ${PKG_DIR}/files/update.sh && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
    find_file_path bootloader/canupdate.sh && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

    find_file_path config/distroconfig.txt ${PKG_DIR}/files/distroconfig.txt && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
    find_file_path config/distroconfig-composite.txt ${PKG_DIR}/files/distroconfig-composite.txt && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
    find_file_path config/config.txt ${PKG_DIR}/files/config.txt && cp -PRv ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

    if [ "${DISTRO}" = "Lakka" ]; then
      echo "disable_splash=1" >> ${INSTALL}/usr/share/bootloader/distroconfig.txt
      echo "dtparam=audio=on" >> ${INSTALL}/usr/share/bootloader/distroconfig.txt
      echo "hdmi_max_pixel_freq:0=200000000" >> ${INSTALL}/usr/share/bootloader/distroconfig.txt
      echo "hdmi_max_pixel_freq:1=200000000" >> ${INSTALL}/usr/share/bootloader/distroconfig.txt
      echo "force_turbo=0" >> ${INSTALL}/usr/share/bootloader/config.txt
    fi
}
