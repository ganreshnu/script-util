#!/bin/bash

main() {
	local HERE="$(dirname $BASH_SOURCE)"
	for package in $(pacman -Qq); do
		local deps=$(pacman -Qi "$package" | "$HERE/pacinfo.awk" -v sect='Optional Deps' | awk '!/\[installed\]$/ { print }')
		[[ "$deps" == 'None' || "$deps" == '' ]] && continue

		echo "PACKAGE: $package"
		echo "$deps"
		echo
	done
}
main "$@"
