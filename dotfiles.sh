#!/usr/bin/env bash
version="0.0.7"

# dotfiles(1) main
main() {

  # paths
  export dirname=$(dirname $(realpath $0))
  export lib="$dirname/lib"
  export os="$dirname/os"

  # parse options
  while [[ "$1" =~ ^- ]]; do
    case $1 in
      -v | --version )
        echo $version
        exit
        ;;
      -h | --help )
        usage
        exit
        ;;
    esac
    shift
  done

  # run command
  case $1 in
    reload )
      source "$HOME/.bash_profile"
      ;;
    boot )
      boot $2
      exit
      ;;
    update )
      update $2
      exit
      ;;
    open )
      open
      exit
      ;;
    *)
      usage
      exit
      ;;
  esac
}

# usage info
usage() {
  cat <<EOF

  Usage: dotfiles [options] [command] [args ...]

  Options:

    -v, --version           Get the version
    -h, --help              This message

  Commands:

    reload                  Reload the dotfiles
    boot <os>               Bootstrap the given operating system
    update <os|dotfiles>        Update the os or dotfiles
    open                    Open dotfiles for development

EOF
}

# Bootstrap the OS
boot() {
  if [[ -e "$os/$1/index.sh" ]]; then
    sh "$os/$1/index.sh"
  else
    echo "boot: could not find \"$1\""
    exit 1
  fi
}

# update either dotfiles or OS
update() {
  if [[ -e "$os/$1/index.sh" ]]; then
    sh "$os/$1/update.sh"
  else
    updatedotfiles
  fi
}

# update dotfiles(1) via git clone
updatedotfiles() {
  echo "updating dotfiles..."
  mkdir -p /tmp/dotfiles \
    && cd /tmp/dotfiles \
    && curl -L# https://github.com/johncoogan/dotfiles/archive/master.tar.gz | tar zx --strip 1 \
    && ./install.sh \
    && echo "updated dotfiles to $(dotfiles --version)."
  exit
}

# "readlink -f" shim for mac os x
realpath() {
  target=$1
  cd `dirname $target`
  target=`basename $target`

  # Iterate down a (possible) chain of symlinks
  while [ -L "$target" ]
  do
      target=`readlink $target`
      cd `dirname $target`
      target=`basename $target`
  done

  dir=`pwd -P`
  echo $dir/$target
}

# open dotfiles(1)
# TODO use default editor
open() {
  open $dirname
}

# Call main
main "$@"
