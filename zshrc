# FIRST: load aliases to get aliases (prompt and other stuff might be overridden below)
source ~/.aliases

# Path to your oh-my-zsh installation.
ZSH_DISABLE_COMPFIX=true
export ZSH=/Users/jakebathman/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="gianu"
ZSH_THEME="spaceship"

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
    artisan
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
prompt spaceship

#############
# START Spaceship prompt settings

SPACESHIP_PROMPT_ORDER=(
    time          # Time stampts section
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    package       # Package version
    node          # Node.js section
    xcode         # Xcode section
    swift         # Swift section
    golang        # Go section
    php           # PHP section
    docker        # Docker section
    exec_time     # Execution time
    line_sep      # Line break
    exit_code     # Exit code section
    char          # Prompt character
)

SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=needed
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_DIR_PREFIX=""

SPACESHIP_GIT_BRANCH_COLOR="081" # blue
SPACESHIP_DIR_COLOR="208" # orange

# Fix for git directory issue: https://github.com/denysdovhan/spaceship-prompt/issues/343
SPACESHIP_DIR_TRUNC_REPO=false

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

##### Easily switch between PHP versions just by using the version number as an alias
##### Source: https://localheinz.com/articles/2020/05/05/switching-php-versions-when-using-homebrew/

# determine versions of PHP installed with HomeBrew
installedPhpVersions=($(brew ls --versions | ggrep -E 'php(@.*)?\s' | ggrep -oP '(?<=\s)\d\.\d' | uniq | sort))

# create alias for every version of PHP installed with HomeBrew
for phpVersion in ${installedPhpVersions[*]}; do
    value="{"

    for otherPhpVersion in ${installedPhpVersions[*]}; do
        if [ "${otherPhpVersion}" = "${phpVersion}" ]; then
            continue;
        fi

        value="${value} brew unlink php@${otherPhpVersion};"
    done

    value="${value} brew link php@${phpVersion} --force --overwrite; } &> /dev/null && php -v"

    alias "${phpVersion}"="${value}"
done
