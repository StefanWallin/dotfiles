#.bashrc

# Source global definitions #
#############################
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Colors #
##########
esc="\033"
clear="\[$esc[0;00m\]"
white="\[$esc[0;01m\]"
black="\[$esc[0;30m\]"

red1="\[$esc[0;31m\]"
red2="\[$esc[1;31m\]"
green1="\[$esc[0;32m\]"
green2="\[$esc[1;32m\]"
yellow1="\[$esc[0;33m\]"
yellow2="\[$esc[1;33m\]"
blue1="\[$esc[0;34m\]"
blue2="\[$esc[1;34m\]"
purple1="\[$esc[0;35m\]"
purple2="\[$esc[1;35m\]"
grey1="\[$esc[0;36m\]"
grey2="\[$esc[1;36m\]"
grey3="\[$esc[0;37m\]"
grey4="\[$esc[1;37m\]"

# Other variables #
###################
GREP_OPTIONS="--color=auto"
PATH=$PATH:$HOME/bin
PATH="/usr/local/bin:~/bin:$PATH"
PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export NVM_DIR="/Users/festiz/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
EDITOR="vim"




# Functions #
#############
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

function current_branch {
    # Get current git branch if any
    BRANCH=$(git branch 2> /dev/null | sed -n 's/^* \(.*\)/\1/p')
    if [ ! -z "${BRANCH}" ]; then
        echo "${BRANCH} "
    fi
}
function mvn(){
    # Get alerted when maven is done.
    `which mvn` $@; date; say "Oyy. Maven is done."
}
function m(){
    # Get a cleaner make output
    clean; /usr/bin/make --silent $@; date
}
function bdif(){
    # Improved diff for bazaar.
    bzr diff $1|colordiff
}
function mate(){
    # remote version of the Textmate helper app "mate" for my server
    ruby -e "a = ARGV.length == 0 ? ' ' : ARGV[0]; p = (a[0] == 47 ? a : Dir.pwd + '/' + a); s = File.expand_path(p); puts p.gsub( /\/home\/stefan/, '/Volumes/fig') if p.match( /\/home\/stefan/);" $@
}


# Bash aliases #
################
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vmake="/usr/bin/make"
alias make="m"
alias grep='grep --color --exclude="*.pyc"'
alias autotest='watchr test/test.watchr'
alias subl='open -a "Sublime Text 2"'
alias monteraFig="mkdir /Volumes/fig; mount_sshfs festiz.com:/home/festiz/web/ /Volumes/fig/"
alias hbzr="BZR_REMOTE_PATH='bzr --no-plugins' bzr" # Hardened bazaar for dealing with broken pipes.
alias server="python -m SimpleHTTPServer"

# Git aliases #
###############
alias gs="git status --ignore-submodules -sb"
alias gc="gs|grep UU"
alias gcm="git commit -m"
alias gpf="git pull --ff-only"
alias gd="git diff --ignore-submodules --color"
alias gdc="gd --cached"
alias ga='git add'
alias gaa='git add .'
alias gp='git push origin $(current_branch)'
alias gap='git add -p .'
alias pick='git cherry-pick'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue) <%an>%Creset' --abbrev-commit --color"
alias renamehelp="echo 'for i in *.JPG; do mv \$i ar_\$i; done'; echo 'for i in *.JPG; do mv \$i \${i%%.JPG}.jpg; done'"
alias tunnelhelp='echo "ssh -L port:localhost:port sshhost -Nf"'

# Use hub helper for github if available.
if [ -f `which hub` ]; then
	alias git="hub"
fi

# Git prompt #
##############
source ~/.git-completion.sh
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE="1"

if type -p printf > /dev/null 2>&1; then
        red=$(printf '\e[31m')
        PS1='\[\033[01;36m\]\u@\h:\[\033[00;34m\]\w\[\033[32m\]$(__git_ps1 " (%s)")\[\033[0m\]$([ $? -eq 0 ]||$red) \$ '
else
        PS1='\[\033[01;36m\]\u@\h:\[\033[00;34m\]\w\[\033[32m\]$(__git_ps1 " (%s)")\[\033[0m\] \$ '
fi

# OS specific #
###############
case $(uname) in
    Darwin)
        export CLICOLOR=1
    ;;
    Linux)
        eval "`dircolors`"
        export LS_OPTIONS='--color=auto'
    ;;
    *)
esac

# Bash Settings #
#################
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# This purpose of this line is to allow ctrl+s and similar shorthands to pass through to the applications inside the terminal:
# http://stackoverflow.com/questions/24623021/getting-stty-standard-input-inappropriate-ioctl-for-device-when-using-scp-thro
[[ $- == *i* ]] && stty -ixon

# Export shit into the shell #
##############################
export PS1 PATH EDITOR GREP_OPTIONS GIT_PS1_SHOWDIRTYSTATE

# ndenv path magic
export PATH="$HOME/.ndenv/bin:$PATH"
eval "$(ndenv init -)"
