#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

stty -ixon #disabling XON/XOFF bind for ctrl-s (forward search)

[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(in ranger) ' #"(in ranger) " will be displayed next to
#your prompt to notify you that the shell spawned from ranger.

# Aliases
alias vim='nvim'
alias vi='nvim'

alias dir='ls -Alh --color=auto --file-type'
alias suspend='systemctl suspend; i3lock -c 000000'
alias kindle='sudo mount -o uid=1000,gid=1000,fmask=177,dmask=077 -U 0000-000B /mnt/usbstick'
alias virtualbox='if ( lsmod | grep -q vbox ) ; then ( virtualbox > /dev/null 2>&1 & ); else (sudo modprobe vboxdrv && virtualbox > /dev/null 2>&1 ); fi'
alias disown='bg && disown'
alias cal='cal --color=always -m'
alias reboot='history -a && reboot'

eval $(dircolors ~/.dotfiles/bash/dircolors.256dark)

function svim() {
  vim sudo:"$@"
}

function cd() {
  builtin cd "$@" && ls -Alh --color=auto --file-type;
}

function ytb() {
  youtube-dl -o - "$1" | mpv -
}

rg() {
    if [ -z "$RANGER_LEVEL" ]
    then
        ranger
    else
        exit
    fi
}

# \e[0;30m - Black foregroung
# \e[46m - Cyan background
# \e[0m - Text reset
# \u - current user
# \h - hostname short
# \w - working dir
# \$ - $ or # depends on user
# \[non-printing charachters here(colors)\]

PS1="\[\e[0;30m\e[46m\]\u@\h:\w\$\[\e[0m\] "

shopt -s autocd
shopt -s histappend
shopt -s histverify
export HISTCONTROL=ignoreboth:ignorespace:ignoredups:erasedups
export EDITOR=nvim # ctrl-X-E editor for long commands
HISTSIZE=10000

bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'
# FZF sourcing
# Auto-completion
source "/usr/share/fzf/completion.bash" 2> /dev/null
# Key bindings
source "/usr/share/fzf/key-bindings.bash"

source /usr/share/nvm/init-nvm.sh
export FZF_DEFAULT_COMMAND='rg --files'
