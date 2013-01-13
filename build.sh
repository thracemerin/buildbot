#!/bin/bash

if [ -z "$LUNCH" ]
then
  echo LUNCH not specified
  exit 1
fi

BASE=$(pwd)


export PATH=${PATH}:$BASE/prebuilts/misc/linux-x86/ccache:/var/lib/jenkins/bin

export USE_CCACHE=1
export CCACHE_NLEVELS=4
export CM_FAST_BUILD=1

ccache -M 100G

repo sync

. vendor/cm/get-prebuilts

LAST_CLEAN=0
if [ -f .clean ]
then
  LAST_CLEAN=$(date -r .clean +%s)
fi
TIME_SINCE_LAST_CLEAN=$(expr $(date +%s) - $LAST_CLEAN)
TIME_SINCE_LAST_CLEAN=$(expr $TIME_SINCE_LAST_CLEAN / 60 / 60)
if [ $TIME_SINCE_LAST_CLEAN -ge "24" ]
then
  echo "Cleaning!" 
  touch .clean
  make clobber
else
  echo "Last clean was: $TIME_SINCE_LAST_CLEAN hours ago, skipping clean"
fi

. build/envsetup.sh
lunch cm_${LUNCH}-userdebug

time mka bacon
