# Define the destination file path for the tronkey script
$destinationPath = "$env:ProgramData\tronkey.ps1"

# Check if the tronkey script exists and remove it
if (Test-Path $destinationPath) {
    Remove-Item $destinationPath -Force
    Write-Host "tronkey script removed."
} else {
    Write-Host "tronkey script not found."
}

# Remove the environment variable for tronkey
[System.Environment]::SetEnvironmentVariable("TRONKEY", $null, [System.EnvironmentVariableTarget]::Machine)
Write-Host "Environment variable 'TRONKEY' removed."

# Remove tronkey from the system PATH
$path = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
$updatedPath = $path -replace [regex]::Escape("$env:ProgramData"), ""
[System.Environment]::SetEnvironmentVariable("PATH", $updatedPath, [System.EnvironmentVariableTarget]::Machine)
Write-Host "System PATH cleaned."

Write-Host "Uninstallation complete."
