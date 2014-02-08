# ~/.bash_profile: executed by bash(1) for login shells.

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
   . ~/.bashrc
fi

PROMPT_COLOR='0;32m'
# If I am root, set the prompt to bright red
if [ ${UID} -eq 0 ]; then
PROMPT_COLOR='1;31m'
fi

umask 002
export PS1='\[\e]0;VagrantVM ${HOSTNAME}:${PWD}\a\]\n\[\e[${PROMPT_COLOR}\]\u@\h \[\e[33m\]${PWD}\[\e[0m\]\n\$'

