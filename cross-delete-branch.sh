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
  PR,print-service \
  PY,payment-service \
  CS, crypto-service
)

cd $(mktemp -d)

for application in "${APPLICATIONS[@]}"
do
  SHORTCODE=$(echo -n "$application" | cut -d, -f1)
  NAME=$(echo -n "$application" | cut -d, -f2)

  git clone --depth=1 --quiet "git@github.com:uk-gov-dft/$NAME.git" > /dev/null
  cd "$NAME"
  
  git branch -D "$BRANCH" > /dev/null || :
  git push origin --delete "$BRANCH" || :

  echo "Branch ($BRANCH) deleted."

  cd ..

done
