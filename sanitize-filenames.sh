#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title sanitize
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author pussitaja
# @raycast.authorURL https://raycast.com/pussitaja

# Get the current Finder directory
DIR=$(osascript -e 'tell application "Finder" to set thePath to POSIX path of (insertion location as alias)')

# Run the real sanitization script
./shell-scripts/sanitize_filenames.sh "$DIR"