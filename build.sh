#!/usr/bin/env bash

if [ -z "$LUNCH" ]
then
  echo LUNCH not specified
  exit 1
fi

BASE=$(pwd)


export PATH=${PATH}:$BASE/prebuilts/misc/linux-x86/ccache:~/bin

export USE_CCACHE=1
export CCACHE_NLEVELS=4
export CM_FAST_BUILD=1

ccache -M 100G

repo sync

. vendor/cm/get-prebuilts

make clean

. build/envsetup.sh
lunch cm_${LUNCH}-userdebug

time mka bacon
