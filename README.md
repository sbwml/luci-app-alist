# luci-app-alist

A file list program that supports multiple storage.

## How to build

Enter in your openwrt/package/ or other

### Openwrt official SnapShots

```shell
git clone https://github.com/sbwml/openwrt-alist --depth=1
make menuconfig # choose LUCI -> Applications -> luci-app-alist
make V=s
```
