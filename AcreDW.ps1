# rebuild-and-download.ps1

param (
    [Parameter(Mandatory = $true)]
    [string]$Base64Torrent  # Base64-encoded torrent passed as an argument
)

# Configuration
$currentDir = Get-Location  # Current directory
$torrentFilePath = "$currentDir\file.torrent"  # Local path to save the .torrent file
$githubAria2cURL = "https://raw.githubusercontent.com/username/repo/main/aria2c.exe"  # GitHub URL for aria2c.exe
$downloadDirectory = "$currentDir\Download"  # Download directory
$aria2cPath = "$currentDir\aria2c.exe"  # Path to aria2c executable

# Step 1: Ensure aria2c exists
if (-not (Test-Path -Path $aria2cPath)) {
    Write-Host "aria2c.exe not found. Downloading from GitHub..."
    try {
        Invoke-WebRequest -Uri $githubAria2cURL -OutFile $aria2cPath -ErrorAction Stop
        Write-Host "aria2c.exe successfully downloaded."
    } catch {
        Write-Error "Failed to download aria2c.exe from GitHub. Exiting."
        exit
    }
}

# Step 2: Rebuild the torrent file from Base64 string
Write-Host "Rebuilding the torrent file from Base64 string..."
try {
    $torrentBytes = [Convert]::FromBase64String($Base64Torrent)
    [System.IO.File]::WriteAllBytes($torrentFilePath, $torrentBytes)
    Write-Host "Torrent file successfully rebuilt at: $torrentFilePath"
} catch {
    Write-Error "Failed to rebuild the torrent file. Exiting."
    exit
}

# Step 3: Ensure the download directory exists
if (-not (Test-Path -Path $downloadDirectory)) {
    New-Item -ItemType Directory -Force -Path $downloadDirectory | Out-Null
}

# Step 4: Start the download using aria2c
Write-Host "Starting torrent download using aria2c..."
$aria2Command = "& `"$aria2cPath`" --dir=`"$downloadDirectory`" --seed-time=0 `"$torrentFilePath`""
Invoke-Expression $aria2Command

Write-Host "Download complete! Seeding has been disabled."
