#!/bin/sh
RED_COLOR='\e[1;31m'
GREEN_COLOR='\e[1;32m'
RES='\e[0m'

# OpenWrt Info
version=$(cat /etc/os-release | grep VERSION_ID | awk -F "[\"\"]" '{print $2}' | awk -F. '{print $1}')
platform=$(opkg print-architecture | awk 'END{print $2}')

# TMP
TMPDIR=$(mktemp -d) || exit 1

# GitHub mirror
ip_info=$(curl -s https://ip.cooluc.com)
country_code=$(echo $ip_info | sed -r 's/.*country_code":"([^"]*).*/\1/')
if [ $country_code = "CN" ]; then
	google_status=$(curl -I -4 -m 3 -o /dev/null -s -w %{http_code} http://www.google.com/generate_204)
	if [ ! $google_status = "204" ];then
		mirror="https://github.cooluc.com/"
	fi
fi

# Check
CHECK() (
	echo -e "\r\n${GREEN_COLOR}Checking available space  ...${RES}"
	ROOT_SPACE=$(df -m /usr | awk 'END{print $4}')
	if [ $ROOT_SPACE -lt 40 ]; then
		echo -e "${RED_COLOR}Error, The system storage space is less than 40MB.${RES}"
		exit 1;
	fi
	echo -e "\r\n${GREEN_COLOR}Checking platform  ...${RES}"
	prebuilt="aarch64_cortex-a53 aarch64_cortex-a72 aarch64_generic arm_arm1176jzf-s_vfp arm_arm926ej-s arm_cortex-a15_neon-vfpv4 arm_cortex-a5_vfpv4 arm_cortex-a7 arm_cortex-a7_neon-vfpv4 arm_cortex-a8_vfpv3 arm_cortex-a9 arm_cortex-a9_neon arm_cortex-a9_vfpv3-d16 arm_fa526 arm_mpcore arm_xscale i386_pentium-mmx i386_pentium4 mips64_octeonplus mips_24kc mips_4kec mips_mips32 mipsel_24kc mipsel_24kc_24kf mipsel_74kc mipsel_mips32 x86_64"
	if [[ "$version" != "21" ]] && [[ "$version" != "22" ]]; then
		echo -e "${RED_COLOR}Error! OpenWrt \"$(cat /etc/os-release | grep VERSION_ID | awk -F "[\"\"]" '{print $2}')\" version is not supported.${RES}"
		exit 1;
	elif [[ ! "$prebuilt" =~ "$platform" ]]; then
		echo -e "${RED_COLOR}Error! The current \"$platform\" platform is not currently supported.${RES}"
		exit 1;
	fi
)

DOWNLOAD() (
	echo -e "\r\n${GREEN_COLOR}Download Packages ...${RES}\r\n"
	# get repos info
	curl -s --connect-timeout 10 "https://api.github.com/repos/sbwml/luci-app-alist/releases" | grep "browser_download_url" > $TMPDIR/releases.txt
	if [ $? -ne 0 ]; then
		echo -e "${RED_COLOR}Failed to get version information, Please check the network status.${RES}"
		rm -rf $TMPDIR
		exit 1
	fi

	alist=$(cat $TMPDIR/releases.txt | grep "browser_download_url" | grep $platform.ipk | head -1 | awk '{print $2}' | sed 's/\"//g')
	luci_app=$(cat $TMPDIR/releases.txt | grep "browser_download_url" | grep luci-app-alist_ | head -1 | awk '{print $2}' | sed 's/\"//g')
	luci_i18n=$(cat $TMPDIR/releases.txt | grep "browser_download_url" | grep luci-i18n-alist-zh-cn | head -1 | awk '{print $2}' | sed 's/\"//g')

	# download
	echo -e "${GREEN_COLOR}Download $alist ...${RES}"
	curl --connect-timeout 30 -m 600 -Lo "$TMPDIR/alist_$platform.ipk" $mirror$alist
	if [ $? -ne 0 ]; then
		echo -e "${RED_COLOR}Error! download $alist failed.${RES}"
		rm -rf $TMPDIR
		exit 1
	fi
	echo -e "${GREEN_COLOR}Download $luci_app ...${RES}"
	curl --connect-timeout 30 -m 600 -Lo "$TMPDIR/luci-app-alist.ipk" $mirror$luci_app
	if [ $? -ne 0 ]; then
		echo -e "${RED_COLOR}Error! download $luci_app failed.${RES}"
		rm -rf $TMPDIR
		exit 1
	fi
	echo -e "${GREEN_COLOR}Download $luci_i18n ...${RES}"
	curl --connect-timeout 30 -m 600 -Lo "$TMPDIR/luci-i18n-alist-zh-cn.ipk" $mirror$luci_i18n
	if [ $? -ne 0 ]; then
		echo -e "${RED_COLOR}Error! download $luci_i18n failed.${RES}"
		rm -rf $TMPDIR
		exit 1
	fi
)

INSTALL() (
	# Install
	echo -e "\r\n${GREEN_COLOR}Install Packages ...${RES}\r\n"
	opkg install $TMPDIR/alist_$platform.ipk
	opkg install $TMPDIR/luci-app-alist.ipk
	opkg install $TMPDIR/luci-i18n-alist-zh-cn.ipk
	rm -rf $TMPDIR /tmp/luci-*
	echo -e "${GREEN_COLOR}Done!${RES}"
)

CHECK
if [ $? -eq 0 ]; then
	DOWNLOAD
else
	exit 1
fi
if [ $? -eq 0 ]; then
	INSTALL
fi
