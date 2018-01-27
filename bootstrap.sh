#!/usr/bin/env bash

## Additional system tools
sudo apt-get update
sudo apt-get install -y git
## Recommended build env for ruby from:
## https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

## Install rbenv and rbenv-build to manage ruby environment
su - vagrant -c "git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
su - vagrant -c "echo 'export PATH=\"~/.rbenv/bin:$PATH\"' >> ~/.bash_profile"
su - vagrant -c "echo 'eval \"\$(rbenv init -)\"' >> ~/.bash_profile"
su - vagrant -c "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"

## Install Ruby 2.1.2
su - vagrant -c "rbenv install 2.1.2"
su - vagrant -c "rbenv global 2.1.2"
su - vagrant -c "rbenv rehash"
