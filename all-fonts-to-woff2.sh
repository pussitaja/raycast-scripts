#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title all to woff2
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author pussitaja
# @raycast.authorURL https://raycast.com/pussitaja

# Get Finder's current folder path
DIR=$(osascript -e 'tell application "Finder" to set thePath to POSIX path of (insertion location as alias)')

# Call your script with that directory
./shell-scripts/convert_fonts_to_woff2.sh "$DIR"