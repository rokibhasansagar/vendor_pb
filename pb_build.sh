#
# Copyright © 2018, Mohd Faraz <mohd.faraz.abc@gmail.com>
#
# Custom build script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
green='\e[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
purple='\e[0;35m'
white='\e[0;37m'
DEVICE=$TARGET_PRODUCT
VERSION="2.6"
DATE=$(date -u +%Y%m%d-%H%M)
PB_VENDOR=vendor/pb
PB_WORK_DIR=$OUT/zip
RECOVERY_IMG=$OUT/recovery.img
PB_DEVICE="$TARGET_VENDOR_DEVICE_NAME-$(cut -d'_' -f2 <<<$TARGET_PRODUCT)"
ZIP_NAME=PitchBlack-$DEVICE-$VERSION-$DATE
if [ -d "$PB_WORK_DIR" ]; then
	rm -rf "$PB_WORK_DIR"
fi

if [ ! -d "PB_WORK_DIR" ]; then
	mkdir "$PB_WORK_DIR"
fi

echo -e "$(red)**** Making Zip ****$(nocol)"

echo -e "${blue}*** Copying Tools ****$(nocol)"
cp -r "$PB_VENDOR/PBTWRP" "PB_WORK_DIR"

echo -e "$(green)**** Copying Updater Scripts ****$(nocol)"
mkdir "$PB_WORK_DIR/META-INF/com/google/android"
cp -r "$PB_VENDOR/updater" "$PB_WORK_DIR/META-INF/com/google/android"
mv "$PB_WORK_DIR/META-INF/com/google/android/flash_pb.sh" "$PB_WORK_DIR"
sed -i -- "s/devicename/${PB_DEVICE}/g" "$PB_WORK_DIR/META-INF/com/google/android/update-binary"

echo -e "$(cyan)**** Copying Recovery Image ****$(nocol)"
mkdir "$PB_WORK_DIR/TWRP"
cp "$RECOVERY_IMG" "$PB_WORK_DIR/TWRP/"

echo -e "$(green)**** Compressing Files into ZIP ****$(nocol)"
cd $PB_WORK_DIR
zip -r ${ZIP_NAME}.zip *
BUILD_RESULT_STRING="BUILD SUCCESSFUL"

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
if [[ "${BUILD_RESULT_STRING}" = "BUILD SUCCESSFUL" ]]; then
echo -e "$cyan****************************************************************************************$nocol"
echo -e "$cyan*$nocol${red} ${BUILD_RESULT_STRING}$nocol"
echo -e "$cyan*$nocol$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo -e "$cyan*$nocol${green} ZIP LOCATION: ${PB_WORK_DIR}/${ZIP_NAME}.zip$nocol"
echo -e "$cyan*$nocol${green} SIZE: $( du -h ${PB_WORK_DIR}/${ZIP_NAME}.zip | awk '{print $1}' )$nocol"
echo -e "$cyan****************************************************************************************$nocol"
fi
