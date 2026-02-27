#!/bin/bash

# Define reusable functions
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m' # No Color

print_header() {
	local header_text="$1"
	local text_length=${#header_text}

	# Limit to 80 characters total
	# Account for the text and ensure we don't exceed 80 chars
	if [ "$text_length" -gt 78 ]; then
		header_text="${header_text:0:78}"
		text_length=78
	fi

	# Print line of equal signs
	printf '%*s\n' "$text_length" ' ' | tr ' ' '='

	# Print header text
	echo "$header_text"

	# Print another line of equal signs
	printf '%*s\n' "$text_length" ' ' | tr ' ' '='
}

# Function to print green text
print_green() {
	echo -e "${GREEN}$1${NOCOLOR}"
}

print_success() {
	print_green "✓ $1"
	[ -n "$2" ] && [ "$2" -eq 1 ] && printf "\n"
}

# Function to print red text
print_red() {
	echo -e "${RED}$1${NOCOLOR}"
}

print_failure() {
	print_red "✗ $1"
	exit 1
}

# ZSH
check_zsh() {
	print_header "Checking zsh..."

	echo "PATH: $PATH"
	echo "SHELL: $SHELL"
	echo "BASH_VERSION: $BASH_VERSION"
	echo "ZSH_VERSION: $ZSH_VERSION"

	# if [ ! -n "$ZSH_VERSION" ]; then
	# 	echo "ZSH_VERSION: $ZSH_VERSION"
	# 	print_success "Current shell is zsh"
	# else
	# 	print_failure "Current shell is not zsh. Current shell: $SHELL"
	# fi
}

# Docker
check_docker() {
	print_header "Checking docker..."

	if ! command -v docker &> /dev/null; then
		print_failure "Docker is not installed"
	fi

	print_success "Docker is installed"

	if ! docker ps &> /dev/null; then
		print_failure "Docker is installed but the daemon is not running"
	fi

	docker --version
	print_success "Docker daemon is running" 1
}

# ASDF
check_asdf() {
	print_header "Checking asdf..."

	if ! command -v asdf &> /dev/null; then
		print_failure "ASDF is not installed"
	fi

	asdf --version
	print_success "ASDF is installed" 1
}

check_asdf_plugin() {
	print_header "Checking asdf $1 plugin..."

	if ! asdf plugin list | grep -q "^${1}$"; then
		print_failure "$1 plugin is not installed"
	fi

	asdf list $1

	case "$1" in
	"awscli")
		aws --version
		;;
	"helm")
		helm version
		;;
	"java")
		java --version
		;;
	"nodejs")
		node -v
		;;
	"ruby")
		ruby -v
		;;
	"terraform")
		terraform -v
		;;
	"python")
		python --version
		;;
	*)
		echo "Unknown command: $1"
		echo "Use '$0 help' for available commands"
		;;
	esac

	print_success "ASDF: $1 plugin is installed" 1
}
