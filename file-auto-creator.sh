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
    
    # Extract the first line (filename)
    filename=$(echo "$input" | head -n 1)
    
    # Remove any potential comments or artifacts from the filename
    # This pattern handles common comment formats: // # /* */
    clean_filename=$(echo "$filename" | sed -E 's/(\/\/|#|\/\*|\*\/).*$//' | tr -d ' \t')
    
    # Further clean the filename to handle any remaining special characters
    clean_filename=$(echo "$clean_filename" | tr -dc '[:alnum:]._-/')
    
    # Extract content (everything except the first line)
    content=$(echo "$input" | tail -n +2)
    
    # Confirm with user
    echo "-----------------------------------------"
    echo "Detected filename: $clean_filename"
    read -p "Create this file? (y/n): " confirm
    
    if [[ $confirm == [yY]* ]]; then
        # Create directory if needed
        dir=$(dirname "$clean_filename")
        if [ "$dir" != "." ]; then
            mkdir -p "$dir"
        fi
        
        # Write content to file
        echo "$content" > "$clean_filename"
        echo "File created: $clean_filename"
    else
        echo "Operation cancelled."
    fi
    
    echo "-----------------------------------------"
    echo "Ready for next input. Press Ctrl+D after pasting."
done