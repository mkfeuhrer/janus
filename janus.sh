#!/bin/sh
echo "Welcome to the world of janus! Let's automate the dev world <3"

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
    echo 'Please install to continue.'
    exit
  fi
}

print "Janus is brewing..."

check_command_line_tools
