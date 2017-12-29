#!/bin/sh

# Bootstrap Ansible into a virtual python environment on osx

# print formatted info
info () {
  # \033[00;36mTEXT_INSIDE_OF_ESCAPE_SEQUENCE_WILL_BE_COLORED\033[0m
  prefix=" \033[00;36m-->\033[0m" # -->   36 is cyan
  suffix="\033[35m...\033[0m\n"   # ...   35 is magenta
  printf "$prefix $1$suffix"
}

install_homebrew () {
  info "Installing Homebrew"
  if test ! $(which brew)
  then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      info "Homebrew is already installed, skipping"
  fi
}

brew_install_python () {
  info "Updating Homebrew"
  brew update
  info "Brew installing python2"
  brew install python2
  info "Brew installing python3"
  brew install python3
}

pip_install_virtualenvwrapper () {
  info "Pip installing virtualenvwrapper"
  if [[ "$VIRTUAL_ENV" != "" ]]
  then
    info "Already in a virtualenv, skipping"
  else
    python3 -m pip install virtualenvwrapper
  fi
}

create_virtual_environment () {
  info "Creating virtual python environment"

  ### virtualenvwrapper init:
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
  export WORKON_HOME=$HOME/.virtualenvs
  source `which virtualenvwrapper.sh`

  # create python3 virtual environment
  mkvirtualenv -p /usr/local/bin/python3 py3
}

pip_install_ansible () {
  info "Pip installing Ansible"
  pip install ansible
}

run_setup_playbook () {
  info "Running installation playbook"
  ansible-playbook -i "localhost," -c local ansible/playbook.yml
}

main () {
  info "Preparing system for Ansible"
  install_homebrew
  brew_install_python
  pip_install_virtualenvwrapper
  create_virtual_environment
  pip_install_ansible
  run_setup_playbook
}

main
exit 0
