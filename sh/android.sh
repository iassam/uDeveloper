#!/bin/bash

wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz

tar -xvf android-sdk_r24.4.1-linux.tgz

rm android-sdk_r24.4.1-linux.tgz

mv android-sdk-linux ~/android

export PATH=${PATH}:~/android/tools

echo 'export PATH="$PATH:$HOME/android/tools"' >> ~/.bashrc


