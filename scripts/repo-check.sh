#!/usr/bin/env bash
set -euo pipefail

list_repos() {
	echo "Repository Status"
	echo "================="

	local repos_count
	local results_file="/tmp/repos-$$.txt"

	echo "REPO ID|STATUS|PACKAGES|ACCESS|REPO NAME" > "$results_file"
	
	dnf repolist --all 2>/dev/null | \
	grep -v "^repo id" | sort | \
	while read -r line; do
		local id=$(echo "$line" | awk '{print $1}')
		local status=$(echo "$line" | awk '{print $NF}')
		local name="${line#$id}"
		name="${name%$status}"
		name=$(echo "$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
	
		if [[ "$status" == "enabled" ]]; then
			status="✓ Enabled"

			local repo_info
			repo_info=$(dnf repoinfo "$id" 2>/dev/null)

			local package_count
			package_count=$(echo "$repo_info" | grep "Available packages" | awk -F: '{print $2}' | tr -d ' ')

			local validation
			if [[ -n "$package_count" ]]; then
				validation="✓ OK"
			else
				validation="✗ Failed"
				package_count="N/A"
			fi
			echo "$id|$status|$package_count|$validation|$name" >> "$results_file"
		else
			status="✗ Disabled"
			echo "$id|$status|$package_count|$validation|$name" >> "$results_file"
		fi
	done

	column -t -s '|' < "$results_file"

	repos_count=$(tail -n +2 "$results_file" | wc -l)
	enabled_count=$(grep -c '✓ Enabled' "$results_file" || true)
	disabled_count=$(grep -c '✗ Disabled' "$results_file" || true)
	echo -e "\nTotal repos: ${repos_count}\nEnabled: ${enabled_count}\nDisabled: ${disabled_count}\n"
	rm -f "$results_file"
}

main() {
	echo ""
	echo "Repository Analysis Tool"
	echo "========================"
	echo ""

	list_repos
}

main "$@"
