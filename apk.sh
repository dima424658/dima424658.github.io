#!/usr/bin/env bash

REPO="${REPO:=${HOME}/Git/openwrt}"

# CONFIG_USE_APK="" make package/sing-box-extended/compile package/podkop-plus/podkop/compile package/podkop-plus/luci-app-podkop-plus/compile -j28 -C ${REPO} || exit 1
# CONFIG_USE_APK="y" make package/sing-box-extended/compile package/podkop-plus/podkop/compile package/podkop-plus/luci-app-podkop-plus/compile -j28 -C ${REPO} || exit 1

CONFIG_USE_APK="" make package/podkop-plus/podkop/compile package/podkop-plus/luci-app-podkop-plus/compile -j28 -C ${REPO} || exit 1
CONFIG_USE_APK="y" make package/podkop-plus/podkop/compile package/podkop-plus/luci-app-podkop-plus/compile -j28 -C ${REPO} || exit 1

rm *.apk *.ipk

# cp ${REPO}/bin/packages/aarch64_cortex-a53/base/{sing-box*,*podkop*} .

cp ${REPO}/bin/packages/aarch64_cortex-a53/base/*podkop* .

# curl -s https://api.github.com/repos/ushan0v/podkop-plus/releases/latest | jq -r '.assets | to_entries[] | .value | .name + " " + .browser_download_url' | xargs -n2 sh -c 'curl -o "$1" -sSL "$2"' sh

${REPO}/staging_dir/host/bin/apk mkndx --root . --keys-dir . --allow-untrusted --sign ./keys/private-key.pem --output packages.adb *.apk

MKHASH=${REPO}/staging_dir/host/bin/mkhash ${REPO}/scripts/ipkg-make-index.sh . 2>&1 > Packages
${REPO}/staging_dir/host/bin/usign -S -m Packages -s ./keys/key-build;
gzip -9nc Packages > Packages.gz;
