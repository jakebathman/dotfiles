# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin
export PATH

#-----------------------------------------------------
# Aliases
#----------------------------------------------------

alias vbash=_vimbash
_vimbash() {
  vim ~/dotfiles/bashrc;
}

alias redis=redis-cli

alias beanstats='echo -e $BGreen"echo -e \"stats\\\r\\\n\" | nc localhost 11300 | grep -E \"(current|uptime|version)\"\n\n";echo -e "stats\r\n" | nc localhost 11300 | grep -E "(current|uptime|version)"';

alias c='clear'

alias logslaravel=_logslaravel
_logslaravel() {
  clear;
  echo -e $BYellow"tail -f -n 150 laravel.log\n"$NC;
  if [ "$1" = "-f" ]; then
    # Filter out the stack trace lines (easier to read)
    echo "Filtering using:\n";
    echo -e $BYellow"grep -i -P \"^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next exception\" --color\n"$NC;
    tail -f -n 450 storage/logs/laravel.log | grep -i -P "^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next exception" --color
  else
    tail -f -n 150 storage/logs/laravel.log | grep -i -P "^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next exception|$" --color
  fi
}


alias taillogs='cd storage/logs/;clear;echo -e $BYellow"tail -F -n 0 /storage/logs/*.log\n"$NC;ls | grep -v laravel.log | grep -v .gz | xargs tail -F -n 0'
alias tailaccess='clear;echo -e $BYellow"tail -f -n 50 /var/log/nginx/access.log\n"$NC;sudo tail -F -n 50 /var/log/nginx/access.log'

alias gs='git status'
alias gf='echo -e $BGreen"git fetch -v --all -t -p --progress$NC\n";git fetch -v --all -t -p --progress'

_gpull() { git pull origin "$1"; }
alias gpull=_gpull

alias sb='source ~/.bash_profile'

# Allow the user to set the title.
function title {
  PROMPT_COMMAND="echo -ne \"\033]0;$1 [$USER]\007\"";
  clear;
}

alias cdump='composer dump-autoload'

_untar() { tar -xvzf "$1"; }
alias untar=_untar


# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;90m'       # Black
BRed='\e[1;91m'         # Red
BGreen='\e[1;92m'       # Green
BYellow='\e[1;93m'      # Yellow
BBlue='\e[1;94m'        # Blue
BPurple='\e[1;95m'      # Purple
BCyan='\e[1;96m'        # Cyan
BWhite='\e[1;97m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset


PS1="\[\e[1;97m\][\[\e[0;37m\]\u\[\e[1;97m\] \W]\$\[\e[0m\] "
#PS1="[\u \W]\$ "
clear;
