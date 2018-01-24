On a new server, run the following command inside `~`:

## SSH Key
If needed, generate a new SSH key and add to GitHub settings:
1. `ssh-keygen`
2. `ssh-agent`
3. `cat ~/.ssh/id_rsa.pub`
4. Copy that output
5. Go to https://github.com/settings/keys and create a new key
6. Paste that stuff and hit save

## Clone this repo
`git clone git@github.com:jakebathman/dotfiles.git`

## "Install" the dotfiles
`cd ~/dotfiles && git pull && chmod +x ./installDotFiles.sh && ./installDotFiles.sh && source ~/.bashrc`

## Required dependencies
`logslaravel` requires `dialog`: 
`yum install dialog -y`
or
`brew install dialog -y`

## All done
Go have fun
