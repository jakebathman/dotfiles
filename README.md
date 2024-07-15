# Dotfiles

## Adding something new
If adding a new file, make sure to add it to the file list inside `installDotFiles.sh`

## Installing
On a new server, run the following command inside `~`:

### SSH Key
If needed, generate a new SSH key and add to GitHub settings:
1. `ssh-keygen`
2. `ssh-agent`
3. `cat ~/.ssh/id_rsa.pub`
4. Copy that output
5. Go to https://github.com/settings/keys and create a new key
6. Paste that stuff and hit save

### Clone this repo
`git clone git@github.com:jakebathman/dotfiles.git`

### "Install" the dotfiles
`cd ~/dotfiles && git pull && chmod +x ./installDotFiles.sh && ./installDotFiles.sh && source ~/.bashrc`

### Required dependencies
1. The basics: `brew install curl wget`

2. The `logslaravel` function requires `dialog`: 
```sh
# on macOS
brew install dialog -y
# on linux
yum install dialog -y
```

3. Install OhMyZSH (for plugins and stuff)
```sh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

4. Install autojump for `j`:
```sh
brew install autojump
```

5. Install `nvm`:
```sh
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

### Other modifications 
1. Symlink `php` from Herd to `/usr/local/bin/php` for Alfred to be able to run PHP scripts:
```sh
sudo ln -s "/Users/jakebathman/Library/Application Support/Herd/bin//php" /usr/local/bin/php
```

### All done
Go have fun
