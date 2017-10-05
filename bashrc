# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:$HOME/.composer/vendor/bin
export PATH

#-----------------------------------------------------
# Aliases
#----------------------------------------------------

app_dir='/home/vagrant/axxess/cahps/';

alias cdapp='cd ${app_dir}';

alias vbash=_vimbash
_vimbash() {
  vim ~/dotfiles/bashrc;
}

alias redis=redis-cli
alias c='clear'

alias lsa='echo -e $BYellow"ls -lsAh --color --file-type --group-directories-first --time-style=+"%Y-%m-%d %T"$NC\n";ls -lsAh --color --file-type --group-directories-first --time-style=+"%Y-%m-%d %T"'

alias logslaravel=_logslaravel
_logslaravel() {
  # see if we're in a laravel project root right now
  if [ -d "storage" ]; then
    project_root="$(pwd)/"
    echo "root: $project_root"
  else
    current_pwd="$(pwd)"
    proj="${app_dir}"

    # check that the current directory is the root of a project
    if [[ $current_pwd != *"$proj"* ]]; then
      cd "$proj"
    fi

    let i=0 # define counting variable
    W=() # define working array
    while read -r line; do # process file by file
      let i=$i+1
      if [ -d "${proj}${line}storage/logs" ]; then
        W+=($i "$line")
      fi
      if [ -d "${proj}${line}app/storage/logs" ]; then
        W+=($i "$line")
      fi
    done < <( ls -1 -d */ )
    FILE=$(dialog --title "List file of directory /home" --menu "Chose one" 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3) # show dialog and store output

    if [ $? -eq 0 ]; then # Exit with OK
      theproject=$(ls -1d */ | sed -n "`echo "$FILE p" | sed 's/ //'`")
    else
      echo "no directories :("
    fi
    project_root="${proj}${theproject}";
  fi
  
  # make sure the log file is in the place we expect (might not be, due to laravel 4/5 diffs)
  if [ -d "${project_root}app/storage/logs" ]; then
    project_root="${project_root}app/";
  fi
  clear;
  echo -e $BYellow"tail -f -n 150 laravel.log\n"$NC;
  if [ "$1" = "-f" ]; then
    # Filter out the stack trace lines (easier to read)
    echo "Filtering using:\n";
    echo -e $BYellow"grep -i -P \"^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next exception\" --color\n"$NC;
    tail -f -n 450 "$project_root"storage/logs/laravel.log | grep -i -P "^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next [\w\W]+?\:" --color
  else
    tail -f -n 150 "$project_root"storage/logs/laravel.log | grep -i -P "^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next [\w\W]+?\:|$" --color
  fi

}
# Fix permissions in a laravel 5.x project
alias permlar=_permlar
_permlar(){
  # Make sure /storage exists
  if [ -d "storage" ]; then
    owner="$(stat -c %U .)" # get the directory owner name
    sudo chmod -Rf 777 storage
    sudo chown -Rf "$owner:$owner" storage
  fi

  # Make sure /bootstrap exists
  if [ -d "bootstrap" ]; then
    owner="$(stat -c %U .)" # get the directory owner name
    sudo chmod -Rf 777 bootstrap
    sudo chown -Rf "$owner:$owner" bootstrap
  fi
}

alias taillogs='cd storage/logs/;clear;echo -e $BYellow"tail -F -n 0 /storage/logs/*.log\n"$NC;ls | grep -v laravel.log | grep -v .gz | xargs tail -F -n 0'
alias tailaccess='clear;echo -e $BYellow"tail -f -n 50 /var/log/nginx/access.log\n"$NC;sudo tail -F -n 50 /var/log/nginx/access.log'
alias tailphp='tail /var/log/php-fpm/www-error.log  -f'

# Quick git helpers
alias gs='git status'
alias gf='echo -e $BGreen"git fetch -v --all -t -p --progress 2>&1 | grep -v \"up to date\"$NC\n";git fetch -v --all -t -p --progress 2>&1 | grep -v "up to date"'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd='echo -e $BGreen"git diff --color=always\n\n"$NC;git diff --color=always'

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

# Parse the ifconfig return for IPs (IPv4 and IPv6) and display them nicely according to adapter
# Yes, it's overkill. 
# Yes, it murders regular expressions for no reason.
# Yes, it's not necessary to use this.
# This has been tested on CentOS 6/7, and relies on grep's Perl regex matching
alias myip='ifconfig | grep -o --color=always -P "(^([A-Za-z0-9]+)\:)|(inet|inet6)\s*((\d{1,3}\.){3}\d{1,3}|((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:)))(%.+)?)"'


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
  PS1="\[\e[1;97m\][\[\e[0;37m\]\u\[\e[1;97m\] \W]\$\[\e[0m\] "
fi

# Source any machine-specific stuff from ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

clear;
