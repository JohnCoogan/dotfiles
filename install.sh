sudo -v

# paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"

# make in case they aren't already there
sudo mkdir -p "/usr/local/lib"
sudo mkdir -p "/usr/local/bin"

# Copy the path
sudo cp -R $dirname "$lib/"

# remove existing bin if it exists
if [ -e "$bin/dotfiles" ]; then
  sudo rm "$bin/dotfiles"
fi

# symlink dotfiles
sudo ln -s "$lib/dotfiles/dotfiles.sh" "$bin/dotfiles"

# Ubuntu-only: Change from dash to bash
if [ "$BASH_VERSION" = '' ]; then
  sudo echo "dash    dash/sh boolean false" | debconf-set-selections ; dpkg-reconfigure --frontend=noninteractive dash
fi
