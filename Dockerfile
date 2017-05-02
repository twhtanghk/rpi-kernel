FROM debian:jessie

RUN apt-get update \
&&  apt-get install -y git vim curl bc build-essential \
&&  curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - \
&&  echo deb http://emdebian.org/tools/debian/ jessie main >/etc/apt/sources.list.d/cross.list \
&&  dpkg --add-architecture armhf \
&&  apt-get update \
&&  apt-get install -y binfmt-support ccache device-tree-compiler patchutils crossbuild-essential-armhf \
&&  apt-get clean

WORKDIR /data

ENV KERNEL=kernel7
RUN git clone --depth 1 https://github.com/igorpecovnik/lib \
&&  cp lib/compile.sh . \
&&  git clone --depth=1 https://github.com/raspberrypi/linux \
&&  cd linux \
&&  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig \
&&  make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

CMD top -b -d 1000
