#! /bin/bash


$(aws ecr get-login --no-include-email --region eu-west-2)

export PATTERN=".*github.com[\/\:]+([^\/]+)\/([^\.]+)(\.git)?"
export URL=$(git config --get remote.origin.url)
export USER=$(sed -r "s/$PATTERN/\1/" <<< "$URL")
export REPO=$(sed -r "s/$PATTERN/\2/" <<< "$URL")
export VERSION=$(git describe --abbrev=0)
export BRANCH=$(git rev-parse --abbrev-ref HEAD)

export REPO=${APP_NAME:-$REPO}

echo "REPO = $REPO"

export DOCKER_IMAGE_NAME="$USER/$REPO:$VERSION-${BRANCH/\//_}"
export JAR_NAME="$REPO-$VERSION-${BRANCH/\//_}.jar"

if [ "$BRANCH_NAME" == "develop" ]; 
then
  export JAR_NAME="$REPO-$VERSION-SNAPSHOT.jar"
  docker build -t "$DOCKER_IMAGE_NAME" -t "$USER/$REPO:latest" --build-arg JAR_NAME="$JAR_NAME" .
  docker tag "$USER/$REPO:latest" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$USER/$REPO:latest"
  docker tag "$DOCKER_IMAGE_NAME" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"
  docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$USER/$REPO:latest"
  docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"
elif  [ "$BRANCH_NAME" == "master" ];
then
  export JAR_NAME="$REPO-$VERSION.jar"
  docker build -t "${DOCKER_IMAGE_NAME/-master/}" --build-arg JAR_NAME="$JAR_NAME" .
  docker tag "${DOCKER_IMAGE_NAME/-master/}" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/${DOCKER_IMAGE_NAME/-master/}"
  docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/${DOCKER_IMAGE_NAME/-master/}"
else
  # On branches, the JAR will usually be given a dumb name like
  #   build/libs/85-replace-badge-validation-RSLQQA2ZCSZABOKZYXQNPTHDPWVVK3Q2GZFNC6NAHMAUZJSZLWPQ-v0.25.0-bugfix_BBB-1285-replace-badge-validation.jar
  # so we use a greedy wildcard and hope that there's only a single JAR in build/libs.
  export JAR_NAME="*-$VERSION-*.jar"
  docker build -t "$DOCKER_IMAGE_NAME" --build-arg JAR_NAME="$JAR_NAME" .
  docker tag "$DOCKER_IMAGE_NAME" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"
  docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"
fi




