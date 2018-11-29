#! /bin/bash

REPO="$1"
TAG="$2"

if [[ -z "$REPO" ]]; then
  echo "Must supply repo name"
  exit 1
fi

if [[ -z "$TAG" ]]; then
  echo "Must supply tag name"
  exit 1
fi


cd $(mktemp -d)

git clone --depth=1 --quiet "https://$GITHUB_TOKEN:x-oauth-basic@github.com/uk-gov-dft/$REPO.git" > /dev/null
cd "$REPO"

git push --delete origin "$TAG" || :
git tag -d "$TAG" || :

echo "Tag ($TAG) deleted from $REPO"
