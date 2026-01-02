#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <search-term>"
	echo "Example: $0 python"
	exit 2
fi

search_packages() {
	local search_term="$1"
	local results_file
	results_file="/tmp/pkg-search-$$.txt"

	echo "PACKAGE|STATUS|SUMMARY" > "$results_file"
	
	local dnf_output
	dnf_output=$(dnf search "$search_term" 2>/dev/null)

	if echo "$dnf_output" | grep -q "No matches found"; then
		echo "No packages found matching: ${search_term}"
		echo ""
		rm -f "$results_file"
		return 1
	fi

	local matched_packages
	matched_packages=$(echo "$dnf_output" | grep -E '^\s*\S+\s+' | grep -v '^Matched' | grep -v '^Name ' | sort -u)
		
	while IFS= read -r line; do
		local pkg_full
		local summary
		pkg_full=$(echo "$line" | awk '{print $1}')
		summary=$(echo "$line" | cut -f2- -d$'\t' | sed 's/^[[:space:]]*//' | cut -c1-80)

		local status
		local pkg_name="${pkg_full%.*}"
		if rpm -q "$pkg_name" >/dev/null 2>&1; then
			status="✓ Installed"
		else
			status="Available"
		fi
		
		echo "$pkg_full|$status|$summary" >> "$results_file"
	done <<< "$matched_packages"
	
	column -t -s '|' < "$results_file"
	rm -f "$results_file"
}

main() {
	echo ""
	echo "Package Search Tool"
	echo "==================="
	echo ""

	search_packages "$1"

	echo ""
	echo "Tip: Use 'dnf info <package>' for detailed information"
	echo ""
}

main "$@"
