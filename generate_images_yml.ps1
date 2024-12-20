# Set UTF-8 encoding for output
$OutputEncoding = [System.Text.Encoding]::UTF8

# Define the images directory (ensure this path is correct)
$image_dir = "images"

# Check if the images directory exists
if (-Not (Test-Path -Path $image_dir)) {
    Write-Error "The directory '$image_dir' does not exist. Please ensure the path is correct."
    exit
}

# Initialize images.yml with YAML header
"---" | Out-File -FilePath "images.yml" -Encoding utf8

# Iterate through each subdirectory in images
Get-ChildItem -Path $image_dir -Directory | ForEach-Object {
    $folder = $_.Name
    $escaped_folder = $folder -replace "'", "''"

    # Generate folder_slug
    $slug = $folder.ToLower()
    $slug = $slug.Normalize([System.Text.NormalizationForm]::FormD) -replace '\p{M}', ''
    $slug = $slug -replace '[^a-z0-9]+','-'
    $slug = $slug.Trim('-')

    # Debugging Outputs
    Write-Host "Processing Folder: $folder"
    Write-Host "Generated Slug: $slug"

    # Append folder details to images.yml
    "- folder: `"$escaped_folder`"" | Out-File -FilePath "images.yml" -Append -Encoding utf8
    "  folder_slug: `"$slug`"" | Out-File -FilePath "images.yml" -Append -Encoding utf8
    "  images:" | Out-File -FilePath "images.yml" -Append -Encoding utf8

    # Loop through image files with corrected Get-ChildItem usage
    Get-ChildItem -Path "$($_.FullName)\*" -Include *.jpg, *.jpeg, *.png, *.gif -File | ForEach-Object {
        $image = $_.Name -replace "'", "''"
        "    - `"$image`"" | Out-File -FilePath "images.yml" -Append -Encoding utf8
    }

    # Add a blank line for readability
    "" | Out-File -FilePath "images.yml" -Append -Encoding utf8
}