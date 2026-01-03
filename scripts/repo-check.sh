#!/usr/bin/env  bash
set -euo pipefail

list_repos() {
	echo "Repository Status"
	echo "================="

	dnf repolist --all 2>/dev/null | grep -v "repo id" |sort
}

main() {
	echo "Repository Analysis Tool"
	echo "========================"
	echo ""

	list_repos
}

main "$@"
