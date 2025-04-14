#!/bin/bash

# Change to directory passed from Raycast or default to current
cd "${1:-.}"

# Create _original folder if it doesn't exist
mkdir -p _original

# List of image extensions to convert (case-insensitive)
extensions=("jpg" "jpeg" "png" "gif" "tiff" "bmp" "heic")

# Loop over matching files
for ext in "${extensions[@]}"; do
  find . -maxdepth 1 -type f -iname "*.${ext}" | while read -r file; do
    base="${file%.*}"
    output="${base}.webp"

    # Lowercase extension (macOS Bash 3.2 safe)
    ext_lc=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    if [[ ! -f "$output" ]]; then
      echo "Converting: $file → $output"

      if [[ "$ext_lc" == "heic" ]]; then
        # Use ImageMagick for HEIC files
        magick "$file" "$output"
      else
        # Use cwebp for everything else
        cwebp -quiet "$file" -o "$output"
      fi

      # If conversion succeeded, move the original file
      if [[ -f "$output" ]]; then
        echo "Moving original to _original/"
        mv "$file" "_original/"
      else
        echo "❌ Conversion failed for $file"
      fi
    else
      echo "Skipping: $output already exists"
    fi
  done
done
