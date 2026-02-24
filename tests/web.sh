#!/bin/bash

source ./shared.sh

# Check if the current shell is zsh
check_zsh

# Check Docker
check_docker

# ASDF
check_asdf
check_asdf_plugin awscli
check_asdf_plugin helm
check_asdf_plugin java
check_asdf_plugin nodejs
check_asdf_plugin python
check_asdf_plugin ruby
check_asdf_plugin terraform
