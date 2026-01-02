#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
	echo "Usage: $0 <package-name>"
	exit 2
fi

PACKAGE="$1"

show_metadata() {
	echo "Metadata"
	echo "========"
	
	if rpm -q "$PACKAGE" >/dev/null 2>&1; then
		rpm -qi "$PACKAGE"
	else
		dnf info "$PACKAGE" 2>/dev/null || \
		echo "Package not found"
		echo ""
	fi
}

main() {
	echo "Package Info: $PACKAGE"
	echo "================================="
	echo ""

	show_metadata "$@"
}

main "$@"
