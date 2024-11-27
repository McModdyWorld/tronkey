# Define the folder and the script URLs
$folderPath = "$env:ProgramData\TronKey"
$installScriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/tronkey.ps1'
$uninstallScriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/uninstall.ps1'

$installScriptPath = "$folderPath\tronkey.ps1"
$uninstallScriptPath = "$folderPath\tronkey-uninstall.ps1"

# Create the TronKey folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
    Write-Host "Created folder: $folderPath"
}

# Download the install and uninstall scripts to the TronKey folder
Invoke-WebRequest -Uri $installScriptUrl -OutFile $installScriptPath
Invoke-WebRequest -Uri $uninstallScriptUrl -OutFile $uninstallScriptPath

# Set up the environment variable for tronkey and tronkey-uninstall
[System.Environment]::SetEnvironmentVariable("TRONKEY", $installScriptPath, [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("TRONKEY_UNINSTALL", $uninstallScriptPath, [System.EnvironmentVariableTarget]::Machine)

# Add the TronKey folder to the system PATH so you can run 'tronkey' and 'tronkey-uninstall' from anywhere
$env:PATH += ";$folderPath"

# Confirm success
Write-Host "tronkey and tronkey-uninstall scripts downloaded to $folderPath."
Write-Host "You can now run 'tronkey' and 'tronkey-uninstall' from any terminal."
