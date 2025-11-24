#!/usr/bin/busybox sh

# Check for AARCH64 architecture
ARCH=$(uname -m)
if [ "$ARCH" != "riscv64" ]; then
    echo "This install script will not work on your device."
    echo "It is intended only for riscv architecture while you're running $ARCH architecture."
    echo "Assuming you are using nanokvm PRO you should be able to install zerotier from debian repositories."
    echo "Try running ' apt update && apt install -y zerotier-one ' "
    echo " === OR === "
    echo "Try running ' curl -s https://install.zerotier.com | bash ' "
    exit 0
fi

echo "===> Installing LSB functions..."
mkdir -p /lib/lsb
cp ./init-functions /lib/lsb/
chmod +x /lib/lsb/init-functions

echo "===> Installing ZeroTier Binaries..."
mkdir -p zt
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


