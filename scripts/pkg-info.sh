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
		echo "${PACKAGE} not found"
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
		echo "${PACKAGE} not installed. File list unavailable."
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
		echo "Change log unavailable."
		echo ""
	fi
}

show_dependencies() {
    echo ""
    echo "Dependencies (Direct)"
    echo "---------------------"
    if rpm -q "$PACKAGE" >/dev/null 2>&1; then
        rpm -qR "$PACKAGE" | grep -v "^rpmlib(" | head -10
        
        local count
        count=$(rpm -qR "$PACKAGE" | grep -v "^rpmlib(" | wc -l)
        if [[ $count -gt 10 ]]; then
            echo "... and $((count - 10)) more dependencies."
        fi
    else
		dnf repoquery --requires "$PACKAGE" 2>/dev/null | head -10 || echo "Dependencies unavailable"
    fi
    echo ""
}
main() {
	echo "Package Info: $PACKAGE"
	echo "================================="
	echo ""

	show_metadata "$@"
	show_files "$@"
	show_changelog "$@"
	show_dependencies "$@"
}

main "$@"
