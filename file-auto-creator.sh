#!/bin/bash

echo "File Creator Script Started"
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
    
    # Extract filename from comment
    # Handle // comments (common in many languages)
    if [[ "$first_line" == *"//"* ]]; then
        filename=$(echo "$first_line" | sed 's/\/\/ *//')
    # Handle # comments (bash, python, etc)
    elif [[ "$first_line" == \#* ]]; then
        filename=$(echo "$first_line" | sed 's/# *//')
    # Handle /* comments (C, etc)
    elif [[ "$first_line" == "/*"* ]]; then
        filename=$(echo "$first_line" | sed 's/\/\* *//' | sed 's/ *\*\///')
    else
        # If no comment markers, use the whole line
        filename="$first_line"
    fi
    
    # Trim leading/trailing whitespace
    filename=$(echo "$filename" | xargs)
    
    # Extract content (everything except the first line)
    content=$(echo "$input" | tail -n +2)
    
    # Confirm with user
    echo "-----------------------------------------"
    echo "Detected filename: $filename"
    read -p "Create this file? (y/n): " confirm
    
    if [[ $confirm == [yY]* ]]; then
        # Create directory if needed
        dir=$(dirname "$filename")
        if [ "$dir" != "." ]; then
            echo "Creating directory: $dir"
            mkdir -p "$dir"
        fi
        
        # Write content to file
        echo "$content" > "$filename"
        echo "File created: $filename"
    else
        echo "Operation cancelled."
    fi
    
    echo "-----------------------------------------"
    echo "Ready for next input. Press Ctrl+D after pasting."
done