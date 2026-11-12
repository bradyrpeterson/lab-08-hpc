#!/bin/bash
set -euo pipefail

bucket="$1"
book_dir="$2"

# Create the book directory if it doesn't exist
mkdir -p "$book_dir"

# Copy only the .txt files from the bucket
aws s3 cp "s3://$bucket" "$book_dir" --recursive --exclude "*" --include "*.txt"

# Turn the directory into an absolute path
book_dir="$(realpath "$book_dir")"

# Write the header, then the sorted absolute paths
echo "File path" > book_list.txt
find "$book_dir" -type f -name "*.txt" | sort >> book_list.txt

# Count the books, skipping the header line
echo "Wrote $(tail -n +2 book_list.txt | wc -l) book files to book_list.txt"
