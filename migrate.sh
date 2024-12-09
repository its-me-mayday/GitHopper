#!/bin/bash

if [ ! -f "/scripts/repos.yaml" ]; then
  echo "Configuration file repos.yaml not found."
  exit 1
fi

if ! command -v yq &> /dev/null; then
  echo "yq is not installed. Install yq to proceed."
  exit 1
fi

source /scripts/git_utils.sh
source /scripts/ssh_utils.sh

migrate() {
  setup_credentials

  repos=$(yq eval '.repositories' /scripts/config.yaml)

  echo "$repos" | while IFS= read -r repo; do
    from_repo=$(echo "$repo" | yq eval '.from' -)
    to_repo=$(echo "$repo" | yq eval '.to' -)

    if [[ -n "$from_repo" && -n "$to_repo" ]]; then
      sync_repo "$from_repo" "$to_repo"
    fi
  done
}

migrate