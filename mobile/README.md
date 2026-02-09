# Mobile

A guide for setting up a build server for mobile (iOS and Android).

## Shell Configuration

We're gonna need this later. Create a `zprofile`
```
dotzprofile="${ZDOTDIR:-$HOME}/.zprofile"
touch "$dotzprofile"
```

## Homebrew

Install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add the initialization line to `zprofile`
```
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$dotzprofile"

# source changes
source "$dotzprofile"
```

Install dependencies with homebrew
```
brew install ruby-build
brew install xcodes
brew install imagemagick
```

## ASDF

Install ASDF
```
brew install coreutils curl git asdf
```

Add the initialization line to `zprofile`
```
echo '. $(brew --prefix asdf)/libexec/asdf.sh' >> "$dotzprofile"

# source changes
source "$dotzprofile"
```

Install required plugins
```
asdf plugin add awscli
asdf plugin add java
asdf plugin add nodejs
asdf plugin add ruby
asdf plugin add terraform
asdf plugin add python
```

Install currently used versions
```
asdf install awscli 2.15.19
asdf install java zulu-17.46.19
asdf install nodejs 20.19.5
asdf install ruby 3.3.7
asdf install terraform 1.7.3
asdf install python 3.11.8
```

Set global versions of ruby and java
```
asdf set -u ruby 3.3.7
asdf set -u java zulu-17.46.19
```

## Android

Create a directory for the android home
```
export ANDROID_HOME=$HOME/Library/Android/sdk
mkdir -p $ANDROID_HOME
```

Navigate to https://developer.android.com/studio#command-tools

Download the latest version of command line tools for mac

Unzip into android home / cmdline-tools
```
unzip ~/Downloads/commandlinetools-mac-14742923.zip -d $ANDROID_HOME/cmdline-tools
```

Rename the folder
```
mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
```

Navigate to https://developer.android.com/tools/releases/platform-tools

Download the latest version of platform tools for mac

Unzip into android home
```
unzip ~/Downloads/platform-tools-latest-darwin.zip -d $ANDROID_HOME
```

Add environment variable configurations to `zprofile`
```
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> "$dotzprofile"
echo 'export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH' >> "$dotzprofile"
echo 'export PATH=$ANDROID_HOME/platform-tools:$PATH' >> "$dotzprofile"

# source changes into current shell
source "$dotzprofile"
```

Accept licenses
```
sdkmanager --licenses
```

Install build-tools and platforms

Once licenses are accepted gradle can do this for you during a build. But it would be good to pre-install the build-tools and platforms needed by your project.
```
sdkmanager --install "build-tools;35.0.0"
sdkmanager --install "platforms;android-34"
```

## Xcode

Navigate to https://developer.apple.com/download/applications

Download the required versions[s] of xcode and unxip them

Rename based on version. ex: "Xcode_26.2.0" move to /Applications

Install Xcode command line tools (homebrew already does this)
```
xcode-select --install
```

Select default xcode
```
sudo xcode-select -s /Applications/Xcode_26.2.0.app/Contents/Developer

# or with Xcode's
xcodes select 26.2.0
```

Accept licenses
```
sudo xcodebuild -license accept
```

Run first launch
```
xcodebuild -runFirstLaunch
```

Download all platforms for the version of Xcode you selected (you could also do this piece by piece if you only need iOS and not tvOS / watchOS / visionOS )
```
xcodebuild -downloadAllPlatforms
```

