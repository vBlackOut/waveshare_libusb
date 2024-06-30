apk add build-base linux-headers linux-lts-dev wget ncurses-dev bc flex bison elfutils-dev

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.34.tar.xz
tar -xvf linux-6.6.34.tar.xz
mv linux-6.6.34 /usr/src/linux-headers-6.6.34-1-lts

# prepare kernel configuration
cp /boot/config-$(uname -r) .config

# default configuration
#make defconfig 

echo 'CONFIG_MODULES=y' >> .config
echo 'CONFIG_MODULE_UNLOAD=y' >> .config
echo 'CONFIG_MODULE_FORCE_UNLOAD=y' >> .config
echo 'CONFIG_DEBUG_KERNEL=y' >> .config
echo 'CONFIG_DEBUG_INFO=y' >> .config
echo 'CONFIG_DEBUG_FS=y' >> .config
echo 'CONFIG_GDB_SCRIPTS=y' >> .config
echo 'CONFIG_MAGIC_SYSRQ=y' >> .config

make -j$(nproc)
make modules_install
make install

# aller dans le repertoire waveshare pour compiler
make

# preparation du noyaux linux avec le driver
cp ch34x_pis.ko /lib/modules/$(uname -r)/kernel/drivers/
depmod
modprobe ch34x_pis

# verification
lsmod | grep ch34x_pis

# ajout au chargement / boot /démarrage de la machine
echo "ch34x_pis" | sudo tee -a /etc/modules

# test du module
dmesg | grep ch34x
