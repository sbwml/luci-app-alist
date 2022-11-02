# luci-app-alist

A file list program that supports multiple storage.

## How to build

- Enter in your openwrt dir

- Openwrt official SnapShots

  *1. update golang 19.x (Fix build for `openwrt-21.02/22.03` branches)*
  ```shell
  rm -rf feeds/packages/lang/golang
  svn export https://github.com/sbwml/packages_lang_golang/branches/19.x feeds/packages/lang/golang
  ```

  *2. get luci-app-alist source & building*
  ```shell
  git clone https://github.com/sbwml/luci-app-alist package/alist
  make menuconfig # choose LUCI -> Applications -> luci-app-alist
  make V=s
  ```

--------------

## How to install prebuilt packages (OpenWrt 18-22 & master)

- Login OpenWrt terminal (SSH)

- Install `curl` package
  ```shell
  opkg update
  opkg install curl
  ```

- Execute install script (Multi-architecture support)
  ```shell
  sh -c "$(curl -ksS https://raw.githubusercontent.com/sbwml/luci-app-alist/master/install.sh)"
  ```

--------------

![](https://user-images.githubusercontent.com/16485166/190462187-5d54725e-1d9b-45f3-854f-403b882fb223.png)

