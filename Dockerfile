# Utiliser une image Alpine Linux de base
FROM alpine:latest

# Installer les dépendances nécessaires
RUN apk update && apk add --no-cache \
    build-base \
    linux-headers \
    elfutils-dev \
    openssl-dev \
    gmp-dev \
    mpfr-dev \
    mpc1-dev \
    perl \
    bash \
    wget \
    nano

# Installer les sources du noyau
RUN mkdir -p /usr/src/linux-headers-6.6.34-1-lts
WORKDIR /usr/src

RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.tar.xz && \
    tar -xf linux-6.6.tar.xz && \
    mv linux-6.6 linux-headers-6.6.34-1-lts && \
    rm linux-6.6.tar.xz

WORKDIR /usr/src/linux-headers-6.6.34-1-lts

# Configurer le noyau
RUN cp /boot/config-$(uname -r) .config || true
RUN sed -i 's/CONFIG_MODULE_SIG_KEY="\/home\/buildozer\/.abuild\/kernel_signing_key.pem"/CONFIG_MODULE_SIG_KEY=""/' .config && \
    sed -i 's/CONFIG_MODULE_SIG_KEY_TYPE_RSA=y/# CONFIG_MODULE_SIG_KEY_TYPE_RSA is not set/' .config && \
    sed -i 's/CONFIG_MODULE_SIG=y/# CONFIG_MODULE_SIG is not set/' .config

RUN make oldconfig && \
    make prepare && \
    make modules_prepare && \
    make modules

# Copier le driver Waveshare
ADD ./waveshare_demo/Raspberry/Driver/driver /home/Python/waveshare_demo/Raspberry/Driver/driver

# Compiler le module Waveshare
WORKDIR /home/Python/waveshare_demo/Raspberry/Driver/driver
RUN make

# Définir le répertoire de travail par défaut
WORKDIR /home/Python

# Définir le point d'entrée par défaut (par exemple bash)
CMD ["/bin/bash"]
