#! /bin/bash

testCreatesFolderWithBadgeNumber(){
  TMP_DIR=$(mktemp -d)
  TMP_OUTPUT_DIR=$(mktemp -d)

  EXPECTED_BADGE_NUMBER="3D4D5D"
  EXPECTED_IMAGE="Image"

  (cd "$TMP_DIR" && echo "$EXPECTED_IMAGE" > "VALTECH_14092018_122014_${EXPECTED_BADGE_NUMBER}_IMAGE.jpg")

  ./prepare_images.sh "$TMP_DIR" "$TMP_OUTPUT_DIR"
    
  assertTrue "[ -d "$TMP_OUTPUT_DIR/$EXPECTED_BADGE_NUMBER" ]"

  assertTrue "[ -d "$TMP_OUTPUT_DIR/$EXPECTED_BADGE_NUMBER/artefacts" ]"

  IMAGE_FILE=$(find "$TMP_OUTPUT_DIR/$EXPECTED_BADGE_NUMBER/artefacts" -maxdepth 1 -mindepth 1 | head -n1 | xargs basename)

  IMAGE_CONTENTS=$(cat "$TMP_OUTPUT_DIR/$EXPECTED_BADGE_NUMBER/artefacts/$IMAGE_FILE")

  assertEquals "$IMAGE_CONTENTS" "$EXPECTED_IMAGE"
}

# Load and run shUnit2.
. ./shunit2-2.1.7/shunit2

