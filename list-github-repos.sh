#! /bin/bash
ORG="$1"
curl -s -H "Authorization: Bearer $(cat ~/.ssh/github_token)" https://api.github.com/orgs/$ORG/repos | jq '.[] | .ssh_url' | sed 's/"//g'
