#
# confirm function
#

# script is being sourced
if [[ "$0" != "$BASH_SOURCE" ]]; then
	[[ "$(type -t confirm)" == 'function' ]] && return
fi

confirm() {
	read -p "$1 [Y/n] " answer
	[[ ! "$answer" || "${answer,,}" =~ ^(y|yes)$ ]] || return 1
}

# script is being run
if [[ "$0" == "$BASH_SOURCE" ]]; then
	confirm "$@"
fi
