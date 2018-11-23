#! /bin/bash

BRANCH="$1"

if [[ -z "$BRANCH" ]]; then
  echo "Must supply branch name"
  exit 1
fi

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
  git checkout "$BRANCH" > /dev/null

  echo "$NAME - $(semverit)"
  
  git log $(git tag | sed -r "s/([0-9]+\.[0-9]+\.[0-9]+$)/\1\.99999/"|sort -V|sed s/\.99999$// | tail -n1).."$BRANCH" | grep pull
  
  cd ..

done
