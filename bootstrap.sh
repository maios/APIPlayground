#!/bin/bash

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew"
    brew update
fi

if brew outdated | grep carthage > /dev/null ; then
    echo "Upgrading Carthage"
    brew upgrade carthage
else
    echo "Installing Carthage"
    brew install carthage
fi
