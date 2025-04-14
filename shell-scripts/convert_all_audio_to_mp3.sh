#!/bin/bash

# Change to directory passed from Raycast or default to current
cd "${1:-.}"

# Create _original folder if it doesn't exist
mkdir -p _original

# Create a log file to capture errors
log_file="conversion_log.txt"
echo "Conversion Log - $(date)" > "$log_file"
echo "--------------------------------" >> "$log_file"

# List of audio extensions to convert (case-insensitive)
extensions=("wav" "flac" "m4a" "aac" "ogg" "aiff" "wma")

# Loop over matching files
for ext in "${extensions[@]}"; do
  find . -maxdepth 1 -type f -iname "*.${ext}" | while read -r file; do
    # Safely handle file names with spaces or special characters
    base="${file%.*}"
    output="${base}.mp3"

    # Lowercase extension (macOS Bash 3.2 safe)
    ext_lc=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    if [[ ! -f "$output" ]]; then
      echo "Converting: \"$file\" → \"$output\""

      # Extract metadata once
      title=$(ffmpeg -i "$file" 2>&1 | grep -i 'title' | head -n 1 | sed 's/.*: //')
      artist=$(ffmpeg -i "$file" 2>&1 | grep -i 'artist' | head -n 1 | sed 's/.*: //')
      album=$(ffmpeg -i "$file" 2>&1 | grep -i 'album' | head -n 1 | sed 's/.*: //')

      # Use ffmpeg to convert and copy metadata
      ffmpeg -loglevel error -y -i "$file" \
        -codec:a libmp3lame -qscale:a 2 \
        -id3v2_version 3 \
        -metadata title="$title" \
        -metadata artist="$artist" \
        -metadata album="$album" \
        "$output" >> "$log_file" 2>&1

      # If conversion succeeded, move original
      if [[ -f "$output" ]]; then
        echo "Moving original to _original/"
        mv "$file" "_original/"
      else
        echo "❌ Conversion failed for \"$file\"" >> "$log_file"
      fi
    else
      echo "Skipping: \"$output\" already exists"
    fi
  done
done

echo "Log file saved to $log_file"
