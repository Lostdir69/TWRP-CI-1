#!/bin/bash

# Device
export TWRP_MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp"
export TWRP_BRANCH="twrp-12.1"
#export TWRP_BRANCH="twrp-test"
export DT_LINK=" https://github.com/LMAO-armv8/twrp_motorola_hawaiipl -b twrp-12"

export DEVICE="hawaiipl"
export OEM="motorola"
#export PLATFORM="mt6765"
export TARGET="bootimage"
export TW_DEVICE_VERSION="2"
export OUTPUT="boot.img"
export FILENAME="twrp*.img"

# Kernel Source
# Uncomment the next line if you want to clone a kernel source.
#export KERNEL_SOURCE="https://github.com/faoliveira78/android_kernel_oneplus_msm8998"

# Extra Command
export EXTRA_CMD=""

# Not Recommended to Change
if [ ! -e $HOME/work ]; then
mkdir $HOME/work
fi

export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16

if [ ! -z "$PLATFORM" ]; then
    export KERNEL_PATH="kernel/$OEM/$PLATFORM"
else
    export KERNEL_PATH="kernel/$OEM/$DEVICE"
fi
export DT_PATH="device/$OEM/$DEVICE"
