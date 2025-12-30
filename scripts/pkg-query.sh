#!/usr/bin/env bash
set -euo pipefail

list_packages() {

	rpm -qa --queryformat '%{NAME}|%{VERSION}-%{RELEASE}|%{ARCH}|%{SIZE}|%{INSTALLTIME:date}\n' | \
        sort | \
        column -t -s '|' -N "PACKAGE,VERSION,ARCH,SIZE(bytes),INSTALLED"
}

show_summary(){
	local total_packages
	local total_size

	total_packages=$(rpm -qa | wc -l)

	total_size=$(rpm -qa --queryformat '%{SIZE}\n' | \
		awk '{sum += $1} END {print sum}')
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

	list_packages
	show_summary
}

main "$@"
