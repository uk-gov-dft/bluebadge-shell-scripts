#! /bin/bash
set -e

BRANCH="$1"
TAG="$2"

APPLICATIONS=( \
  LA,la-webapp \
  CA,citizen-webapp \
  UM,usermanagement-service \
  BB,badgemanagement-service \
  AP,applications-service \
  AZ,authorisation-service \
  MG,message-service \
  RD,referencedata-service \
)

cd $(mktemp -d)

for application in "${APPLICATIONS[@]}"
do
  SHORTCODE=$(echo -n "$application" | cut -d, -f1)
  NAME=$(echo -n "$application" | cut -d, -f2)

  git clone --quiet "https://$GITHUB_TOKEN:x-oauth-basic@github.com/uk-gov-dft/$NAME.git" > /dev/null
  cd "$NAME"
  git checkout -q "$BRANCH" > /dev/null
  
  NEXT_VERSION=$(semverit | cut -d, -f1)
  NEXT_VERSION_TYPE=$(semverit | cut -d, -f2)

  if [ ! "$NEXT_VERSION_TYPE" == "none" ]; then
    echo "$NAME - next tag: $NEXT_VERSION"

    if [ "$TAG" == "tag" ]; then
      git tag -a "$NEXT_VERSION" -m "$NEXT_VERSION"
      git push origin "$NEXT_VERSION"
    else
      echo "Dry run - not tagging"
    fi
  else
    echo "$NAME - no changes"
  fi



  cd ..

done
