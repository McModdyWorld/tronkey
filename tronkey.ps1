# Tronkey - Simple App Installer
# Save this script as Tronkey.ps1

param(
    [string]$Command,
    [string]$AppName
)

# GitHub-hosted app list URL
$AppListUrl = "https://raw.githubusercontent.com/McModdyWorld/tronkey/refs/heads/main/applist.txt"

# Function to fetch and parse the app list
function Get-AppList {
    try {
        $AppList = Invoke-WebRequest -Uri $AppListUrl -UseBasicParsing | Select-Object -ExpandProperty Content
        $AppList -split "`n" | ForEach-Object {
            $fields = $_ -split ","
            [PSCustomObject]@{
                Name = $fields[0].Trim()
                Link = $fields[1].Trim()
                SavedFileName = $fields[2].Trim()
            }
        }
    } catch {
        Write-Error "Failed to fetch the app list. Check your internet connection or the AppList URL."
        return $null
    }
}

# Function to search for apps
function Search-App {
    param([string]$SearchTerm)

    $AppList = Get-AppList
    if ($AppList) {
        $FilteredApps = $AppList | Where-Object { $_.Name -like "*$SearchTerm*" }
        if ($FilteredApps) {
            $FilteredApps | ForEach-Object { Write-Host "$($_.Name)" -ForegroundColor Green }
        } else {
            Write-Host "No apps found matching '$SearchTerm'." -ForegroundColor Yellow
        }
    }
}

# Function to install an app
function Install-App {
    param([string]$AppName)

    $AppList = Get-AppList
    if ($AppList) {
        $App = $AppList | Where-Object { $_.Name -eq $AppName }
        if ($App) {
            Write-Host "Downloading $($App.Name) from $($App.Link)..." -ForegroundColor Cyan
            try {
                Invoke-WebRequest -Uri $App.Link -OutFile $App.SavedFileName
                Write-Host "Running installer: $($App.SavedFileName)" -ForegroundColor Cyan
                Start-Process -FilePath $App.SavedFileName -Wait
                Write-Host "$($App.Name) installation completed." -ForegroundColor Green
            } catch {
                Write-Error "Failed to download or run the installer for $($App.Name)."
            }
        } else {
            Write-Host "App '$AppName' not found in the list." -ForegroundColor Yellow
        }
    }
}

# Main script logic
switch ($Command) {
    "search" {
        if ($AppName) {
            Search-App -SearchTerm $AppName
        } else {
            Write-Host "Usage: Tronkey.ps1 search <AppName>" -ForegroundColor Yellow
        }
    }
    "install" {
        if ($AppName) {
            Install-App -AppName $AppName
        } else {
            Write-Host "Usage: Tronkey.ps1 install <AppName>" -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "Usage:" -ForegroundColor Cyan
        Write-Host "  Tronkey.ps1 search <AppName>   - Search for an app in the list" -ForegroundColor Gray
        Write-Host "  Tronkey.ps1 install <AppName>  - Install an app by name" -ForegroundColor Gray
    }
}
