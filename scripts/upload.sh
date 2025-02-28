#!/bin/bash

# Source Vars
source $CONFIG

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${6042419255:AAEI4DqIyecGbO8ZUeeoUd_SqoL9n4lXYIQ}/sendMessage" \
	-d chat_id="-843349578" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directory
cd $SYNC_PATH

# Color
ORANGE='\033[0;33m'

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

#Get Version info stored in variables.h
TW_MAIN_VERSION=$(sed -n -e 's/^.*#define TW_MAIN_VERSION_STR //p' bootable/recovery/variables.h | cut -d'"' -f2)

# Change to the Output Directory
cd out/target/product/${DEVICE}

#Rename build
mv -v $OUTPUT twrp-${TW_MAIN_VERSION}-${TW_DEVICE_VERSION}-${DEVICE}.img &> /dev/null

# Upload to oshi.at
if [ -z "$TIMEOUT" ];then
    TIMEOUT=20160
fi

# Send file to Telegram
for FILENAME in twrp*.img; do 
	curl -s -F chat_id="-843349578" -F document=@"${FILENAME}" -X POST https://api.telegram.org/bot{6042419255:AAEI4DqIyecGbO8ZUeeoUd_SqoL9n4lXYIQ}/sendDocument
done
curl https://bashupload.com/ -T ${FILENAME}
# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
# Temporarily disable Wetransfer which is not working
# transfer wet $FILENAME > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

# Mirror to oshi.at
# curl -T $FILENAME https://oshi.at/${FILENAME}/${TIMEOUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

# Mirror to dev upload 
bash <(curl -s https://devuploads.com/upload.sh) -f $FILENAME -k 4725wcbxsfl3cp6fa2p1 > mirror.txt ||  { echo "WARNING: Failed to Mirror the Build!" }
DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

DATE_L=$(date +%d\ %B\ %Y)
DATE_S=$(date +"%T")

# Send the Message on Telegram
echo -e \
"
🛠️ CI|TWRP Recovery

Build Completed Successfully!

📱 Device: "${DEVICE}"
🖥 Build System: "${TWRP_BRANCH}"
⬇️ Download Link: <a href=\"${DL_LINK}\">Here</a>
⬇️ Mirror Link: <a href=\"${MIRROR_LINK}\">Here</a>
📅 Date: "$(date +%d\ %B\ %Y)"
⏱ Time: "$(date +%T)"
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "$TG_TEXT"

echo " "

# Exit
exit 0
