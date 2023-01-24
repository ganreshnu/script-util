
#
# define a message function
#
msg() {
	local tag=$1 color=$2 
	shift 2
	>&2 printf "$(tput bold; tput setaf $color)%s:$(tput sgr0) %s\n" "$tag" "$@"
}
