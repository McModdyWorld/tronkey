# Define the folder and the script URLs
$folderPath = "$env:ProgramData\TronKey"
$installScriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/tronkey.ps1'
$uninstallScriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/uninstall.ps1'
$updateScriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/tronkey-update.ps1'

$installScriptPath = "$folderPath\tronkey.ps1"
$uninstallScriptPath = "$folderPath\tronkey-uninstall.ps1"
$updateScriptPath = "$folderPath\tronkey-update.ps1"

# Create the TronKey folder if it doesn't exist
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
    Write-Host "Created folder: $folderPath"
}

# Download the install, uninstall, and update scripts to the TronKey folder
Invoke-WebRequest -Uri $installScriptUrl -OutFile $installScriptPath
Invoke-WebRequest -Uri $uninstallScriptUrl -OutFile $uninstallScriptPath
Invoke-WebRequest -Uri $updateScriptUrl -OutFile $updateScriptPath

# Set up the environment variables for tronkey, tronkey-uninstall, and tronkey-update (user level)
[System.Environment]::SetEnvironmentVariable("TRONKEY", $installScriptPath, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("TRONKEY_UNINSTALL", $uninstallScriptPath, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("TRONKEY_UPDATE", $updateScriptPath, [System.EnvironmentVariableTarget]::User)

# Add the TronKey folder to the user PATH so you can run 'tronkey', 'tronkey-uninstall', and 'tronkey-update' from anywhere
$env:PATH += ";$folderPath"

# Confirm success
Write-Host "tronkey, tronkey-uninstall, and tronkey-update scripts downloaded to $folderPath."
Write-Host "You can now run 'tronkey', 'tronkey-uninstall', and 'tronkey-update' from any terminal."


# Thank You Codeztech for sponsoring my domain "koralnet.net"
