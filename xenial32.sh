#!/usr/bin/env bash

# The SDK we use right now
ANDROID_SDK_FILENAME=android-sdk_r24.4.1-linux.tgz

# Get ourselves up to date
sudo apt-get update
sudo apt-get upgrade -y

# To get apt-add-repository 
sudo apt-get install software-properties-common python-software-properties

# Cordova's PPA
sudo apt-add-repository ppa:cordova-ubuntu/ppa

# Install prereq tools
sudo apt-get install -y git openjdk-8-jdk ant expect ruby nodejs npm nodejs-legacy > /dev/null 2>&1

# Used by build.rb to verify icon sizes etc
sudo gem install fastimage

# Unpack Android SDK 
tar -xzvf /vagrant/$ANDROID_SDK_FILENAME > /dev/null 2>&1
sudo chown -R vagrant android-sdk-linux/ > /dev/null 2>&1

# Fix vars and PATH
echo "export ANDROID_HOME=~/android-sdk-linux" >> /home/vagrant/.profile
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-i386" >> /home/vagrant/.profile
echo "PATH=\$PATH:~/android-sdk-linux/tools:~/android-sdk-linux/platform-tools" >> /home/vagrant/.profile

# We could perhaps install cordova using apt
# sudo apt-get install cordova-cli

# ...but we use npm instead
sudo npm install -g cordova@6.3.1 #ionic gulp bower

# Clean a bit
sudo apt-get autoremove

# Configure SDK platforms
expect -c '
set timeout -1   ;
spawn /home/vagrant/android-sdk-linux/tools/android update sdk -u --all --filter platform-tool,tool,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository,android-22,android-23,android-24,build-tools-22.0.1
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
'
