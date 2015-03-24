# dotfiles
dotfiles and setup scripts for new machines.

This repo automates setup of a Mac:

- Installing Binaries with homebrew
- Installing Apps with homebrew cask
- Backing up and Restoring Configuration with mackup
- Solid Mac defaults for hackers using osx-for-hackers.sh (modified)
- Bringing it all together with dots

## Installation

One-liner:

```
(mkdir -p /tmp/dotfiles && cd /tmp/dotfiles && curl -L https://github.com/johncoogan/dotfiles/archive/master.tar.gz | tar zx --strip 1 && sh ./install.sh)
```

## Design

The goal of dotfiles is to automate the process of getting my operating system from a stock build to a fully functional machine. 

Dotfiles is the first thing I download and run to get my computer set up.

### Mac OS X

- install homebrew
- installs binaries (graphicsmagick, python, sshfs, ack, git, etc.)
- sets OSX defaults
- installs applications via `homebrew-cask` (one-password, sublime-text, virtualbox, nv-alt, iterm2, etc.)
- sets up the ~/.bash_profile 

### TODO

- Add support for Moom install
- Zsh instalation
- Heroku toolbelt install
- RescueTime
- Django properly setup
- Docker / VirtualBox / Etc.
- Excel Installation
- iPython / Anaconda installation
 
