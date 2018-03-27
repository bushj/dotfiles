#!/bin/bash

# Bootstrap Ansible into a virtual python environment on desired OS

# print formatted info
info () {
  # \033[00;36mTEXT_INSIDE_OF_ESCAPE_SEQUENCE_WILL_BE_COLORED\033[0m
  prefix=" \033[00;36m-->\033[0m" # -->   36 is cyan
  suffix="\033[35m...\033[0m\n"   # ...   35 is magenta
  printf "$prefix $1$suffix"
}

prompt_for_git_credentials () {
  # If credentials haven't already been configured, collect github info
  if [ -e files/git/gitconfig.symlink ]
  then
      GIT_NAME=""
      GIT_EMAIL=""
  else
      read -p "Enter your Github username: " GIT_NAME
      read -p "Enter your Github email: " GIT_EMAIL
  fi
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

update_and_upgrade_apt () {
  info "Updating and Upgrade apt"
  sudo apt-get update
  sudo apt-get -y upgrade
}

install_pip_on_linux () {
  info "Installing pip"
  sudo apt-get -y install python3-pip
  pip3 install --upgrade pip
}

install_zsh_on_linux () {
  info "Installing zsh"
  sudo apt-get -y install zsh
}

pip_install_virtualenvwrapper_on_osx () {
  info "Pip installing virtualenvwrapper"
  if [[ "$VIRTUAL_ENV" != "" ]]
  then
    info "Already in a virtualenv, skipping"
  else
    python3 -m pip install virtualenvwrapper
  fi
}

pip_install_virtualenvwrapper_on_linux () {
  info "Pip installing virtualenvwrapper"
  if [[ "$VIRTUAL_ENV" != "" ]]
  then
    info "Already in a virtualenv, skipping"
  else
    pip3 install --user virtualenvwrapper
  fi
}

create_virtual_environment_on_osx () {
  info "Creating virtual python environment"

  ### virtualenvwrapper init:
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
  export WORKON_HOME=$HOME/.virtualenvs
  source `which virtualenvwrapper.sh`

  # create python3 virtual environment
  mkvirtualenv -p /usr/local/bin/python3 py3
}

create_virtual_environment_on_linux () {
  info "Creating virtual python environment"

  ### virtualenvwrapper init:
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
  export WORKON_HOME=$HOME/.virtualenvs
  # source virtualenvwrapper script from pip --user install location
  source $HOME/.local/bin/virtualenvwrapper.sh

  # create python3 virtual environment
  mkvirtualenv -p /usr/bin/python3 py3
}

pip_install_ansible () {
  info "Pip installing Ansible"
  pip install ansible
}

run_setup_playbook () {
  info "Running installation playbook"
  ansible-playbook -i "localhost," -c local ansible/playbook.yml \
          --extra-vars "git_name=$GIT_NAME git_email=$GIT_EMAIL"
}

run_setup_playbook_py3_interpreter () {
  info "Running installation playbook"
  ansible-playbook -i "localhost," -c local ansible/playbook.yml \
          -e 'ansible_python_interpreter=/usr/bin/python3' \
          --extra-vars "git_name=$GIT_NAME git_email=$GIT_EMAIL"
}

bootstrap_osx () {
  info "Preparing system for Ansible"
  install_homebrew
  brew_install_python
  pip_install_virtualenvwrapper_on_osx
  create_virtual_environment_on_osx
  pip_install_ansible
  run_setup_playbook
}

bootstrap_linux () {
  info "Preparing system for Ansible"
  update_and_upgrade_apt
  install_zsh_on_linux
  install_pip_on_linux
  pip_install_virtualenvwrapper_on_linux
  create_virtual_environment_on_linux
  pip_install_ansible
  run_setup_playbook_py3_interpreter
}

main () {
  prompt_for_git_credentials
  OPERATING_SYSTEM="`uname`"
  info "Bootstrapping Ansible onto $OPERATING_SYSTEM"
  case "$OPERATING_SYSTEM" in
    'Darwin') bootstrap_osx ;;
    'Linux')  bootstrap_linux ;;
    *)        info "Not configured to bootstrap on $OPERATING_SYSTEM" ;;
  esac
}

main
exit 0
