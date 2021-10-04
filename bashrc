# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# FIRST: load aliases to get aliases (prompt and other stuff might be overridden below)
source ~/.aliases

# Allow for overridden prompt text (defaults to username \u)
# Typically this would be in ~/.variables and be machine-specific
if [ -z "$PROMPT_TEXT" ]; then
  PROMPT_TEXT="$USER"
fi

PS1='[\d \t \h]$ '
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\[\033[37m\][\[\033[91m\]\$PROMPT_TEXT\[\033[37m\]@\[\033[96m\]\\h\[\033[37m\] \\w]\[\033[91m\]# \\[$(tput sgr0)\\]"
else # normal
  PS1="\[\033[1;97m\][\[\033[0;37m\]\$PROMPT_TEXT\[\033[1;97m\] \W]\$\[\033[0m\] "
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

clear;
