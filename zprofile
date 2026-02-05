export PATH="$PATH:$HOME/.rvm/bin"

# Lazy load RVM
_load_rvm() {
  unset -f rvm ruby gem bundle irb _load_rvm
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
}

rvm()    { _load_rvm && rvm "$@"; }
ruby()   { _load_rvm && ruby "$@"; }
gem()    { _load_rvm && gem "$@"; }
bundle() { _load_rvm && bundle "$@"; }
irb()    { _load_rvm && irb "$@"; }



eval "$(/opt/homebrew/bin/brew shellenv)"

# Created by `pipx` on 2025-05-06 16:29:30
export PATH="$PATH:/Users/jakebathman/.local/bin"
