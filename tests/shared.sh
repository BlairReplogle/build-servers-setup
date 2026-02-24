#!/bin/bash

# Define reusable functions
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m' # No Color

# Function to print green text
print_green() {
	echo -e "${GREEN}$1${NOCOLOR}"
}

print_success() {
	print_green "✓ $1"
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
	if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
		print_failure "Current shell is not zsh. Current shell: $SHELL"
	fi

	print_success "Shell is zsh"
}

# Docker
check_docker() {
	if ! command -v docker &> /dev/null; then
		print_failure "Docker is not installed"
	fi

	print_success "Docker is installed"

	if ! docker ps &> /dev/null; then
		print_failure "Docker is installed but the daemon is not running"
	fi

	print_success "Docker daemon is running"
	docker --version
}

# ASDF
check_asdf() {
	if ! command -v asdf &> /dev/null; then
		print_failure "ASDF is not installed"
	fi

	print_success "ASDF is installed"
	asdf --version
}

check_asdf_plugin(){
	if ! asdf plugin list | grep -q "^${1}$"; then
		print_failure "$1 plugin is not installed"
	fi

	print_success "ASDF: $1 plugin is installed"
	asdf list $1
}
