#!/usr/bin/env bash
set -euo pipefail

list_packages() {

	if rpm -qa | grep -i "${1:-}" >/dev/null 2>&1; then
		rpm -qa --queryformat '%{NAME}|%{VERSION}-%{RELEASE}|%{ARCH}|%{SIZE}|%{INSTALLTIME:date}\n' | \
        sort | \
		if [[ -n "${1:-}" ]]; then
			grep -i "${1:-}"
		else
			cat
		fi | \
			column -t -s '|' -N "PACKAGE,VERSION,ARCH,SIZE(bytes),INSTALLED"
	else
		echo "No match found"
	fi
}

show_summary() {
	local total_packages
	local total_size

	if rpm -qa | grep -i "${1:-}" >/dev/null 2>&1; then
		
		total_packages=$(rpm -qa | if [[ -n "${1:-}" ]]; then grep -i "${1:-}"; else cat; fi | wc -l)

	 	total_size=$(rpm -qa --queryformat '%{SIZE} %{NAME}\n' | if [[ -n "${1:-}" ]]; then grep -i "${1:-}"; else cat; fi | \
		awk '{sum += $1} END {print sum}')
	else
		total_packages=0
		total_size=0
	fi
	
	local formatted_size
	
	formatted_size=$(echo "$total_size" | awk '{
		size_length = length($1);
		if (size_length < 6) {
			printf "%.2f KB", $1 / 1024;
		} else if (size_length >=6 && size_length <=8) {
			printf "%.2f MB", $1 / 1024 /1024; 
		} else {
			printf "%.2f GB", $1 / 1024 / 1024 /1024;
		}
	}') 

	echo ""
	echo "Summary"
	echo "-------"
	echo "Total Packages: $total_packages"
	echo "Total Size: $formatted_size"
}

main() {
	echo "Package Query Tool"
	echo "=================="
	echo ""

	list_packages "$@"
	show_summary "$@"
}

main "$@"
