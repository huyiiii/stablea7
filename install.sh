echo "LIBCURL4 MUST BE INSTALLED NOT LIBCURL3"
sleep 10
sudo apt-get update --fix-missing
sudo apt-get install git ruby-curb libcurl4-openssl-dev libssl1.1 libzip-dev libplist-dev openssl libusb-1.0 libssl-dev python-dev libusb-dev libpng-dev libusbmuxd-dev libplist++ libreadline5-dev bsdiff
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install autoconf automake libimobiledevice libzip libtool libzip lsusb openssl pkg-config wget
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
git clone https://github.com/libimobiledevice/libimobiledevice
cd igetnonce
./autogen.sh
make
sudo make install
git clone https://github.com/tihmstar/igetnonce
./autogen.sh
make
sudo make install
wget -O tsschecker.zip http://api.tihmstar.net/builds/tsschecker/tsschecker-latest.zip -q --show-progress
unzip tsschecker.zip
sudo mv tsschecker_linux StableA7
wget -O futurerestore.zip http://api.tihmstar.net/builds/futurerestore/futurerestore-latest.zip -q --show-progress
unzip futurerestore.zip
sudo mv futurerestore_linux StableA7
echo "==> Downloading patches..."
wget -O patch.zip https://gitlab.com/devluke/stablea7/-/archive/master/stablea7-master.zip?path=patch -q --show-progress
unzip -q patch.zip
cp -r stablea7-master-patch/patch .
rm -r stablea7-master-patch patch.zip


