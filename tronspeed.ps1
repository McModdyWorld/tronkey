# Stop processes if running
$processes = @(
    "OneDrive", "Skype", "msedge", "Dropbox", "WinStore.App", "btmsrvview", 
    "WmpNetwk", "OneNote", "fxssvc", "WerFault", "TimeBrokerSvc", 
    "ehshell", "Audiosrv", "FntCache", "SchedSvc", "msiexec", "SearchFilterHost"
)

foreach ($process in $processes) {
    Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force
}

# Confirmation prompt to stop Spotify
$spotifyConfirmation = Read-Host "Do you want to stop Spotify? (Y/N)"
if ($spotifyConfirmation -eq "Y" -or $spotifyConfirmation -eq "y") {
    Get-Process -Name "Spotify" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Spotify has been stopped."
} else {
    Write-Host "Spotify stop skipped."
}

# Confirmation prompt to stop all browsers
$browserConfirmation = Read-Host "Do you want to stop all browsers? (Y/N)"
if ($browserConfirmation -eq "Y" -or $browserConfirmation -eq "y") {
    # List of common browsers to stop
    $browsers = @("chrome", "firefox", "msedge", "opera", "brave")
    foreach ($browser in $browsers) {
        Get-Process -Name $browser -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    Write-Host "All browsers have been stopped."
} else {
    Write-Host "Browser stop skipped."
}

# Confirmation prompt to stop Discord
$discordConfirmation = Read-Host "Do you want to stop Discord? (Y/N)"
if ($discordConfirmation -eq "Y" -or $discordConfirmation -eq "y") {
    Get-Process -Name "Discord" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Discord has been stopped."
} else {
    Write-Host "Discord stop skipped."
}



# Output confirmation
Write-Host "Processes have been stopped."
