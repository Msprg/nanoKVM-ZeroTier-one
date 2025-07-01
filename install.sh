#!/usr/bin/busybox sh

echo "===> Installing LSB functions..."
mkdir /lib/lsb
cp ./init-functions /lib/lsb/
chmod +x /lib/lsb/init-functions

echo "===> Installing ZeroTier Binaries..."
cd zt || exit
curl -O https://download.zerotier.com/debian/bullseye/pool/main/z/zerotier-one/zerotier-one_1.8.1_riscv64.deb
ar x zerotier-one_1.8.1_riscv64.deb && xzcat data.tar.xz | tar -xvf -

cp -r ./usr/sbin/* /usr/sbin/
cp -r ./etc/init.d/zerotier-one /etc/init.d/S97zerotier-one

# do we... not need this config...? Not sure...
# mv ./etc/init/zerotier-one.conf /etc/init/
cp -r ./var/lib/zerotier-one /var/lib/
cd ..

echo "===> Installing dependencies (dynamic libraries...)"
cd libs || exit
# curl -O wget http://ftp.debian.org/debian/pool/main/g/glibc/libc6_2.40-5_riscv64.deb
ar x libc6_2.40-5_riscv64.deb && xzcat data.tar.xz | tar -xvf -
cp -r ./usr/lib/* /lib/
cd ..

echo "===> Attempting to start zerotier-one service..."
 /etc/init.d/S97zerotier-one start


