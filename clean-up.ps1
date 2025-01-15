# Define the directories to clean
$directories = @("public", "resources")

foreach ($dir in $directories) {
    # Check if the directory exists
    if (Test-Path -Path $dir) {
        # Get all files and folders in the directory
        $items = Get-ChildItem -Path $dir

        foreach ($item in $items) {
            # Skip the .gitignore file and remove all other items
            if ($item.Name -ne ".gitignore") {
                Remove-Item -Path $item.FullName -Recurse -Force
            }
        }

        Write-Host "Cleared contents of $dir, except for .gitignore."
    } else {
        Write-Host "$dir directory does not exist."
    }
}

Write-Host "Script completed."