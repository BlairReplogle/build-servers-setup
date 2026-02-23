# Web

A guide for setting up a build server for web

## ZSH

`ZSH` is not the default shell on ubuntu. It will need to be installed and set as the default for the user account
```
sudo apt install zsh
chsh -s $(which zsh)
```

## Dependencies

Its dangerous to go alone - take these
```
sudo apt install curl
sudo apt install git
sudo apt install chromium
```

## Shell Configuration

We're gonna need this later. Create a `zprofile`
```
dotzprofile="${ZDOTDIR:-$HOME}/.zprofile"
touch "$dotzprofile"
```

## Staging Area

Create a temporary folder to download scripts and source to
```
mkdir -p $HOME/setup && cd $HOME/setup
```

## Docker

[Get Docker](https://get.docker.com)

```
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo usermod -aG docker $USER
```

## ASDF

Download latest release of asdf (pick the right version and architecture)
```
curl -fsSL https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-arm64.tar.gz -o asdf-v0.18.tar.gz
tar -xzf asdf-v0.18.tar.gz
```

Copy the executable to directory in PATH
```
sudo cp $HOME/setup/asdf /usr/local/bin
```

Add the initialization command to `zprofile`
```
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> "$dotzprofile"
```

## ASDF Plugins

[awscli](https://github.com/MetrixMike/asdf-awscli)

Dependencies: curl, git, bash, tar, unzip, coreutils
```
asdf plugin add awscli
asdf install awscli latest
asdf set -u awscli latest
aws --version
```

[helm](https://github.com/Antiarchitect/asdf-helm)

Dependencies:
```
asdf plugin add helm
asdf install helm latest
asdf set -u helm latest
helm version
```

[java](https://github.com/halcyon/asdf-java)

Dependencies: bash, curl, unzip, jq
```
asdf plugin add java
asdf install java latest:zulu-17
asdf set -u java latest:zulu-17
java --version
```

[nodejs](https://github.com/asdf-vm/asdf-nodejs)

Dependencies: libatomic1
```
asdf plugin add nodejs
asdf install nodejs latest
asdf set -u nodejs latest
node -v
```

[ruby](https://github.com/asdf-vm/asdf-ruby)

Dependencies: ruby-build, ruby-dev, build-essential, libffi-dev, libtool
build-essential autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev rustc
```
asdf plugin add ruby
asdf install ruby latest
asdf set -u ruby latest
ruby -v
```

[terraform](https://github.com/asdf-community/asdf-hashicorp)

Dependencies:
```
asdf plugin add terraform
asdf install terraform latest
asdf set -u terraform latest
terraform -v
```

[python](https://github.com/asdf-community/asdf-python)

[Dependencies](https://github.com/asdf-community/asdf-python?tab=readme-ov-file#ubuntu): make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```
asdf plugin add python
asdf install python latest
asdf set -u python latest
python --version
```
