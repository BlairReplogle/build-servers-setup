#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"
source "$SCRIPTPATH"/shared.sh

check_homebrew() {
	print_header "Checking homebrew..."

	# Homebrew
	if ! command -v brew &> /dev/null; then
		print_failure "Homebrew is not installed"
	fi

	brew --version
	print_success "Homebrew is installed" 1
}

# Check if Android SDK command line tools are installed
check_android_command_line_tools(){
	print_header "Checking Android Command Line Tools Installation..."

	# Check for Android SDK location
	if [ -z "$ANDROID_HOME" ]; then
		print_failure "ANDROID_HOME environment variable is not set"
	else
		print_success "ANDROID_HOME is set to: $ANDROID_HOME"
	fi

	# Check for common Android tools
	cmdline_tools=(
		# cmdline tools
		"avdmanager"
		"sdkmanager"
		# platform tools
		"adb"
		"fastboot"
		# emulator
		"crashreport"
		"emulator"
	)

	for tool in "${cmdline_tools[@]}"; do
		if command -v "$tool" &> /dev/null; then
			tool_path=$(which $tool 2>&1 | head -n 1)
			print_success "$tool is installed - $tool_path"
		else
			print_failure "$tool is NOT found in PATH"
		fi
	done

	# Check if directories exist
	directories=(
		"$ANDROID_HOME/cmdline-tools/latest"
		"$ANDROID_HOME/platform-tools"
	)

	for dir in "${directories[@]}"; do
		if [ -d "$dir" ]; then
			tool_path=$(which $tool 2>&1 | head -n 1)
			print_success "directory $dir exists"
		else
			print_failure "directory $dir does NOT exist"
		fi
	done

	print_success "Android environment setup correctly" 1
}

check_xcode() {
	print_header "Xcode Environment Check"

	if [[ -e "/Library/Developer/CommandLineTools/usr/bin/git" ]]; then
		echo "Command line tools /Library/Developer/CommandLineTools"
		print_success "Xcode command line tools installed"
	else
		print_failure "Xcode command line tools NOT installed"
	fi

	# 1. Check if Xcode Command Line Tools are installed
	if xcode-select -p &> /dev/null; then
		echo "Xcode command line tools: $(xcode-select -p)"
		print_success "Xcode command line tools installed"
	else
		print_failure "Xcode command line tools NOT installed"
	fi

	# 2. Check if xcodes is installed
	if command -v xcodes &> /dev/null; then
		echo "Xcodes version: $(xcodes version)"
		print_success "Xcodes is installed"
	else
		print_failure "Xcodes is NOT installed"
	fi

	versions=$(xcodes installed | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | sort -u)
	if [ -z "$versions" ]; then
		print_failure "No Xcode versions found. Please install Xcode."
	fi

	while IFS= read -r version; do
		# Switch to the specific version
		echo "Switching to Xcode $version..."
		version_path="$(xcodes installed "$version")/Contents/Developer"

		if [ -e "$version_path" ]; then
			print_success "Xcode found at path: $version_path"
		else
			print_failure "Xcode not found at path: $version_path"
		fi

		DEVELOPER_DIR="$version_path"
		if xcodebuild -license status &> /dev/null; then
			print_success "License agreement accepted"
		else
			print_failure "Xcode license agreement not accepted"
		fi

		sdk_path=$(xcrun --sdk iphoneos --show-sdk-path 2>/dev/null)
		if [ -d "$sdk_path" ]; then
			print_success "iOS SDK installed"
		else
			print_failure "iOS SDK not installed for xcode $version_path"
		fi
	done <<< "$versions"

	print_success "Xcode environment setup correctly" 1
}

# ZSH
check_zsh

# Homebrew
check_homebrew

# ASDF
check_asdf
check_asdf_plugin awscli
check_asdf_plugin java
check_asdf_plugin nodejs
check_asdf_plugin python
check_asdf_plugin ruby
check_asdf_plugin terraform

# Android
check_android_command_line_tools

# Xcode
check_xcode
