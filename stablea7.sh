echo installing brew
sudo apt-get update --fix-missing
sudo apt-get install git libcurl4 libzip-dev libplist-dev libimobiledevice openssl libssl-dev libpng-dev
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install autoconf automake bsdiff libimobiledevice libzip libtool libzip lsusb openssl pkg-config wget
brew link libtool
echo "==> Downloading libirecovery..."
git clone https://github.com/libimobiledevice/libirecovery.git
echo "==> Making libirecovery..."
cd libirecovery
./autogen.sh && make
echo "==> Installing libirecovery. This might ask for your password..."
sudo make install
cd ..
rm -rf libirecovery
echo "==> Downloading libfragmentzip..."
git clone https://github.com/tihmstar/libfragmentzip.git
echo "==> Making libfragmentzip..."
cd libfragmentzip
mkdir m4
./autogen.sh && make
echo "==> Installing libfragmentzip. This might ask for your password..."
sudo make install
cd ..
rm -rf libfragmentzip
mkdir StableA7
cd StableA7
echo "==> Downloading binaries..."
echo "==> Downloading patches..."
wget -O patch.zip https://gitlab.com/devluke/stablea7/-/archive/master/stablea7-master.zip?path=patch -q --show-progress
unzip -q patch.zip
cp -r stablea7-master-patch/patch .
rm -r stablea7-master-patch patch.zip
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



