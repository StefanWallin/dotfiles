#!/bin/bash

TMP_DIR="/tmp/stefanwallin-dotfiles"
GIT_URL="https://github.com/StefanWallin/dotfiles.git"
BASH_CONFIG=".bashrc"
 
# Colors #
##########
esc='\033'
normal='$esc[0;00m'
white='$esc[0;01m'
black='$esc[0;30m'

red1='$esc[0;31m'
red2='$esc[1;31m'
green1='$esc[0;32m'
green2='$esc[1;32m'
yellow1='$esc[0;33m'
yellow2='$esc[1;33m'
blue1='$esc[0;34m'
blue2='$esc[1;34m'
purple1='$esc[0;35m'
purple2='$esc[1;35m'
grey1='$esc[0;36m'
grey2='$esc[1;36m'
grey3='$esc[0;37m'
grey4='$esc[1;37m'

function check_software(){
	if [ `which $1` ]; then
		status="[${green1}installed${normal}]"
	else
		status="[${red1}unavailable${normal}]"
	fi
	app="${blue1}${1}${normal}"
	printf "%-30b %b\n" $app ${status}
}

# Test if we have git
if [ ! `which git|grep git` ]; then
        echo "You don't have git installed, fix that please before you go any further."
        exit 1
fi
 
# OS specific stuff
case $(uname) in
    Darwin)
        INSTALL_DIR="/Users/${USER}"
	echo "Checking installed software:"
	for software in nvm node npm rvm brew wget git hub bower; do
		check_software $software
	done
	echo -en "\n"
	defaults write -g ApplePressAndHoldEnabled -bool false
    ;;
    *)
        INSTALL_DIR="${HOME}"
esac




# Get latest files
if [ -d "${TMP_DIR}" ]; then
    pushd ${TMP_DIR}
        git pull
        git submodule init
        git submodule update
    popd
else
    git clone ${GIT_URL} ${TMP_DIR}
    pushd ${TMP_DIR}
        git submodule init
        git submodule update
    popd
fi

echo "Showing diff of files to be installed:"
diff -u -w ${INSTALL_DIR}/.vimrc ${TMP_DIR}/vimrc
diff -u -w ${INSTALL_DIR}/${BASH_CONFIG} ${TMP_DIR}/bashrc
diff -u -w ${INSTALL_DIR}/.bash_logout ${TMP_DIR}/bash_logout
diff -u -w ${INSTALL_DIR}/.gitconfig ${TMP_DIR}/gitconfig
diff -u -w ${INSTALL_DIR}/.git-completion.sh ${TMP_DIR}/git-completion.sh
diff -u -w ${INSTALL_DIR}/.git-prompt.sh ${TMP_DIR}/git-prompt.sh
echo

# Are you sure?

read -p "This may overwrite existing files in ${INSTALL_DIR}. Are you sure? (y/n) " -n 1
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
fi

install -b -m 644 ${TMP_DIR}/vimrc ${INSTALL_DIR}/.vimrc
install -b -m 644 ${TMP_DIR}/bashrc ${INSTALL_DIR}/${BASH_CONFIG}
install -b -m 644 ${TMP_DIR}/bash_logout ${INSTALL_DIR}/.bash_logout
install -b -m 644 ${TMP_DIR}/gitconfig ${INSTALL_DIR}/.gitconfig
install -b -m 644 ${TMP_DIR}/git-completion.sh ${INSTALL_DIR}/.git-completion.sh
install -b -m 644 ${TMP_DIR}/git-prompt.sh ${INSTALL_DIR}/.git-prompt.sh

# Install vim plugins
## Pathogen.vim
mkdir -p ${INSTALL_DIR}/.vim/autoload ${INSTALL_DIR}/.vim/bundle
curl -LSso ${INSTALL_DIR}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

## NERD_tree.vim
if [ -d "${INSTALL_DIR}/.vim/bundle/nerdtree" ]; then
	cd ${INSTALL_DIR}/.vim/bundle/nerdtree && git pull
else
	cd ${INSTALL_DIR}/.vim/bundle/ && git clone https://github.com/scrooloose/nerdtree.git
fi


#Load the settings
read -p "Do you want to load your newly installed settings? (y/n) " -n 1
echo
if [[  $REPLY =~ ^[Yy]$ ]]; then
    echo "Loading."
    source ${INSTALL_DIR}/${BASH_CONFIG}
fi
