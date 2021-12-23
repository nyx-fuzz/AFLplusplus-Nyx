#!/bin/bash
set -e

echo "[?] Checking packer ..."
if [ ! -d "packer" ]; then
	echo "[*] Setting up Nyx Packer ..."
    git clone https://github.com/nyx-fuzz/packer.git
    cd packer
    git checkout 9272fe10b123d1166acd29f6dd304dccaa3731a1
    cd linux_initramfs/
    sh pack.sh
    cd ../packer/compiler/
    make 
    cd ../../../
    cp nyx_default.ini packer/packer/nyx.ini
fi

echo "[?] Checking libnyx ..."
if [ ! -f "libnyx/libnyx//target/release/liblibnyx.a" ]; then
	echo "[*] Setting up libnyx ..."
    if [ ! -d "libnyx" ]; then
        git clone https://github.com/nyx-fuzz/libnyx.git
    fi
    cd libnyx
    git checkout a199ed31e7ff325488f6cde762b85c835ef32329
    cd libnyx
    cargo build --release
    cd ../../
fi

echo "[?] Checking QEMU-Nyx ..."
if [ ! -f "QEMU-Nyx/x86_64-softmmu/qemu-system-x86_64" ]; then
	echo "[*] Setting up QEMU-Nyx ..."
    if [ ! -d "QEMU-Nyx" ]; then
        git clone https://github.com/nyx-fuzz/QEMU-Nyx.git
    fi
    cd QEMU-Nyx/
    git checkout 18ad4753d35fedfc93d3b5b0d60ff773c200ee96
    ./compile_qemu_nyx.sh
    cd ..
fi

make
