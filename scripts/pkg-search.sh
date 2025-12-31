#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <search-term>"
	echo "Example: $0 python"
	exit 2
fi

search_packages() {
	local search_term="$1"

	echo "Searching for: $search_term"
	echo ""

	dnf search "$search_term" 2>/dev/null | \
	grep -E '^\S+\s+:' | \
	awk -F' : ' '{print $1}' | sort -u
	
}

get_package_status() {
	local package="$1"

	local info
	info=$(dnf info "$package" 2>/dev/null || true)

	if echo "$info" | grep -q "^Installed packages"; then
		echo -e "${package} is installed.\n"
	elif echo "$info" | grep -q "^Available packages"; then
		echo -e "${package} is available to install.\n"
	else
		echo -e "${package} has no matching package.\n"
	fi
}

main() {
	echo ""
	echo "Package Search Tool"
	echo "==================="
	echo ""

	get_package_status "$1"
}

main "$@"
