#!/bin/sh
RED_COLOR='\e[1;31m'
GREEN_COLOR='\e[1;32m'
RES='\e[0m'

# sysinfo
if [ -f /etc/openwrt_release ]; then
	. /etc/openwrt_release
	version=$(echo ${DISTRIB_RELEASE%%.*})
	platform=$(echo $DISTRIB_ARCH)
	ldd_version=$(ldd --version 2>&1 | grep Version | awk '{print $2}')
	[ ${ldd_version%.*} = "1.2" ] && sdk=22.03 || sdk=21.02
else
	echo -e "${RED_COLOR}Unknown OpenWRT Version${RES}"
	exit 1
fi

# check luci
if [ -d "/usr/share/luci/menu.d" ]; then
	luci=js
else
	luci=lua
fi

# temp
temp_dir=$(mktemp -d) || exit 1

# github mirror
ip_info=$(curl -sk https://ip.cooluc.com)
country_code=$(echo $ip_info | sed -r 's/.*country_code":"([^"]*).*/\1/')
if [ $country_code = "CN" ]; then
	google_status=$(curl -I -4 -m 3 -o /dev/null -s -w %{http_code} http://www.google.com/generate_204)
	if [ ! $google_status = "204" ];then
		mirror="https://ghfast.top/"
	fi
fi

CHECK() (
	echo -e "\n${GREEN_COLOR}Checking available space  ...${RES}"
	ROOT_SPACE=$(df -m /usr | awk 'END{print $4}')
	if [ $ROOT_SPACE -lt 40 ]; then
		echo -e "\n${RED_COLOR}Error, The system storage space is less than 40MB.${RES}"
		exit 1;
	fi
	echo -e "\n${GREEN_COLOR}Checking platform  ...${RES}\n"
	prebuilt="aarch64_cortex-a53 aarch64_cortex-a72 aarch64_generic arm_arm1176jzf-s_vfp arm_arm926ej-s arm_cortex-a15_neon-vfpv4 arm_cortex-a5_vfpv4 arm_cortex-a7 arm_cortex-a7_neon-vfpv4 arm_cortex-a8_vfpv3 arm_cortex-a9 arm_cortex-a9_neon arm_cortex-a9_vfpv3-d16 arm_fa526 arm_mpcore arm_xscale i386_pentium-mmx i386_pentium4 mips64_octeonplus mips_24kc mips_4kec mips_mips32 mipsel_24kc mipsel_24kc_24kf mipsel_74kc mipsel_mips32 x86_64"
	verif=$(expr match "$prebuilt" ".*\($platform\)")
	if [[ ! $verif ]]; then
		echo -e "${RED_COLOR}Error! The current \"$platform\" platform is not currently supported.${RES}"
		exit 1;
	fi
)

INSTALL_DEPEND() (
	opkg update
	opkg install luci-compat
)

DOWNLOAD() (
	echo -e "\n${GREEN_COLOR}Download "$mirror"https://github.com/sbwml/luci-app-alist/releases/latest/download/openwrt-$sdk-$platform.tar.gz ...${RES}\n"
	curl --connect-timeout 5 -m 300 -kLo "$temp_dir/openwrt-$sdk-$platform.tar.gz" "$mirror"https://github.com/sbwml/luci-app-alist/releases/latest/download/openwrt-$sdk-$platform.tar.gz
	if [ $? -ne 0 ]; then
		echo -e "\n${RED_COLOR}Error! Download openwrt-$sdk-$platform.tar.gz failed.${RES}"
		rm -rf $temp_dir
		exit 1
	fi
	if [ "$luci" = lua ]; then
		echo -e "\n${GREEN_COLOR}Download "$mirror"https://github.com/sbwml/luci-app-alist/releases/download/v3.35.0/luci-app-alist_1.0.13_all.ipk ...${RES}\n"
		curl --connect-timeout 5 -m 120 -kLo "$temp_dir/luci-app-alist.ipk" "$mirror"https://github.com/sbwml/luci-app-alist/releases/download/v3.35.0/luci-app-alist_1.0.13_all.ipk
		echo -e "\n${GREEN_COLOR}Download "$mirror"https://github.com/sbwml/luci-app-alist/releases/download/v3.35.0/luci-i18n-alist-zh-cn_git-24.094.59741-2930a1c_all.ipk ...${RES}\n"
		curl --connect-timeout 5 -m 120 -kLo "$temp_dir/luci-i18n-alist-zh-cn.ipk" "$mirror"https://github.com/sbwml/luci-app-alist/releases/download/v3.35.0/luci-i18n-alist-zh-cn_git-24.094.59741-2930a1c_all.ipk
	fi
)

INSTALL() (
	echo -e "\n${GREEN_COLOR}Install Packages ...${RES}\n"
	tar -zxf $temp_dir/openwrt-$sdk-$platform.tar.gz -C $temp_dir/
	opkg install $temp_dir/packages_ci/alist*.ipk
	if [ "$luci" = lua ]; then
		opkg install $temp_dir/luci-app-alist.ipk
		opkg install $temp_dir/luci-i18n-alist-zh-cn.ipk
	else
		opkg install $temp_dir/packages_ci/luci-app-alist*.ipk
		opkg install $temp_dir/packages_ci/luci-i18n*.ipk
	fi
	rm -rf $temp_dir /tmp/luci-*
	echo -e "\n${GREEN_COLOR}Done!${RES}\n"
)

CHECK
[ "$luci" = lua ] && INSTALL_DEPEND
DOWNLOAD && INSTALL
