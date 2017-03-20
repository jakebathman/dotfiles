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
alias c='clear'

alias lsa='echo -e $BYellow"ls -lsAh --color --file-type --group-directories-first --time-style=+"%Y-%m-%d %T"$NC\n";ls -lsAh --color --file-type --group-directories-first --time-style=+"%Y-%m-%d %T"'

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
alias tailphp='tail /var/log/php-fpm/www-error.log  -f'

# Quick git helpers
alias gs='git status'
alias gf='echo -e $BGreen"git fetch -v --all -t -p --progress 2>&1 | grep -v \"up to date\"$NC\n";git fetch -v --all -t -p --progress 2>&1 | grep -v "up to date"'


alias gpmaster=_gpmaster
_gpmaster() {
  echo -e "\n";
  echo -e $BGreen"     git fetch -v --all -t -p --progress$NC\n";
  git fetch -v --all -t -p --progress;
  echo -e "\n-----------------------------\n";
  echo -e $BGreen"     git checkout master$NC\n";
  git checkout master;
  echo -e "\n-----------------------------\n";
  echo -e $BGreen"     git pull --verbose origin master$NC\n";
  git pull --verbose origin master;
  echo -e "\n-----------------------------\n";
  echo -e $BBlue"     composer dump-autoload$NC\n";
  composer dump-autoload;
  echo -e "\n";
}
alias gitcheck=_gitcheck
_gitcheck() {
  echo -e $Cyan"git checkout -b $1 origin/$1"$NC;
  git checkout -b "$1" origin/"$1";
}
alias beanstats='echo -e $BGreen"echo -e "stats\r\n" | nc localhost 11300 | grep -E \"(current|uptime|version)\"\n\n";echo -e "stats\r\n" | nc localhost 11300 | grep -E "(current|uptime|version)"';



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


PS1='[\d \t \h]$ '
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\[\e[37m\][\[\e[91m\]\\u\[\e[37m\]@\[\e[96m\]\\h\[\e[37m\] \\w]\[\e[91m\]# \\[$(tput sgr0)\\]"
else # normal
  PS1="[\\u@\\h:\\w]$ "
fi

clear;
