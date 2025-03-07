#!/bin/bash

echo "FileAuto Script Started"
echo "Paste your code snippet (first line should contain the filename)"
echo "Press Ctrl+D when done with input"
echo "-----------------------------------------"

show_help() {
    echo "Available options:"
    echo "  y - Create the file with the detected filename"
    echo "  n - Cancel the operation"
    echo "  e - Edit the filename manually"
    echo "  ? - Show this help message"
}

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
    
    valid_response=false
    while [ "$valid_response" = false ]; do
        read -p "Create this file? (y/n/e/?) " confirm
        
        case $confirm in
            [yY])
                valid_response=true
                # Create directory if needed
                dir=$(dirname "$filename")
                if [ "$dir" != "." ]; then
                    echo "Creating directory: $dir"
                    mkdir -p "$dir"
                fi
                
                # Write content to file
                echo "$content" > "$filename"
                echo "File created: $filename"
                ;;
            [nN])
                valid_response=true
                echo "Operation cancelled."
                ;;
            [eE])
                valid_response=true
                read -p "Enter new filename: " new_filename
                
                if [ -z "$new_filename" ]; then
                    echo "No filename provided. Operation cancelled."
                else
                    # Create directory if needed
                    dir=$(dirname "$new_filename")
                    if [ "$dir" != "." ]; then
                        echo "Creating directory: $dir"
                        mkdir -p "$dir"
                    fi
                    
                    # Write content to file
                    echo "$content" > "$new_filename"
                    echo "File created: $new_filename"
                fi
                ;;
            \?)
                show_help
                ;;
            *)
                echo "Invalid option. Please choose y, n, e, or ?"
                ;;
        esac
    done
    
    echo "-----------------------------------------"
    echo "Ready for next input. Press Ctrl+D after pasting."
done