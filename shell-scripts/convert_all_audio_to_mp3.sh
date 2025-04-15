#!/bin/bash

# Use the current directory or specified one
cd "${1:-.}" || { echo "❌ Failed to enter directory"; exit 1; }

# Create _original folder if needed
mkdir -p _original

# Set up log file
log_file="conversion_log.txt"
echo "Conversion Log - $(date)" > "$log_file"
echo "------------------------------" >> "$log_file"

# Extensions to convert (case-insensitive)
extensions=("flac" "wav" "m4a" "aac" "ogg" "aiff" "wma")

# Build find command safely
files=()
for ext in "${extensions[@]}"; do
  while IFS= read -r -d $'\0' file; do
    files+=("$file")
  done < <(find . -maxdepth 1 -type f \( -iname "*.${ext}" \) -print0)
done

# Check if files were found
if [[ ${#files[@]} -eq 0 ]]; then
  echo "🚫 No audio files found in: $(pwd)"
  exit 0
fi

echo "🎧 Found ${#files[@]} audio files."

# Process each file
for file in "${files[@]}"; do
  base="${file%.*}"
  output="${base}.mp3"

  echo "🔄 Converting \"$file\" → \"$output\""

  # Extract metadata
  metadata=$(ffmpeg -i "$file" -f ffmetadata - 2>/dev/null)
  title=$(echo "$metadata" | grep -i '^title=' | cut -d= -f2-)
  artist=$(echo "$metadata" | grep -i '^artist=' | cut -d= -f2-)
  album=$(echo "$metadata" | grep -i '^album=' | cut -d= -f2-)

  # Convert
  ffmpeg -loglevel error -y -i "$file" \
    -codec:a libmp3lame -qscale:a 2 \
    -id3v2_version 3 \
    -metadata title="$title" \
    -metadata artist="$artist" \
    -metadata album="$album" \
    "$output" >> "$log_file" 2>&1

  if [[ -f "$output" ]]; then
    echo "✅ Success: $file"
    mv "$file" _original/
  else
    echo "❌ Failed: $file" >> "$log_file"
  fi
done

echo "🎉 All done. Log saved to: $log_file"
