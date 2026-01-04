# Package Management Dashboard

A collection of shell-based tools for comprehensive package management analysis on RHEL-based Linux distributions, designed to provide system administrators with actionable insights into package ecosystems.

## Overview

This project demonstrates proficiency in Linux system administration through automated package management workflows. The tools leverage DNF5/DNF, YUM, and RPM to query, analyze, and report on system package states, dependencies, and repository health.

## Technical Focus

- **Package Management**: Deep understanding of DNF/YUM/RPM architecture and repository management
- **Shell Scripting**: Bash automation following industry best practices (error handling, modularity, POSIX compliance)
- **System Administration**: Real-world operational tooling for RHEL/CentOS/Rocky/AlmaLinux environments
- **Data Processing**: Parsing and formatting command output for human-readable and machine-parseable reports

## Target Platform

- Fedora 43+ (DNF5)
- RHEL 8/9 (DNF4)
- CentOS Stream
- Rocky Linux
- AlmaLinux

## Implemented Tools

### pkg-query.sh

Query and filter installed packages with summary statistics.

- Lists all installed packages with metadata (version, architecture, size, install date)
- Case-insensitive filtering by package name
- Human-readable size formatting (KB/MB/GB)
- Summary statistics showing total package count and disk usage

### pkg-search.sh

Search for packages across configured repositories.

- Searches available packages by name and description
- Displays installation status (installed vs available)
- Shows package summaries
- DNF5-compatible implementation

### pkg-info.sh

Comprehensive package information display.

- Detailed metadata for installed and available packages
- File listing with preview and count
- Recent changelog entries
- Direct dependency analysis
- Handles both RPM (local) and DNF (remote) queries

### repo-check.sh

Repository analysis and validation.

- Lists all configured repositories (enabled/disabled)
- Package count per repository
- Validates repository accessibility
- Summary statistics (enabled/disabled/total)
- DNF5 `repoinfo` integration

## Core Capabilities

The implemented tools address common sysadmin challenges:

- Package inventory and metadata queries
- Dependency analysis (direct dependencies)
- Repository validation and health checks
- Package search across repositories
- Installation status tracking

## Key Technologies

- **Bash**: Primary scripting language with strict error handling
- **DNF5/DNF4**: High-level package managers for repository queries and package metadata
- **RPM**: Low-level package database queries for installed packages
- **awk/sed/grep**: Text processing for command output parsing
- **column**: Table formatting for human-readable output

## Development Practices

- Strict error handling (`set -euo pipefail`)
- ShellCheck validation for code quality
- Modular architecture with shared library functions
- Graceful degradation for non-root execution
- Comprehensive documentation and usage examples

## Skills Demonstrated

- **Linux Administration**: Package management, repository configuration, system auditing
- **Scripting Expertise**: Advanced Bash patterns, error handling, data parsing
- **Operational Awareness**: Security-first approach, production-ready tooling design
- **Code Quality**: Linting, consistent style, maintainable architecture

## Project Structure

```text
project-02-package-management/
├── scripts/
│   ├── pkg-query.sh      # Package listing and filtering
│   ├── pkg-search.sh     # Repository package search
│   ├── pkg-info.sh       # Detailed package information
│   └── repo-check.sh     # Repository analysis
└── README.md
```

## Usage Examples

```bash
# List all installed packages
./scripts/pkg-query.sh

# Filter packages by name
./scripts/pkg-query.sh python

# Search for available packages
./scripts/pkg-search.sh editor

# Get detailed package information
./scripts/pkg-info.sh bash

# Analyze repositories
./scripts/repo-check.sh
```
