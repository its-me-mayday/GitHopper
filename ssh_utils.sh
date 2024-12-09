#!/bin/bash

setup_credentials() {
  echo "Setting up SSH credentials..."
  ssh-add -L || ssh-agent bash -c 'ssh-add ~/.ssh/id_rsa'
}