#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title all images to webp
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author pussitaja
# @raycast.authorURL https://raycast.com/pussitaja

# Get Finder's current folder path
DIR=$(osascript -e 'tell application "Finder" to set thePath to POSIX path of (insertion location as alias)')

# Call your script with that directory
./shell-scripts/convert_images_to_webp.sh "$DIR"