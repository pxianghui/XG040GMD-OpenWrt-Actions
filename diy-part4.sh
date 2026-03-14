#!/bin/bash

# turboacc
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh --no-sfe
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

# mode
echo 'src-git QModem https://github.com/FUjr/QModem' >> feeds.conf.default

# OpenClash
git clone --depth 1 https://github.com/vernesong/OpenClash.git OpenClash

# name: Remove incompatible Realtek PHY patches

cd "$(dirname "$0")/openwrt" || cd openwrt || { echo "Error: Cannot find openwrt directory"; exit 1; }

rm -f target/linux/generic/backport-6.12/793-v7.0-net-phy-realtek-fix-in-band-capabilities-for-2.5G-PH.patch
rm -f target/linux/generic/backport-6.12/794-v7.0-net-phy-realtek-support-interrupt-also-for-C22-varia.patch
rm -f target/linux/generic/pending-6.12/720-01-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch
rm -f target/linux/generic/pending-6.12/720-03-net-phy-realtek-make-sure-paged-read-is-protected-by.patch
rm -f target/linux/generic/pending-6.12/720-04-net-phy-realtek-setup-aldps.patch
rm -f target/linux/generic/pending-6.12/720-05-net-phy-realtek-detect-early-version-of-RTL8221B.patch
rm -f target/linux/generic/pending-6.12/720-07-net-phy-realtek-disable-MDIO-broadcast.patch
rm -f target/linux/generic/pending-6.12/720-07-net-phy-realtek-mark-existing-MMDs-as-present.patch
rm -f target/linux/generic/pending-6.12/720-08-net-phy-realtek-rate-adapter-in-C22-mode.patch
