#!/bin/bash

# Check if a folder path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <folder_path>"
  exit 1
fi

folder_path="$1"

# Check if the provided folder exists
if [ ! -d "$folder_path" ]; then
  echo "Folder '$folder_path' does not exist."
  exit 1
fi

# Declare an associative array to group documents with the same organization name
declare -A documents

# Iterate over each PDF file in the folder
for pdf_file in "$folder_path"/*.pdf; do
  # Extract the file name without extension
  file_name=$(basename "$pdf_file" .pdf)

  # Convert the PDF to text and extract the organization name
  organisation_name=$(pdftotext -layout "$pdf_file" - | grep -oP '(?<=Organisation name:\s).*')

  # Append the file name to the array element corresponding to the organization name
  documents["$organisation_name"]+=" $file_name.pdf"
done

for organisation_name in "${!documents[@]}"; do
echo "Organisation name: $organisation_name" 
echo "${documents[$organisation_name]}"
echo 

done
