# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# Source OS specific revisions
if [ "$(uname)" = "Darwin" ]; then
  # macOS
  if [ -f ~/.bash_macos ]; then
    . ~/.bash_macos
  fi
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
  # linux
  if [ -f ~/.bash_linux ]; then
    . ~/.bash_linux
  fi
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ]; then
  # Windows (32 bit)
  if [ -f ~/.bash_win32 ]; then
    . ~/.bash_win32
  fi
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW64_NT" ]; then
  # Windows (64 bit)
  if [ -f ~/.bash_win64 ]; then
    . ~/.bash_win64
  fi
fi

