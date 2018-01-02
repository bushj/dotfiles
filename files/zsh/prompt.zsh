setopt prompt_subst

# set up git autocompletion
autoload -Uz compinit && compinit

# color palette
DEFAULT_TXT_CLR='white'
VENV_CLR='cyan'
NAME_CLR=$DEFAULT_TXT_CLR
CURRENT_DIR_CLR=$DEFAULT_TXT_CLR
BRANCH_CLR=162
MACHINE_NAME_CLR=$DEFAULT_TXT_CLR
VAGRANT_CLR=$DEFAULT_TXT_CLR
SSH_CLR='red'

# prompt symbols
GIT_BRANCH_SYMBOL='⎇'
PROMPT_SYMBOL='>'


##### collect environment info #####

# get current virtualenv environment name
function get_virtualenv_info {
    [ $VIRTUAL_ENV ] && echo  "($(basename $VIRTUAL_ENV))"
}

# get current git branch name
function get_current_branch {
    echo "$(git symbolic-ref HEAD --short 2>/dev/null)"
}

# check if connected over ssh
function get_ssh_status {
    # if connected to vagranmt box, print only machine name
    if [[ `whoami` == 'vagrant' ]]; then
      echo "$( color $VAGRANT_CLR '%m' )"
    # if ssh, print name@machine
    elif [[ -n $SSH_CONNECTION ]]; then
      echo "$( color $SSH_CLR '%n@%m' )"
    else
      return
    fi
}


##### helper functions #####

# return string of specified color.
# arg1 is the color
# args 2->n are colorized
function color {
    echo "%F{$1}${@:2}%f"
}

# return bold string
function bold {
    echo "%B$1%b"
}


##### prompt components #####

# virtual environment name
function venv {
    echo "$( color $VENV_CLR $(get_virtualenv_info) )"
}

# current git branch
function branch {
    echo "$( color $BRANCH_CLR $GIT_BRANCH_SYMBOL $(get_current_branch) )"
}

# user name
function name {
    echo "$( color $NAME_CLR '%n' )"
}

# current machine name
function machine_name {
    echo "$( color $MACHINE_NAME_CLR '%m' )"
}

# current working directory
function current_dir {
    echo "$( color $CURRENT_DIR_CLR '%~' )"
}


##### prompt declaration #####
PS1=$'\n$(venv)$(current_dir) $(branch) \n$(get_ssh_status)$PROMPT_SYMBOL '
