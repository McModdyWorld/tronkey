# Define the folder and script URLs
$folderPath = "$env:ProgramData\TronKey"
$installScriptUrl = 'https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/tronkey.ps1'

$installScriptPath = "$folderPath\tronkey.ps1"

# Check if the TronKey folder exists
if (Test-Path $folderPath) {
    Write-Host "Updating tronkey script..."

    try {
        # Download the latest tronkey.ps1 script
        Invoke-WebRequest -Uri $installScriptUrl -OutFile $installScriptPath
        Write-Host "Tronkey script updated to the latest version."
    } catch {
        Write-Host "Failed to update tronkey script. Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "TronKey folder not found. Please install TronKey first." -ForegroundColor Yellow
}
