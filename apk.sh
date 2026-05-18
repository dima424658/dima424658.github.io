#!/usr/bin/env bash

REPO="${REPO:=${HOME}/Git/openwrt}"

CONFIG_USE_APK="y" make package/sing-box-extended/compile package/podkop/compile package/luci-app-podkop/compile -j28 -C ${REPO}
CONFIG_USE_APK="" make package/sing-box-extended/compile package/podkop/compile package/luci-app-podkop/compile -j28 -C ${REPO}

rm *.apk *.ipk

cp ${REPO}/bin/packages/aarch64_cortex-a53/base/{sing-box*,*podkop*} .

${REPO}/staging_dir/host/bin/apk mkndx --root . --keys-dir . --allow-untrusted --sign ./keys/private-key.pem --output packages.adb *.apk
MKHASH=${REPO}/staging_dir/host/bin/mkhash ${REPO}/scripts/ipkg-make-index.sh . 2>&1 > Packages
${REPO}/staging_dir/host/bin/usign -S -m Packages -s ./keys/key-build;
