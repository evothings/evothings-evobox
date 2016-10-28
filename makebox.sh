# Call like: ./makebox.sh xenial32 "box-cutter\/ubuntu1604-i386"
BOOTSTRAP=$1
BASEBOX=$2
echo $BASEBOX

ANDROID_SDK_FILENAME=android-sdk_r24.4.1-linux.tgz
ANDROID_SDK=http://dl.google.com/android/$ANDROID_SDK_FILENAME

# Download if not there
if [ ! -f $ANDROID_SDK_FILENAME ]; then
  curl -O $ANDROID_SDK
fi

# Clean older stuff
rm -rf android-sdk-linux

# Make sure we use the right bootstrap and the right basebox
cp $BOOTSTRAP.sh bootstrap.sh
cp Vagrantfile.ori Vagrantfile
sed -i "s/BASEBOX-PLACEHOLDER/${BASEBOX}/" Vagrantfile

# Bring it up
vagrant destroy -f
vagrant up

# Package
vagrant package --output evobox.box

# Destroy
vagrant destroy -f