#!/usr/bin/env  bash
set -euo pipefail

list_repos() {
	echo "Repository Status"
	echo "================="

	local repos
	local repos_count
	repos=$(dnf repolist --all 2>/dev/null | grep -v "repo id" | sort)
	repos_count=$(echo "$repos" | wc -l)
	echo -e "${repos}\n"
	echo -e "Total repos: ${repos_count}\n"
}

main() {
	echo ""
	echo "Repository Analysis Tool"
	echo "========================"
	echo ""

	list_repos
}

main "$@"
