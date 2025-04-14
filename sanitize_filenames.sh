#!/bin/bash

cd "${1:-.}"

sanitize_filename() {
  local original="$1"

  # Extract filename and extension
  local name="${original%.*}"
  local ext="${original##*.}"

  # Handle files without an extension
  if [[ "$name" == "$original" ]]; then
    ext=""
  fi

  # Transliterate extended characters (iconv may not do all, so we back it up)
  name=$(echo "$name" | iconv -f utf-8 -t ascii//TRANSLIT)
  name=$(echo "$name" | sed -e 's/ö/o/g' -e 's/ü/u/g' -e 's/õ/o/g' -e 's/ä/a/g')

  # Replace spaces with underscores
  name=$(echo "$name" | tr ' ' '_')

  # Remove all non-alphanumeric, underscore, hyphen, and dot characters
  name=$(echo "$name" | sed 's/[^A-Za-z0-9._-]//g')

  # Convert to lowercase
  name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

  # Reassemble the filename
  if [[ -n "$ext" && "$ext" != "$name" ]]; then
    echo "$name.$ext"
  else
    echo "$name"
  fi
}

export -f sanitize_filename

find . -type f | while read -r filepath; do
  dir=$(dirname "$filepath")
  filename=$(basename "$filepath")
  newname=$(sanitize_filename "$filename")
  if [[ "$filename" != "$newname" ]]; then
    if [[ ! -e "$dir/$newname" ]]; then
      echo "Renaming: $filename -> $newname"
      mv "$filepath" "$dir/$newname"
    else
      echo "Skipping: $newname already exists"
    fi
  fi
done