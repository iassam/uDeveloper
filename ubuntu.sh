#!/bin/bash
#
#   Author: Iassam
#
#   Version: 1.4

#------------------[Preload]---------------------
#System colors
NORMAL='\e[0m'
BLUE='\e[34m'
YELLOW='\e[93m'
GREEN='\e[92m'
RED='\e[31m'

#System vars
HOST=""
MYSQL_PASSWD=""
USER_SYS=""
#------------------------------------------------

setUser(){

    if [ "$USER_SYS" = "" ]; then

        while [ "$USER_SYS" = "" ]
        do
            echo "Please set user "
            read -p "User name: " USER_SYS
        done

    fi

}

setMysql(){

    if [ "$MYSQL_PASSWD" = "" ]; then

        echo "Please set your mysql passsword "
        read -p "Mysql password (password123): " MYSQL_PASSWD

        if [ "$MYSQL_PASSWD" = "" ]; then

            MYSQL_PASSWD="password123"
        fi

    fi
}

setHost(){

    if [ "$HOST" = "" ]; then

        echo "Please set HOST "
        read -p "Host (localhost): " HOST

        if [ "$HOST" = "" ]; then

            HOST="localhost"
        fi
    fi
}

updateSystem(){

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
    echo "Oracle java installed."
}

basicDevelop(){

    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    apt-get install ubuntu-restricted-extras build-essential vlc ssh curl dkms p7zip rar unrar wget xsane tree ttf-mscorefonts-installer guvcview gparted qbittorrent git -y
    echo "Basic development packages installed."
}


LAMP(){

    #Debconf mysql
    debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWD"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"

    #Debconf phpmyadmin
    debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_PASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_PASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_PASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

    apt-get install apache2 mysql-server mysql-workbench phpmyadmin php libapache2-mod-php php-mcrypt php-mysql php-gd php-gettext php-zip php-mbstring phpunit php-gettext composer -y

    echo "Servername $HOST" >> /etc/apache2/apache2.conf

    service apache2 restart

    a2enmod rewrite

    a2enmod headers

    echo -e "\n--- Allow url rewrite ---\n"
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

    #rm -rf /var/www/html
    #ln -fs ~/public /var/www/html

    echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

    echo -e "\n--- Install bower ---\n"
    npm install -g gulp bower
    service apache2 restart

    echo "LAMP installed."
}

appEditores(){

    apt-get install sigil gimp calibre -y
}

#Desable errors msg ubuntu
aErrors(){

    echo "enabled=0" > /etc/default/apport
    echo "Ubuntu error aport disabled."
}

#Disable guest session ubuntu
aGuest(){

    echo "allow-guest=false" >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
    echo "Ubuntu guest user disabled."
}

#Close chrome and firefox
closeAllBrowsers(){

    killall firefox
    killall chrome
}

laravelInstall(){

    su - $USER_SYS -c '
    composer global require "laravel/installer";
	export PATH=${PATH}:~/.composer/vendor/bin;
	echo "export PATH=$PATH" >> ~/.bashrc;
    echo "Laravel installed."'
    
}

android(){

    apt-get install ant adb android-sdk -y
    echo "Android SDK installed.";
    sudo npm install -g cordova ionic

}

androidStudio(){

     apt-get install lib32z1 lib32ncurses5 lib32stdc++6 -y

     su - $USER_SYS -c '
     wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -O android-sdk.tgz;
     tar -xvf android-sdk.tgz;
     rm android-sdk.tgz;
     mv android-sdk-linux ~/android;
     export PATH=${PATH}:~/android/tools;
     echo "export PATH=$PATH" >> ~/.bashrc;
     echo "Android Studio installed.";
 
     '

}

vimConfig(){

    apt-get install vim -y

    su - $USER_SYS -c '
    if [ -f "~/.vimrc" ]
    then
        echo ".vimrc file exists"
    else
        echo "
        \"Line numbers
        set number

        \" Sets how many lines of history VIM has to remember
        set history=700

        \" Enable filetype plugins
        filetype plugin on
        filetype indent on

        \" Set to auto read when a file is changed from the outside
        set autoread

        \" Turn on the WiLd menu
        set wildmenu

        \"Always show current position
        set ruler

        \" Ignore case when searching
        set ignorecase

        \" When searching try to be smart about cases
        set smartcase

        \" Highlight search results
        set hlsearch

        \" For regular expressions turn magic on
        set magic

        \" Show matching brackets when text indicator is over them
        set showmatch

        \" How many tenths of a second to blink when matching brackets
        set mat=2

        \" Enable syntax highlighting
        syntax enable

        colorscheme desert
        set background=dark

        \" Set utf8 as standard encoding and en_US as the standard language
        set encoding=utf8

        " > ~/.vimrc

        echo "Vim + custom config installed.";
    fi'

}

atomInstall(){

    wget https://atom.io/download/deb -O atom.deb
    dpkg -i atom.deb
    rm atom.deb
    echo "Atom editor installed.";
}

chromeInstall(){

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    dpkg -i chrome.deb
    rm chrome.deb
    apt-get install -f -y
    echo "Google Chrome Browser installed.";
}

nodejsInstall(){

    apt-get install npm nodejs nodejs-legacy -y
    echo "nodejs installed."
}

nodejsLatest(){

    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    apt-get install nodejs -y
    apt-get autoremove -y
    echo "latest nodejs version installed."
}

allPackages(){

    apt-get install composer -y
    updateSystem
    basicDevelop
    oracleJava
    nodejsLatest
    aErrors
    aGuest
    LAMP
    vimConfig
    laravelInstall
    chromeInstall
    android
    atomInstall

    echo "All packages installed."

}

rootVerify(){

    if [ $USER != "root" ]; then
        echo "Please run as ROOT!, "$USER"..."
        exit
    fi
}

menu(){

    clear

    echo -e "
    ${YELLOW}Ubuntu Developer Installer v1.4${NORMAL}

    ${GREEN}1)${NORMAL} Install Basic Programs
    ${GREEN}2) ${NORMAL}Install Oracle java 8
    ${GREEN}3) ${NORMAL}Install android SDK
    ${GREEN}4) ${NORMAL}Vim + custom config
    ${GREEN}5) ${NORMAL}Disable ubuntu errors
    ${GREEN}6) ${NORMAL}Disable guest user
    ${GREEN}7) ${NORMAL}Install Atom editor
    ${GREEN}8) ${NORMAL}Install Google chrome latest version
    ${GREEN}9) ${NORMAL}Install LAMP server
    ${GREEN}10) ${NORMAL}Install NodeJS (stable)
    ${GREEN}11) ${NORMAL}Install NodeJS (latest)
    ${GREEN}97) ${NORMAL}Install Laravel
    ${GREEN}98) ${NORMAL}Install all packages
    ${RED}99) ${NORMAL}Exit
    "
}

options(){

    clear

    case "$1" in
        1) basicDevelop; sleep 3;;
        2) oracleJava; sleep 3;;
        3) setUser; android; sleep 3;;
        4) setUser; vimConfig; sleep 3;;
        5) aErrors; sleep 3;;
        6) aGuest; sleep 3;;
        7) atomInstall; sleep 3;;
        8) chromeInstall; sleep 3;;
        9) setHost; setMysql; LAMP ; sleep 3;;
        10) nodejsInstall; sleep 3;;
        11) nodejsLatest; sleep 3;;
        97) setUser; laravelInstall; sleep 3;;
        98) setUser; setHost; setMysql; allPackages; sleep 3;;
        99) echo "Hasta la vista baby..."; exit;;
        *) echo "Invalid option"; sleep 1;;
    esac
}


#------------------------[Main process]-----------------------------
rootVerify

while :
do

    menu
    read -p "Option: " OPTION
    options $OPTION

done
#-------------------------------------------------------------------
