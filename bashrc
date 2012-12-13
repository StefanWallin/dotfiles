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
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
EDITOR="vim"


# Functions #
#############
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Get current git branch if any
function current_branch {
    BRANCH=$(git branch 2> /dev/null | sed -n 's/^* \(.*\)/\1/p')
    if [ ! -z "${BRANCH}" ]; then
        echo "${BRANCH} "
    fi
}

# Bash aliases #
################
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color --exclude="*.pyc"'
alias autotest='watchr test/test.watchr'
alias subl='open -a "Sublime Text 2"'
alias monteraFig="mkdir /Volumes/fig; mount_sshfs festiz.com:/home/festiz/web/ /Volumes/fig/"

# Git aliases #
###############
alias gs="git status --ignore-submodules -sb"
alias gd="git diff --ignore-submodules --color"
alias ga='git add'
alias gp='git push origin $(current_branch)'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue) <%an>%Creset' --abbrev-commit --color"


# Git prompt #
##############
source ~/.git-completion.sh
source ~/.git-prompt.sh

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

# Export shit into the shell #
##############################
export PS1 PATH EDITOR GREP_OPTIONS GIT_PS1_SHOWDIRTYSTATE

