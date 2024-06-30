# Installez les en-têtes du noyau
apk add linux-headers linux-lts-dev

# Vérifiez l'emplacement des en-têtes du noyau
ls /usr/src

# Créez le lien symbolique build si nécessaire
sudo rm /lib/modules/6.6.36-0-lts/build
sudo ln -s /usr/src/linux-headers-6.6.36-0-lts /lib/modules/6.6.36-0-lts/build

# Préparez les sources du noyau
cd /usr/src/linux-headers-6.6.36-0-lts
make oldconfig
make prepare
make modules_prepare

# Compilez votre module
cd /usr/src/waveshare_driver
make clean
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules

# Installez et chargez le module
sudo cp ch34x_pis.ko /lib/modules/$(uname -r)/kernel/drivers/
sudo depmod
sudo modprobe ch34x_pis

# Vérifiez les logs du noyau
dmesg | tail
