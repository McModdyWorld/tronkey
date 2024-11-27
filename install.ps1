# Define the URL and the destination file path
$scriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/tronkey.ps1'
$destinationPath = "$env:ProgramData\tronkey.ps1"

# Download the script to ProgramData
Invoke-WebRequest -Uri $scriptUrl -OutFile $destinationPath

# Set up the environment variable for tronkey
[System.Environment]::SetEnvironmentVariable("TRONKEY", $destinationPath, [System.EnvironmentVariableTarget]::Machine)

# Add the environment variable to the system PATH so you can run 'tronkey' from anywhere
$env:PATH += ";$env:ProgramData"

# Confirm success
Write-Host "tronkey script downloaded and environment variable set."
Write-Host "You can now run 'tronkey' from any terminal."
