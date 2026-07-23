

# Record the initial start time
start_time=$(gdate +%s.%N)

# Function to calculate, print elapsed time with a custom message, and reset start time
print_elapsed_time() {
    local message=$1
    local current_time=$(gdate +%s.%N)
    local elapsed_time=$(echo "$current_time - $start_time" | bc)
    echo "${message}: ${elapsed_time}s"
    start_time=$current_time  # Reset the start time
}


# FIRST: load aliases to get aliases (prompt and other stuff might be overridden below)
source ~/.aliases
source ~/.path

# Path to your oh-my-zsh installation.
ZSH_DISABLE_COMPFIX=true
export ZSH=/Users/jakebathman/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="gianu"
# ZSH_THEME="spaceship"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    autojump
    brew
    catimg
    jsontools
    npm
    redis-cli
    sudo
    supervisor
    systemd
)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set Pure as prompt
# fpath+=($HOME/.oh-my-zsh/plugins/pure) # Add Pure to fpath
# autoload -U promptinit; promptinit
# prompt pure

# Set Spaceship ZSH as a prompt
fpath=( "$HOME/.zfunctions" $fpath )
autoload -U promptinit; promptinit
# prompt spaceship

#############
# START Spaceship prompt settings

# SPACESHIP_PROMPT_ORDER=(
#     time          # Time stampts section
#     user          # Username section
#     dir           # Current directory section
#     host          # Hostname section
#     git           # Git section (git_branch + git_status)
#     package       # Package version
#     node          # Node.js section
#     xcode         # Xcode section
#     swift         # Swift section
#     golang        # Go section
#     php           # PHP section
#     docker        # Docker section
#     exec_time     # Execution time
#     line_sep      # Line break
#     exit_code     # Exit code section
#     char          # Prompt character
# )

# SPACESHIP_PROMPT_SEPARATE_LINE=false
# SPACESHIP_USER_SHOW=needed
# SPACESHIP_PACKAGE_SHOW=false
# SPACESHIP_NODE_SHOW=false
# SPACESHIP_PHP_SHOW=false
# SPACESHIP_RUBY_SHOW=false
# SPACESHIP_DIR_PREFIX=""

# SPACESHIP_GIT_BRANCH_COLOR="081" # blue
# SPACESHIP_DIR_COLOR="208" # orange

# Fix for git directory issue: https://github.com/denysdovhan/spaceship-prompt/issues/343
# SPACESHIP_DIR_TRUNC_REPO=false

# END Spaceship prompt settings
#############

ARTISAN_OPEN_ON_MAKE_EDITOR=code

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

## Change the EOL character when no EOL is used (defaults to inverse %)
PROMPT_EOL_MARK=""

# Fix issue with autojump (j) autocomplete
# More info: https://github.com/wting/autojump/issues/353
autoload -U compinit; compinit

clear;

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/usr/local/sbin:$PATH"
# export PATH="/usr/local/opt/php@8.1/bin:$PATH"
# export PATH="/usr/local/opt/php@7.4/sbin:$PATH"
# export PATH="/usr/local/opt/php@8.0/bin:$PATH"

# Lazy load nvm to speed up shell startup time
export NVM_DIR="$HOME/.nvm"

_load_nvm() {
    unset -f nvm node npm npx _load_nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

nvm()  { _load_nvm && nvm "$@"; }
node() { _load_nvm && node "$@"; }
npm()  { _load_nvm && npm "$@"; }
npx()  { _load_nvm && npx "$@"; }

# When cd-ing into a directory, set node version based on .nvmrc file if it exists
autoload -U add-zsh-hook

load-nvmrc() {
    (( $+functions[_load_nvm] )) && _load_nvm
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"
    
    if [ -n "$nvmrc_path" ]; then
        nvm use --silent
        echo $Pink"node.js   $BPink$(nvm current) $Pink(.nvmrc)"$NC
    else
        # If this directory has a package.json file, check if it has an "engines" field specifying a node version
        if [ -f package.json ]; then
            local package_node_version
            package_node_version=$(jq -r '.engines.node // empty' package.json 2>/dev/null)
            if [ -n "$package_node_version" ]; then
                nvm use "$package_node_version" --silent
                echo $Pink"node.js   $BPink$(nvm current) $Pink(package.json engine is $package_node_version, no .nvmrc found)"$NC
            else
                # If no "engines" field is found, use the default version
                echo $Pink"node.js   $BPink$(nvm current) $Pink(nvm default)"$NC
                nvm use default --silent
            fi
        fi
    fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# When cd-ing into a directory with a composer.json (Laravel repo, close
# enough), switch Herd's CLI PHP version to match.
_find_composer_root() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/composer.json" ]; then
            print -r -- "$dir"
            return 0
        fi
        dir="${dir:h}"
    done
    return 1
}

load-herd-php() {
    local project_root
    project_root="$(_find_composer_root)" || return

    local target_php
    target_php="$(herd which-php 2>/dev/null)"
    [ -z "$target_php" ] && return
    target_php="$(realpath "$target_php" 2>/dev/null)"
    [ -z "$target_php" ] && return

    local version="${target_php##*/php}"
    version="${version:0:1}.${version:1}"
    herd use "$version" >/dev/null 2>&1
    echo $Pink"Herd PHP  $BPink${version}$NC"

    local required
    required="$(jq -r '.require.php // empty' "$project_root/composer.json" 2>/dev/null | grep -oE '[0-9]+\.[0-9]+' | head -1)"
    if [ -n "$required" ] && [ "$required" != "$version" ]; then
        echo $BYellow"Warning: composer.json requires PHP $required, Herd is using $version$NC"
    fi
}

add-zsh-hook chpwd load-herd-php
load-herd-php

# Prefer the project's vendor/bin/duster (the version CI uses) over the
# global composer install, which can drift out of date and lint differently.
duster() {
    local project_root
    if project_root="$(_find_composer_root)" && [ -x "$project_root/vendor/bin/duster" ]; then
        "$project_root/vendor/bin/duster" "$@"
    else
        command duster "$@"
    fi
}

##### Easily switch between PHP versions just by using the version number as an alias
##### Source: https://localheinz.com/articles/2020/05/05/switching-php-versions-when-using-homebrew/

# determine versions of PHP installed with HomeBrew
# installedPhpVersions=($(brew ls --versions | ggrep -E 'php(@.*)?\s' | ggrep -oP '(?<=\s)\d\.\d' | uniq | sort))

# create alias for every version of PHP installed with HomeBrew
# e.g. 8.0 // 8.1 // 8.2 will swap to that version on the command line
_makePhpVersionAliases() {
    for phpVersion in ${installedPhpVersions[*]}; do
        value="{"
        
        for otherPhpVersion in ${installedPhpVersions[*]}; do
            if [ "${otherPhpVersion}" = "${phpVersion}" ]; then
                continue;
            fi
            
            value="${value} brew unlink php@${otherPhpVersion};"
        done
        
        value="${value} brew link php@${phpVersion} --force --overwrite; } &> /dev/null && php -v"
        # echo "Creating alias for PHP ${phpVersion} with value: ${value}\n"
        alias "${phpVersion}"="${value}"
    done
}
# _makePhpVersionAliases

# Make mysql available on the command line
# Also do other stuff: https://crobert.dev/articles/accessing-laravel-herds-mysql-service-or-any-other-service-from-your-cli
#   - Add mysql to the PATH
#   - Add user/password/socket path to ~/.my.cnf
export PATH="/Users/Shared/Herd/services/mysql/8.0.36/bin:$PATH"

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/82/"


# Herd injected PHP 8.1 configuration.
export HERD_PHP_81_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/81/"


# Herd injected PHP 8.0 configuration.
export HERD_PHP_80_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/80/"


# Herd injected PHP binary.
export PATH="/Users/jakebathman/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/74/"


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/84/"

# Created by `pipx` on 2025-05-06 16:29:30
export PATH="$PATH:/Users/jakebathman/.local/bin"


# Herd injected PHP 8.5 configuration.
export HERD_PHP_85_INI_SCAN_DIR="/Users/jakebathman/Library/Application Support/Herd/config/php/85/"

# Added by Antigravity
export PATH="/Users/jakebathman/.antigravity/antigravity/bin:$PATH"
