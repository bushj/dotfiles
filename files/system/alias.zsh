# grc overides for ls
# #   Made possible through contributions from generous benefactors like
# #   `brew install coreutils`
#if $(gls &>/dev/null)
#then
#	alias ls="gls -F --color"
#	alias l="gls -lAh --color"
#	alias ll="gls -l --color"
#	alias la='gls -A --color'
#fi

# Make Ctrl-z also resume background process
fancy-ctrl-z () {
	if [[ $#BUFFER -eq 0 ]]; then
		BUFFER="fg"
		zle accept-line
	else
		zle flush-input
		zle clear-screen
	fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

rebuild-py3-virtualenv () {
	printf "\n\nRemoving and rebuilding py3 virtual environment...\n\n"
	if [[ "$VIRTUAL_ENV" != "" ]]
    then
      deactivate;
	fi
	rmvirtualenv py3;
	mkvirtualenv -p /usr/local/bin/python3 py3;
}
