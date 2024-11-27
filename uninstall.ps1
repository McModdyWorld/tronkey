# Define the folder and the script paths
$folderPath = "$env:ProgramData\TronKey"
$installScriptPath = "$folderPath\tronkey.ps1"
$uninstallScriptPath = "$folderPath\tronkey-uninstall.ps1"
$updateScriptPath = "$folderPath\tronkey-update.ps1"

# Check if the tronkey, tronkey-uninstall, and tronkey-update scripts exist and remove them
if (Test-Path $installScriptPath) {
    Remove-Item $installScriptPath -Force
    Write-Host "tronkey script removed."
} else {
    Write-Host "tronkey script not found."
}

if (Test-Path $uninstallScriptPath) {
    Remove-Item $uninstallScriptPath -Force
    Write-Host "tronkey-uninstall script removed."
} else {
    Write-Host "tronkey-uninstall script not found."
}

if (Test-Path $updateScriptPath) {
    Remove-Item $updateScriptPath -Force
    Write-Host "tronkey-update script removed."
} else {
    Write-Host "tronkey-update script not found."
}

# Remove the environment variables for tronkey, tronkey-uninstall, and tronkey-update (user level)
[System.Environment]::SetEnvironmentVariable("TRONKEY", $null, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("TRONKEY_UNINSTALL", $null, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("TRONKEY_UPDATE", $null, [System.EnvironmentVariableTarget]::User)
Write-Host "Environment variables 'TRONKEY', 'TRONKEY_UNINSTALL', and 'TRONKEY_UPDATE' removed."

# Remove TronKey folder from the user PATH
$path = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
$updatedPath = $path -replace [regex]::Escape($folderPath), ""
[System.Environment]::SetEnvironmentVariable("PATH", $updatedPath, [System.EnvironmentVariableTarget]::User)
Write-Host "User PATH cleaned."

# Optionally, remove the TronKey folder if empty
if (-not (Get-ChildItem $folderPath)) {
    Remove-Item $folderPath -Force
    Write-Host "TronKey folder removed."
}

Write-Host "Uninstallation complete."
