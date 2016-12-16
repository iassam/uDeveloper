#!/bin/bash
#
#
#   Author: Iassam
#
#

#Libs
. config

atualizar(){

    apt-get update
    apt-get upgrade -y
}

oracleJava(){

    closeAllBrowsers
    add-apt-repository ppa:webupd8team/java -y
    apt-get update

    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
    apt-get install oracle-java8-installer -y

}

pInstalar(){

    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

    apt-get install ubuntu-restricted-extras build-essential vlc ssh curl dkms p7zip rar unrar wget xsane tree ttf-mscorefonts-installer guvcview gparted qbittorrent -y

}

appDevelopment(){

   apt-get install vim git npm nodejs nodejs-legacy composer -y
}

#Linux Apache Mysql PHP
LAMP(){

    sh ./sh/lamp.sh
}

#Desable errors msg ubuntu
aErros(){

    echo "enabled=0" > /etc/default/apport
}

#Disable guest session ubuntu
aGuest(){

    echo "allow-guest=false" >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
}

#Close chrome and firefox
closeAllBrowsers(){

    killall firefox
    killall chrome
}

android(){

	apt-get install ant adb -y
	npm install -g cordova ionic
	su $1 -c sh ./sh/android.sh
}

#------------------------[Main process]-----------------------------

atualizar
pInstalar
oracleJava
appDevelopment
aErros
aGuest
LAMP $HOST $MYSQL_PASSWD
android $USER
