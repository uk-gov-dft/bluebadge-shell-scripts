#! /bin/bash

IMG_PATH="$1"
OUTPUT_PATH="$2"

if [ -z "$IMG_PATH" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Must specify image path and output path"
    exit 1
fi

for image in "$IMG_PATH"/*.jpg; do
  echo "$image $IMG_PATH $OUTPUT_PATH"  
  BADGE_NUMBER=$(echo "$image" | cut -d_ -f4)
  mkdir -p "$OUTPUT_PATH/$BADGE_NUMBER/artefacts"
  echo "HERE $(realpath "$image")"
  cp "$(realpath "$image")" "$OUTPUT_PATH/$BADGE_NUMBER/artefacts/$BADGE_NUMBER-thumbnail.jpg"

done
