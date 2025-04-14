#!/bin/bash

# Change to directory passed from Raycast or default to current
cd "${1:-.}"

# Create _original folder if it doesn't exist
mkdir -p _original

# Create a log file to capture errors
log_file="font_conversion_log.txt"
echo "Font Conversion Log - $(date)" > "$log_file"
echo "--------------------------------" >> "$log_file"

# List of font extensions to convert (case-insensitive)
extensions=("ttf" "otf")

# Loop over matching files
for ext in "${extensions[@]}"; do
  find . -maxdepth 1 -type f -iname "*.${ext}" | while read -r file; do
    # Safely handle file names with spaces or special characters
    base="${file%.*}"
    output="${base}.woff2"

    if [[ ! -f "$output" ]]; then
      echo "Converting: \"$file\" → \"$output\""

      # Use woff2 tool to convert font
      woff2_compress "$file" >> "$log_file" 2>&1

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
