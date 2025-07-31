#!/bin/bash

# A script to recursively find and copy specific log files (.jsonl and .json)
# from a source directory to a destination, preserving the directory structure.

# --- Configuration ---
# Set to 1 to see which files are being copied, 0 to run silently.
VERBOSE=1

# --- Script Body ---

# Check if two arguments (source and destination directories) are provided.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    echo "Example: ./copy_logs.sh ./my_experiment_runs ./cleaned_logs"
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="$2"

# Check if the source directory exists.
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' not found."
    exit 1
fi

# Create the destination directory if it doesn't exist.
mkdir -p "$DEST_DIR"

# Use 'find' to locate all files named 'generation_log.jsonl' or ending with '_summary.json'.
# The '-o' flag means OR. The '\(' and '\)' group the conditions.
# The output is piped to a 'while read' loop to process each file path.
find "$SOURCE_DIR" -type f \( -name "generation_log.jsonl" -o -name "*_summary.json" \) | while IFS= read -r source_file_path; do
    # For each file found, determine the correct destination path.
    # This command removes the source directory prefix from the full path,
    # leaving the relative path of the file.
    # Example: /path/to/source/benchmark1/problem1/log.jsonl -> benchmark1/problem1/log.jsonl
    relative_path="${source_file_path#$SOURCE_DIR/}"

    # Construct the full destination path for the file.
    destination_file_path="$DEST_DIR/$relative_path"

    # Get the directory part of the destination file path.
    # Example: /path/to/dest/benchmark1/problem1/log.jsonl -> /path/to/dest/benchmark1/problem1
    destination_dir=$(dirname "$destination_file_path")

    # Create the corresponding directory structure in the destination.
    # The '-p' flag ensures that parent directories are created as needed
    # and doesn't throw an error if the directory already exists.
    mkdir -p "$destination_dir"

    # Copy the file from the source to the destination.
    cp "$source_file_path" "$destination_file_path"

    # If verbose mode is on, print a confirmation message.
    if [ "$VERBOSE" -eq 1 ]; then
        echo "Copied: $relative_path"
    fi
done

echo ""
echo "✅ Log file copying complete."
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"
