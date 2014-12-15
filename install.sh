#!/bin/bash

TMP_DIR="/tmp/stefanwallin-dotfiles"
GIT_URL="https://github.com/StefanWallin/dotfiles.git"
BASH_CONFIG=".bashrc"
 
# Test if we have git
if [ ! `which git|grep git` ]; then
        echo "You don't have git installed, fix that please before you go any further."
        exit 1
fi
 
# OS specific stuff
case $(uname) in
    Darwin)
        INSTALL_DIR="/Users/${USER}"
    ;;
    *)
        INSTALL_DIR="${HOME}"
esac

echo "Showing diff of files to be installed:"
diff -u -w ${TMP_DIR}/vimrc ${INSTALL_DIR}/.vimrc
diff -u -w ${TMP_DIR}/bashrc ${INSTALL_DIR}/${BASH_CONFIG}
diff -u -w ${TMP_DIR}/bash_logout ${INSTALL_DIR}/.bash_logout
diff -u -w ${TMP_DIR}/gitconfig ${INSTALL_DIR}/.gitconfig
diff -u -w ${TMP_DIR}/.git-completion.sh ${INSTALL_DIR}/.git-completion.sh
diff -u -w ${TMP_DIR}/.git-prompt.sh ${INSTALL_DIR}/.git-prompt.sh
echo

# Are you sure?

read -p "This may overwrite existing files in ${INSTALL_DIR}. Are you sure? (y/n) " -n 1
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
fi

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

install -b -m 644 ${TMP_DIR}/vimrc ${INSTALL_DIR}/.vimrc
install -b -m 644 ${TMP_DIR}/bashrc ${INSTALL_DIR}/${BASH_CONFIG}
install -b -m 644 ${TMP_DIR}/bash_logout ${INSTALL_DIR}/.bash_logout
install -b -m 644 ${TMP_DIR}/gitconfig ${INSTALL_DIR}/.gitconfig
install -b -m 644 ${TMP_DIR}/.git-completion.sh ${INSTALL_DIR}/.git-completion.sh
install -b -m 644 ${TMP_DIR}/.git-prompt.sh ${INSTALL_DIR}/.git-prompt.sh

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
