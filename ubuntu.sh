#!/bin/bash
#
#   Author: Iassam
#
#------------------[Preload]---------------------

APP_VERSION='1.8'

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
    apt-get dist-upgrade -y
}

basicDevelop(){

	updateSystem

    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    apt-get install ubuntu-restricted-extras build-essential vlc ssh curl dkms p7zip rar unrar wget xsane tree ttf-mscorefonts-installer guvcview gparted qbittorrent git umbrello keepassx npm htop net-tools virtualbox virtualbox-guest-x11 zsh fonts-powerline -y
    echo "Basic development packages installed."
}

appEditors(){

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

androidStudio(){

    apt-get install lib32z1 lib32stdc++6 adb -y
    snap install android-studio --classic

}

flutterDev(){
    snap install flutter --classic
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

vsCodePackage(){
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
    dpkg -i vscode.deb
    rm vscode.deb
    echo "Visual Studio Code installed.";
}

chromeInstall(){

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    dpkg -i chrome.deb
    rm chrome.deb
    apt-get install -f -y
    echo "Google Chrome Browser installed.";
}

nodejsPackage(){


    #install nvm
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


    #install nodejs
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    echo "NodeJs installed."
}

allPackages(){

    apt-get install composer -y
    updateSystem
    basicDevelop
    nodejsPackage
    aErrors
    aGuest
    vimConfig
    chromeInstall
    atomInstall
    vsCodePackage
    androidStudio

    echo "All packages installed."

}

mobileDev(){
  androidStudio
  flutterDev
}

databaseManagers(){
  wget -O https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
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
    ${YELLOW}Ubuntu Developer Installer v${APP_VERSION} ${NORMAL}

    ${GREEN}1)${NORMAL} Install Basic Dev Programs
    ${GREEN}2) ${NORMAL}Vim + custom config
    ${GREEN}3) ${NORMAL}Disable ubuntu errors
    ${GREEN}4) ${NORMAL}Disable guest user
    ${GREEN}5) ${NORMAL}Install Atom editor
    ${GREEN}6) ${NORMAL}Install Google chrome latest version
    ${GREEN}9) ${NORMAL}Install LAMP server
    ${GREEN}7) ${NORMAL}Install NodeJS dev pack
    ${GREEN}8) ${NORMAL}Install Visual Studio Code
    ${GREEN}9) ${NORMAL}Install Mobile dev package
    ${GREEN}98) ${NORMAL}Install all packages
    ${RED}99) ${NORMAL}Exit
    "
}

options(){

    clear

    case "$1" in
        1) basicDevelop; sleep 3;;
        2) setUser; vimConfig; sleep 3;;
        3) aErrors; sleep 3;;
        4) aGuest; sleep 3;;
        5) atomInstall; sleep 3;;
        6) chromeInstall; sleep 3;;
        7) nodejsPackage; sleep 3;;
        8) vsCodePackage; sleep 3;;
        9) mobileDev; sleep 3;;
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
