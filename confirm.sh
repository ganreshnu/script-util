confirm() {
	read -p "$1 [Y/n] " answer
	[[ ! "$answer" || "${answer,,}" =~ ^(y|yes)$ ]] || return 1
}
