#!/usr/bin/env bash
set -euo pipefail

main_query=$(rpm -qa --queryformat '%{NAME}|%{VERSION}-%{RELEASE}|%{ARCH}|%{SIZE}|%{INSTALLTIME:date}\n' | grep -i "${1:-}" || true )

show_summary() {
	local total_packages
	local total_size	
	local formatted_size

	if [[ -z "$main_query" ]]; then
		
		total_packages=0
		formatted_size=0
	else
		total_packages=$(echo "$main_query" | wc -l)

	 	total_size=$(echo "$main_query" | awk -F'|' '{sum += $4} END {print sum}')
		
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
	fi 

	echo ""
	echo "Summary"
	echo "-------"
	echo "Total Packages: $total_packages"
	echo "Total Size: $formatted_size"
}

main() {
	echo ""
	echo "Package Query Tool"
	echo "=================="
	echo ""

	if [[ -z "$main_query" ]]; then 
		echo "No match found" 
	else 
		echo "$main_query" | sort | \
		column -t -s '|' -N "PACKAGE,VERSION,ARCH,SIZE(bytes),INSTALLED"
	fi

	show_summary "$@"
	echo ""
}

main "$@"
