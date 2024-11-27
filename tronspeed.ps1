# Stop processes if running
$processes = @(
    "OneDrive", "Skype", "msedge", "Dropbox", "WinStore.App", "btmsrvview", 
    "WmpNetwk", "OneNote", "fxssvc", "WerFault", "TimeBrokerSvc", 
    "ehshell", "Audiosrv", "FntCache", "SchedSvc", "msiexec", "SearchFilterHost"
)

foreach ($process in $processes) {
    Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force
}

# Output confirmation
Write-Host "Processes have been stopped."
