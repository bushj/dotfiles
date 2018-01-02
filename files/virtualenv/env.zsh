# prevent virtualenv from modifying prompt
VIRTUAL_ENV_DISABLE_PROMPT=true
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3

# virtualenvwrapper init
# set location of venv's
export WORKON_HOME=$HOME/.virtualenvs
# set location of venv projects
export PROJECT_HOME=$HOME/.venv_projects
# source the virtualenvwrapper script
source /usr/local/bin/virtualenvwrapper.sh

# Start session in default environment
workon py3
