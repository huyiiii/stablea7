echo "libcurl3 must be installed not libcurl4"
echo "==> Which futurerestore patch would you like to use?"
echo "==> If you are unsure, choose option 1. This is only present in this beta version."
echo
echo "=> (1) Normal/Auto"
echo "=>   - Attempts to perform a restore without custom dylibs"
echo "=>   - Inconsistent, sometimes works and sometimes doesn't"
echo "=>   - Works on Linux"
echo "=> tested on Parrot OS - fresh "
echo "=>   - Doesn't require root"
echo "=>   - Switches to rsu patch if it fails"
echo
echo "=> (2) /rsu"
echo "=>   - Makes futurerestore look for custom dylibs in /rsu instead of /usr"
echo "=>   - Only works on macOS High Sierra and Mojave"
echo "=>   - Works on macOS Catalina with SIP disabled and / remounted as rw"
echo "=>   - Requires root"
echo "=>  AUTO Selecting (1)"
read -p "put device in dfu mode and press enter"
igetnonce
read -p "copy and paste device identifier e.g(iPhone6,2 iPad4,4): " identifier
read -p "copy and paste ecid: " ecid
read -p "copy and paste ApNonce: " apnonce
read -p "copy and paste SepNonce: " sepnonce
if [ $identifier == iPhone6,1 ] || [ $identifier == iPhone6,2 ]; then
	model=iphone6
	echo "==> Your iPhone 5S is supported!"
elif [ $identifier == iPad4,1 ] || [ $identifier == iPad4,2 ]; then
	model=ipad4
	echo "==> Your iPad Air is supported!"
elif [ $identifier == iPad4,4 ] || [ $identifier == iPad4,5 ]; then
	model=ipad4b
	echo "==> Your iPad Mini 2 is supported!"
fi
wget -O restore.ipsw https://api.ipsw.me/v4/ipsw/download/$identifier/14G60 -q --show-progress
unzip -q -d ipsw restore.ipsw
echo "==> Copying iBEC/iBSS..."
cp ipsw/Firmware/dfu/iBEC.$model.RELEASE.im4p ibec.im4p
cp ipsw/Firmware/dfu/iBSS.$model.RELEASE.im4p ibss.im4p
echo "==> Patching iBEC/iBSS..."
bspatch ibec.im4p ibec.patched.im4p patch/ibec_$model.patch
bspatch ibss.im4p ibss.patched.im4p patch/ibss_$model.patch
echo "==> Copying patched iBEC/iBSS to IPSW..."
rm ipsw/Firmware/dfu/iBEC.$model.RELEASE.im4p
rm ipsw/Firmware/dfu/iBSS.$model.RELEASE.im4p
cp ibec.patched.im4p ipsw/Firmware/dfu/iBEC.$model.RELEASE.im4p
cp ibss.patched.im4p ipsw/Firmware/dfu/iBSS.$model.RELEASE.im4p
echo "==> Creating custom IPSW..."
cd ipsw
zip -q ../custom.ipsw -r0 *
cd ..
echo "==> Cleaning up..."
rm -r ibec.im4p ibss.im4p patch restore.ipsw
echo "==> Downloading ipwndfu..."
wget -O ipwndfu.zip https://github.com/MatthewPierson/ipwndfu_public/archive/master.zip -q --show-progress
unzip -q ipwndfu.zip
rm ipwndfu.zip
mv ipwndfu_public-master ipwndfu
read -p "please put device in pwnd dfu mode and press enter"
cd ipwndfu
python rmsigchks.py 
cd ..
echo "==> Sending test file to device..."
echo "==> Sending patched iBSS/iBEC to device..."
irecovery -f ibss.patched.im4p
irecovery -f ibec.patched.im4p
read -p "put device in dfu mode and press enter"
igetnonce
read -p "copy and paste device identifier e.g(iPhone6,2 iPad4,4)" identifier
read -p "copy and paste ecid" ecid
read -p "copy and paste ApNonce" apnonce
read -p "copy and paste SepNonce" sepnonce
if [ $identifier == iPhone6,1 ] || [ $identifier == iPhone6,2 ] || [ $identifier == iPad4,2 ] || [ $identifier == iPad4,5 ]; then
	echo "==> Copying baseband..."
	cp ipsw/Firmware/Mav7Mav8-7.60.00.Release.bbfw baseband.bbfw
fi
echo "==> Copying SEP..."
if [ $identifier == iPad4,1 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j71.RELEASE.im4p sep.im4p
elif [ $identifier == iPad4,2 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j72.RELEASE.im4p sep.im4p
elif [ $identifier == iPad4,4 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j85.RELEASE.im4p sep.im4p
elif [ $identifier == iPad4,5 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.j86.RELEASE.im4p sep.im4p
elif [ $identifier == iPhone6,1 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.n51.RELEASE.im4p sep.im4p
elif [ $identifier == iPhone6,2 ]; then
	cp ipsw/Firmware/all_flash/sep-firmware.n53.RELEASE.im4p sep.im4p
fi
echo "==> Requesting ticket..."
./StableA7/tsschecker_linux -e $ecid -d $identifier -s -o -i 9.9.10.3.3 --buildid 14G60 -m BuildManifest.plist --apnonce $apnonce 
mv *.shsh ota.shsh
./StableA7/futurerestore_linux -t ota.shsh -s sep.im4p -m BuildManifest.plist -b baseband.bbfw -p BuildManifest.plist custom.ipsw


