# This file hosts some non-crucial defaults used by gears based on a workspace type
# see also ~/etc/environment

source ~/.git-completion.sh
source ~/.git-prompt.sh

npm completion > ~/.npm-completion.sh
source ~/.npm-completion.sh

PROMPT_COMMAND='echo -ne "\033]0;${C9_USER}@${C9_PROJECT}: ${PWD/#$HOME/~}\007"'
PS1='\[\033[01;32m\]${C9_USER}@${C9_PROJECT}\[\033[00m\]:\[\033[01;34m\]${PWD/#$HOME/~}\[\033[00m\]$(__git_ps1 " (%s)") $ '

alias ls='ls --color=auto -F'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

echo -ne "            \e[48;5;233m             \e[00m\n"
echo -ne "Welcome to \e[48;5;234m  \e[38;5;33mCloud\e[38;5;15m9 \e[38;5;33mIDE  \e[00m\n"
echo -ne "            \e[48;5;234m             \e[00m\n"
