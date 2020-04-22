#!/bin/sh
echo "Welcome to the world of Janus! Let's automate the dev world <3"

print() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}


# Check if command line tools are installed.
# https://stackoverflow.com/questions/15371925/how-to-check-if-command-line-tools-is-installed
check_command_line_tools() {
  xcode-select -p >/dev/null

  if [[ $? != 0 ]]; then
    echo 'Command line tools are not installed...'
    echo 'Check this for installation instructions - https://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/'
    echo 'Please install and then come back to Janus.'
    exit
  fi
}

create_bin_if_not_exists() {
  if [[ ! -d "$HOME/.bin/" ]]; then
      mkdir "$HOME/.bin/"
  fi
}

create_zshrc() {
  if [ ! -f "$HOME/.zshrc" ]; then
    touch "$HOME/.zshrc"
  fi
}

check_shell() {
  local get_shell=echo $(echo $SHELL | cut -d/ -f3 );
  if [[ $get_shell == "zsh" ]]; then 
    create_zshrc
  else
    create_zshrc
    chsh -s "$(which zsh)"
  fi
}

append_to_zshrc() {
  local text="$1"
  local zshrc="$HOME/.zshrc"
  local skip_new_line="${2:-0}"

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

install_homebrew_if_not_exists() {
  if ! command -v brew >/dev/null; then
    print "Installing Homebrew ..."
    curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
    append_to_zshrc '# Recommended by brew doctor'
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"'
    export PATH="/usr/local/bin:$PATH"
  else
    print "Homebrew already installed."
  fi
}

if brew list | grep -Fq brew-cask; then
  inform "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

print "Janus is brewing..."

check_command_line_tools

create_bin_if_not_exists

check_shell

append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

install_homebrew_if_not_exists

ssh_key_setup

inform "All set! Miss me - Janus!!"



