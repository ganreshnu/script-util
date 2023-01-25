
#
# define a message function
#
#if [[ "$(type -t msg)" == 'function' ]]; then
#	return 0
#fi

msg() {
	usage() {
		cat <<EOD
Usage: $(basename "$BASH_SOURCE") [OPTIONS] MESSAGE

Options:
  --tag STRING             Colored tag.
  --color INT              Color of the tag or message if tag is empty.
  --help                   Display this message and exit.

Colors --tag and emits MESSAGE.
EOD
	}

	declare -A ARGS=(
		[tag]=
		[color]=4
	)

	# include pargs
	. "$(dirname "$BASH_SOURCE")/pargs.sh"

	local showusage=-1
	if pargs usage "$@"; then
		mapfile -s 1 -t args <<< "${ARGS[_]}"
		set -- "${args[@]}" && unset args ARGS[_]
	else
		[[ $? -eq 255 ]] && showusage=0 || showusage=$?
	fi

	if [[ $showusage -ne -1 ]]; then
		usage
		return $showusage
	fi

	if [[ "${ARGS[tag]}" ]]; then
		printf "$(tput bold; tput setaf ${ARGS[color]})%s:$(tput sgr0) %s\n" "${ARGS[tag]}" "$1"
	else
		printf "$(tput setaf ${ARGS[color]})%s$(tput sgr0)\n" "$1"
	fi
}


