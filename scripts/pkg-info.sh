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

show_files() {
	echo ""
	echo "Files (Preview)"
	echo "---------------"
	if rpm -q "$PACKAGE" >/dev/null 2>&1; then

		local count
		count=$(rpm -ql "$PACKAGE" | wc -l)

		rpm -ql "$PACKAGE" | head -10 || true

		if [[ $count -gt 10 ]]; then
			echo "... and $((count - 10)) more files."
			echo ""
		fi
	else
		echo "${PACKAGE} not installed (file list unavailable)"
	fi
}

show_changelog() {
	echo ""
	echo "Recent Changes"
	echo "--------------"

	if rpm -q "$PACKAGE" >/dev/null 2>&1; then
		rpm -q --changelog "$PACKAGE" | head -15 || true
		echo ""
	else
		echo "${PACKAGE} not installed (change log unavailable)"
		echo ""
	fi
}

main() {
	echo "Package Info: $PACKAGE"
	echo "================================="
	echo ""

	show_metadata "$@"
	show_files "$@"
	show_changelog "$@"
}

main "$@"
