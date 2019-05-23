#! /bin/bash
set -e

# cross-merge-branches.sh release/44 master --commit
# cross-merge-branches.sh release/44 develop --commit

FROM_BRANCH="$1"
TO_BRANCH="$2"
COMMIT="$3"

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
  CS,crypto-service
)

cd $(mktemp -d)

for application in "${APPLICATIONS[@]}"
do
  SHORTCODE=$(echo -n "$application" | cut -d, -f1)
  NAME=$(echo -n "$application" | cut -d, -f2)

  echo "Cloning $NAME ..."

  git clone --quiet "git@github.com:uk-gov-dft/$NAME.git" > /dev/null
  cd "$NAME"
  git checkout -q "$TO_BRANCH" > /dev/null
  git pull --no-edit origin "$FROM_BRANCH"

  if [ "$COMMIT" == "--commit" ]; then
    git push origin "$TO_BRANCH"
  fi

  cd ..

done
