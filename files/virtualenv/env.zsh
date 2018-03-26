OSX_PYTHON_INTERPRETER=/usr/local/bin/python3
LINUX_PYTHON_INTERPRETER=/usr/bin/python3

OSX_VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
LINUX_VIRTUALENVWRAPPER_SCRIPT=$HOME/.local/bin/virtualenvwrapper.sh

# prevent virtualenv from modifying prompt
VIRTUAL_ENV_DISABLE_PROMPT=true

# virtualenvwrapper init
# set location of venv's
export WORKON_HOME=$HOME/.virtualenvs
# set location of venv projects
export PROJECT_HOME=$HOME/.venv_projects

OPERATING_SYSTEM="`uname`"
case "$OPERATING_SYSTEM" in
'Darwin') VIRTUALENVWRAPPER_PYTHON=OSX_PYTHON_INTERPRETER
          # source the virtualenvwrapper script
		  source OSX_VIRTUALENVWRAPPER_SCRIPT
          ;;
'Linux')  VIRTUALENVWRAPPER_PYTHON=LINUX_PYTHON_INTERPRETER
          # source the virtualenvwrapper script
          source LINUX_VIRTUALENVWRAPPER_SCRIPT
          ;;
*)        echo "virtualenvwrapper not yet configured for: $OPERATING_SYSTEM" ;;
esac

# Start session in default environment
workon py3
