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
  case "$SHELL" in
    */zsh) create_zshrc ;;
    *)  create_zshrc
        print "here"
        chsh -s "$(which zsh)";;
  esac
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

uninstall_brew_cask() {
  if brew list | grep -Fq brew-cask; then
    print "Uninstalling old Homebrew-Cask ..."
    brew uninstall --force brew-cask
  fi
}

update_brew() {
  print "Updating Homebrew ..."
  brew update
  brew upgrade
  brew doctor
}

install_brew_formulae() {
  # Unix
  brew "git"
  brew "openssl"
  brew "vim"
  brew "zsh"

  # Programming languages
  brew "node"
  brew "go"
  cask "java"

  # Databases
  brew "postgres", restart_service: true
  brew "redis", restart_service: true
  brew "mysql"
  # brew "mongodb"

  # Applications
  cask "vlc"                 unless Dir.exists?('/Applications/VLC.app')
  cask "atom"                unless Dir.exists?('/Applications/atom.app')
  cask "sublime-text"        unless Dir.exists?('/Applications/Sublime Text.app')
  cask "visual-studio-code"  unless Dir.exists?('/Applications/Visual Studio Code.app')
  cask "android-studio"      unless Dir.exists?('/Applications/Android Studio.app')
  cask "iterm2"              unless Dir.exists?('/Applications/iTerm.app')
  cask "google-chrome"       unless Dir.exists?('/Applications/Google Chrome.app')
  cask "firefox"             unless Dir.exists?('/Applications/Firefox.app')
  cask "slack"               unless Dir.exists?('/Applications/Slack.app')
  cask "github-desktop"      unless Dir.exists?('/Applications/Github Desktop.app')
  cask "postico"             unless Dir.exists?('/Applications/Postico.app')
  cask "mysqlworkbench"      unless Dir.exists?('/Applications/MySqlWorkbench.app')
  cask "notion"              unless Dir.exists?('/Applications/Notion.app')
  cask "evernote"            unless Dir.exists?('/Applications/Evernote.app')
  cask "spotify"             unless Dir.exists?('/Applications/Spotify.app')
  cask "rescuetime"          unless Dir.exists?('/Applications/RescueTime.app')
  cask "dash"                unless Dir.exists?('/Applications/Dash.app')
  # cask "1password"           unless Dir.exists?('/Applications/1Password.app')
  # cask "dropbox"             unless Dir.exists?('/Applications/Dropbox.app')
  # cask "google-drive"        unless Dir.exists?('/Applications/Google Drive.app')
}

print "Janus is brewing..."

check_command_line_tools

create_bin_if_not_exists

check_shell

append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

install_homebrew_if_not_exists

uninstall_brew_cask

# update_brew
brew bundle --file=- <<EOF

print "All set! Miss me - Janus!!"
