
#
# argument parser
#
pargs() {
	local usagefn="$1"; shift
	local args=$($usagefn | awk -F '  ' '/^  -/ { print $2 }')
	local positionals=()
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help )
				return 255
				;;
			-- )
				shift
				while [[ $# -gt 0 ]]; do
					positionals+=("$1")
					shift
				done
				break
				;;
			-?* )
				# convert short argument(s) to long
				if [[ "$1" != --?* ]]; then
					# split into character array
					mapfile -t sargs <<< $(fold -w 1 <<< "${1:1}")

					# multiple args passed in one
					if [[ ${#sargs[@]} -gt 1 ]]; then
						shift
						set -- $(printf '\055%s ' "${sargs[@]}") "$@"
						continue
					fi
				fi
				# get argument from help
				local arg=$(awk -F ', ' "/^$1| $1/ { if (NF > 1) { print \$2 } else { print \$1 } }" <<< "$args")
				# exit if this is an unknown argument
				if [[ ! "$arg" ]]; then
					>&2 printf "$(tput bold; tput setaf 1)error:$(tput sgr0) %s\n" "unknown argument $1"
					return 1
				fi

				# shift off this argument name
				shift

				# read the name and type from help
				local name= type=
				read name type <<< "$arg"

				# check for a value
				if [[ "$type" ]]; then
					# assign the value
					if [[ $# -gt 0 && "$1" != -?* ]]; then
						ARGS["${name:2}"]="$1"
						shift; continue
					fi

					# no value passed, check for requirement
					if [[ "${type::1}" != '[' ]]; then
						>&2 printf "$(tput bold; tput setaf 1)error:$(tput sgr0) %s\n" "$name requires an argument"
						return 1
					fi
				fi	

				# set as flag to affirmative
				ARGS["${name:2}"]=1
				;;
			* )
				# add to positionals
				positionals+=("$1")
				shift
				;;
		esac
	done
	ARGS[_]=$(printf '\n%s' "${positionals[@]}")
}

