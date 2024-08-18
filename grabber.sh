#!/bin/bash

# Check if a username is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <user_name>"
    exit 1
fi

USER=$1
PAGE=1
PER_PAGE=100
REPOS_LIST=()

# Fetch all repositories across all pages
while : ; do
  RESPONSE=$(curl -s "https://api.github.com/users/$USER/repos?page=$PAGE&per_page=$PER_PAGE" | grep clone_url | awk '{print $2}' | sed 's/"\(.*\)",/\1/')
  
  # Break if no more repositories are found
  if [ -z "$RESPONSE" ]; then
    break
  fi

  # Accumulate repositories in the list
  REPOS_LIST+=($RESPONSE)
  
  # Increment page number
  PAGE=$((PAGE + 1))
done

if [ ${#REPOS_LIST[@]} -eq 0 ]; then
  echo "No repositories found for user: $USER"
  exit 1
fi

# Clone or update repositories
for repo in "${REPOS_LIST[@]}"; do
  repo_name=${repo%.git}
  repo_name=${repo_name#https://github.com/$USER/}

  if [ -d "$repo_name" ]; then
    echo "Updating repository: $repo_name"
    cd $repo_name
    git pull
    cd ..
  else
    echo "Cloning repository: $repo_name"
    git clone $repo
  fi
done

    git clone $repo;
fi

done;