# prepare kernel configuration
cp /boot/config-$(uname -r) .config

make defconfig
echo 'CONFIG_MODULES=y' >> .config
echo 'CONFIG_MODULE_UNLOAD=y' >> .config
echo 'CONFIG_MODULE_FORCE_UNLOAD=y' >> .config
echo 'CONFIG_DEBUG_KERNEL=y' >> .config
echo 'CONFIG_DEBUG_INFO=y' >> .config
echo 'CONFIG_DEBUG_FS=y' >> .config
echo 'CONFIG_GDB_SCRIPTS=y' >> .config
echo 'CONFIG_MAGIC_SYSRQ=y' >> .config

make olddefconfig
