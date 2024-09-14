# luci-app-alist

A file list program that supports multiple storage.

## How to build

- Install `libfuse` development package.

  - ubuntu/debian:
    ```shell
    sudo apt update
    sudo apt install libfuse-dev
    ```

  - redhat:
    ```shell
    sudo yum install fuse-devel
    ```

  - arch:
    ```shell
    sudo pacman -S fuse2
    ```

- Enter in your openwrt dir

- Openwrt official SnapShots

  *1. requires golang 1.22.x or latest version (Fix build for older branches of OpenWrt.)*
  ```shell
  rm -rf feeds/packages/lang/golang
  git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
  ```

  *2. get luci-app-alist source & building*
  ```shell
  git clone https://github.com/sbwml/luci-app-alist package/alist
  make menuconfig # choose LUCI -> Applications -> luci-app-alist
  make package/alist/luci-app-alist/compile V=s # build luci-app-alist
  ```

--------------

## How to install prebuilt packages

- Login OpenWrt terminal (SSH)

- Install `curl` package
  ```shell
  opkg update
  opkg install curl
  ```

- Execute install script (Multi-architecture support)
  ```shell
  sh -c "$(curl -ksS https://raw.githubusercontent.com/sbwml/luci-app-alist/main/install.sh)"
  ```

--------------

![](https://github.com/user-attachments/assets/cf0435ec-4aa4-4c12-bcab-18949e4ea840)
