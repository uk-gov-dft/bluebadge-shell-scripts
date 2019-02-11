#! /bin/bash



export PATTERN=".*github.com[\/\:]+([^\/]+)\/([^\.]+)(\.git)?"
export URL=$(git config --get remote.origin.url)
export USER=$(sed -r "s/$PATTERN/\1/" <<< "$URL")
export REPO=$(sed -r "s/$PATTERN/\2/" <<< "$URL")
export VERSION=$(git describe --abbrev=0)
export BRANCH=$(git rev-parse --abbrev-ref HEAD)

export REPO=${APP_NAME:-$REPO}

echo "REPO = $REPO"

export DOCKER_IMAGE_NAME="$USER/$REPO:$VERSION-$BRANCH"
export JAR_NAME="$REPO-$VERSION-$BRANCH.jar"

docker build -t "$DOCKER_IMAGE_NAME" --build-arg JAR_NAME="$JAR_NAME" .

$(aws ecr get-login --no-include-email --region eu-west-2)

docker tag "$DOCKER_IMAGE_NAME" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"

docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"

if [ "$BRANCH_NAME" == "develop" ] || [ "$BRANCH_NAME" == "push-to-docker-registry"  ]; 
then
  docker tag "$USER/$REPO:latest" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$USER/$REPO:latest"
  docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$USER/$REPO:latest"
fi

if [ "$BRANCH_NAME" == "master" ]; 
then
  docker tag "$USER/$REPO:stable" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$USER/$REPO:stable"
  docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$USER/$REPO:stable"
fi
