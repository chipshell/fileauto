# FileAuto

A simple bash utility that automatically creates files from code snippets, where the first line contains the target filename (usually as a comment).

## Features

- Automatically extracts filenames from comments in the first line of code snippets
- Creates necessary directory structures automatically
- Allows confirmation before file creation
- Supports multiple comment styles (`//`, `#`, and `/*...*/`)
- Provides options to edit the detected filename or manually enter a new one
- Continuously runs to process multiple files in sequence

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/fileauto.git
cd fileauto

# Make the script executable
chmod +x fileauto.sh
```

## Usage

1. Run the script:
   ```bash
   ./fileauto.sh
   ```

2. Paste your code snippet (with filename as a comment in the first line)
   ```
   // src/main.rs
   fn main() {
       println!("Hello, world!");
   }
   ```

3. Press Enter and then Ctrl+D to finish input

4. Choose from the options:
   - `y` - Create the file with the detected filename
   - `n` - Cancel the operation
   - `e` - Edit the filename manually
   - `?` - Show help for available options

## Examples

### Example 1: Creating a file with a directory structure

Input:
```
// src/utils/helpers.js
function formatDate(date) {
  return date.toISOString().split('T')[0];
}

export default formatDate;
```

This will create:
- The directory structure `src/utils/`
- A file `helpers.js` inside that directory with the provided content

### Example 2: Editing a filename

If the filename is incorrectly detected, you can choose the `e` option to manually edit it.

## License

MIT
