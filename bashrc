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

alias cdapp='cd ${app_dir}';

alias vbash=_vimbash
_vimbash() {
  vim ~/dotfiles/bashrc;
}

alias redis=redis-cli
alias c='clear'

# Copy & vim the new file
cpvim() {
  cp "$1" "$2"
  vim "$2"
}

# Make directory and cd into it
mkcd() {
  mkdir "$1"
  cd "$1"
}

alias phpunit="./vendor/bin/phpunit"

alias lsa='echo -e $BYellow"ls -lsAh --color --file-type --group-directories-first --time-style=+"%Y-%m-%d %T"$NC\n";ls -lsAh --color --file-type --group-directories-first --time-style=+"%Y-%m-%d %T"'

alias logslaravel=_logslaravel
_logslaravel() {
  # see if we're in a laravel project root right now
  if [ -d "storage" ]; then
    project_root="$(pwd)/"
  elif [ -d "app/storage" ]; then
    project_root="$(pwd)/"
  else
    current_pwd="$(pwd)"
    proj="${app_dir}"

    # check that the current directory is the root of a project
    if [[ $current_pwd != *"$proj" ]]; then
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
alias tailphp='tail /var/log/php-fpm/www-error.log  -f'

# Quick git helpers
alias gs='git status'
alias gf='echo -e $BGreen"git fetch -v --all -t -p --progress 2>&1 | grep -v \"up to date\"$NC\n";git fetch -v --all -t -p --progress 2>&1 | grep -v "up to date"'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd='echo -e $BGreen"git diff --color=always\n\n"$NC;git diff --color=always'

gpmaster() {
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

gitcheck() {
  echo -e $Cyan"git checkout -b $1 origin/$1"$NC;
  git checkout -b "$1" origin/"$1";
}

gpull() { git pull origin "$1"; }

alias beanstats='echo -e $BGreen"echo -e "stats\r\n" | nc localhost 11300 | grep -E \"(current|uptime|version)\"\n\n";echo -e "stats\r\n" | nc localhost 11300 | grep -E "(current|uptime|version)"';

alias sb='source ~/.bash_profile'

# Allow the user to set the title.
function title {
  PROMPT_COMMAND="echo -ne \"\033]0;$1 [$USER]\007\"";
  clear;
}

alias cdump='composer dump-autoload'

untar() { tar -xvzf "$1"; }

# Parse the ifconfig return for IPs (IPv4 and IPv6) and display them nicely according to adapter
# Yes, it's overkill. 
# Yes, it murders regular expressions for no reason.
# Yes, it's not necessary to use this.
# This has been tested on CentOS 6/7, and relies on grep's Perl regex matching
alias myip='ifconfig | grep -o --color=always -P "(^([A-Za-z0-9]+)\:?)|(inet|inet6)\s*(?:addr:?)?\s*((\d{1,3}\.){3}\d{1,3}|((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:)))(%.+)?)"'


# Normal Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;90m'       # Black
BRed='\033[1;91m'         # Red
BGreen='\033[1;92m'       # Green
BYellow='\033[1;93m'      # Yellow
BBlue='\033[1;94m'        # Blue
BPurple='\033[1;95m'      # Purple
BCyan='\033[1;96m'        # Cyan
BWhite='\033[1;97m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC="\033[m"               # Color Reset

colorcodes() {
  T='=^-^='

  echo -e "\n  normal bg         40m       41m       42m       43m       44m       45m       46m       47m";
  echo -e "    bold bg        100m      101m      102m      103m      104m      105m      106m      107m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m'  '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
  do 
    FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do 
      echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
echo

echo -e "\n\033[30m\033[107mExample use:\033[0m\n"
echo "     escape prefix    \\033["
echo "   white bold text    .    1;37m"
echo "     escape prefix    .    .    \\033["
echo "magenta background    .    .    .    45m"
echo "              text    .    .    .    .   white on magenta"
echo "     escape prefix    .    .    .    .   .                \\033["
echo "  clear formatting    .    .    .    .   .                .    0m"
echo "                      .    .    .    .   .                .    ."
echo "      full command    \\033[1;37m\\033[45m white on magenta \\033[0m"
echo -e "         result                         \033[1;37m\033[45m white on magenta \033[0m"

}


PS1='[\d \t \h]$ '
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\[\033[37m\][\[\033[91m\]\\u\[\033[37m\]@\[\033[96m\]\\h\[\033[37m\] \\w]\[\033[91m\]# \\[$(tput sgr0)\\]"
else # normal
  PS1="\[\033[1;97m\][\[\033[0;37m\]\u\[\033[1;97m\] \W]\$\[\033[0m\] "
fi

# Source OS specific revisions
if [ "$(uname)" == "Darwin" ]; then
  # macOS
  if [ -f ~/.bash_macos ]; then
    . ~/.bash_macos
  fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # linux
  if [ -f ~/.bash_linux ]; then
    . ~/.bash_linux
  fi
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  # Windows (32 bit)
  if [ -f ~/.bash_win32 ]; then
    . ~/.bash_win32
  fi
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
  # Windows (64 bit)
  if [ -f ~/.bash_win64 ]; then
    . ~/.bash_win64
  fi
fi


# Source any machine-specific stuff from ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

clear;
