#! /bin/bash

export DOCKER_IMAGE_NAME="$(git config --get remote.origin.url | sed -r 's/.*github.com[\/\:]+([^\/]+)\/([^\.]+)(\.git)?/\1\/\2/'):$(git describe --abbrev=0)-$(git rev-parse --abbrev-ref HEAD)"
export JAR_NAME="$(git config --get remote.origin.url | sed -r 's/.*:([^\/]+)\/(.*$)/\2/')-$(git describe --abbrev=0)-$(git rev-parse --abbrev-ref HEAD).jar"

docker build -t "$DOCKER_IMAGE_NAME" --build-arg JAR_NAME="$JAR_NAME" .

$(aws ecr get-login --no-include-email --region eu-west-2)

docker tag "$DOCKER_IMAGE_NAME" "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"

docker push "536084723381.dkr.ecr.eu-west-2.amazonaws.com/$DOCKER_IMAGE_NAME"
