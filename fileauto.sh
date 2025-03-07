#!/bin/bash

echo "FileAuto Script Started"
echo "Paste your code snippet (first line should contain the filename)"
echo "Press Ctrl+D when done with input"
echo "-----------------------------------------"

while true; do
    # Read multiline input until Ctrl+D (EOF)
    echo "Waiting for input..."
    input=$(cat)
    
    # Exit if input is empty
    if [ -z "$input" ]; then
        echo "Empty input received. Try again or press Ctrl+C to exit."
        continue
    fi
    
    # Extract the first line (filename with possible comment)
    first_line=$(echo "$input" | head -n 1)
    detected_filename=""
    
    # Check if first line looks like a filename comment
    # Handle // comments (common in many languages)
    if [[ "$first_line" =~ ^[[:space:]]*//(.*) ]]; then
        comment_content=$(echo "$first_line" | sed 's/^[[:space:]]*\/\/ *//')
        # Check if the comment content looks like a filename (contains . or /)
        if [[ "$comment_content" =~ [\./] ]]; then
            detected_filename="$comment_content"
        fi
    # Handle # comments (bash, python, etc)
    elif [[ "$first_line" =~ ^[[:space:]]*#(.*) ]]; then
        comment_content=$(echo "$first_line" | sed 's/^[[:space:]]*# *//')
        # Check if the comment content looks like a filename (contains . or /)
        if [[ "$comment_content" =~ [\./] ]]; then
            detected_filename="$comment_content"
        fi
    # Handle /* comments (C, etc)
    elif [[ "$first_line" =~ ^[[:space:]]*/\*(.*)\*/ ]]; then
        comment_content=$(echo "$first_line" | sed 's/^[[:space:]]*\/\* *//' | sed 's/ *\*\///')
        # Check if the comment content looks like a filename (contains . or /)
        if [[ "$comment_content" =~ [\./] ]]; then
            detected_filename="$comment_content"
        fi
    fi
    
    # Trim leading/trailing whitespace if we have a detected filename
    if [ -n "$detected_filename" ]; then
        detected_filename=$(echo "$detected_filename" | xargs)
    fi
    
    # Extract content (everything except the first line)
    content=$(echo "$input" | tail -n +2)
    
    # Show detected filename and allow editing
    echo "-----------------------------------------"
    if [ -n "$detected_filename" ]; then
        echo "Filename detected from first line"
        # Use read -e for editability and -i for prefill
        read -e -p "Enter filename (press Enter to confirm): " -i "$detected_filename" filename
    else
        echo "No filename detected from first line"
        read -e -p "Enter filename: " filename
    fi
    
    # Check if filename is provided
    if [ -z "$filename" ]; then
        echo "No filename provided. Operation cancelled."
    else
        # Create directory if needed
        dir=$(dirname "$filename")
        if [ "$dir" != "." ]; then
            echo "Creating directory: $dir"
            mkdir -p "$dir"
        fi
        
        # Write content to file
        echo "$content" > "$filename"
        echo "File created: $filename"
    fi
    
    echo "-----------------------------------------"
    echo "Ready for next input. Press Ctrl+D after pasting."
done