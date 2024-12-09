#!/bin/bash

clone_repo() {
  local repo_url=$1
  local dir_name=$(basename "$repo_url" .git)

  if [ ! -d "$dir_name" ]; then
    echo "Cloning repository $repo_url..."
    git clone "$repo_url"
  else
    echo "Repository $dir_name already exists, proceeding with pull..."
    cd "$dir_name" && git pull origin main && cd ..
  fi
}

sync_repo() {
  local source_repo=$1
  local target_repo=$2

  local source_name=$(basename "$source_repo" .git)
  echo "Syncing from $source_name to $target_repo"

  clone_repo "$source_repo"
  cd "$source_name" || exit 1

  git remote add destination "$target_repo" 2>/dev/null || echo "Remote destination already configured"

  git fetch destination
  git push destination main

  cd .. || exit 1
  echo "Sync complete!"
}