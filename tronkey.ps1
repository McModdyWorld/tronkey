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
        # Instead of writing an error, return an empty array to prevent red error
        return @()
    }
}

function Search-App {
    param([string]$SearchTerm)

    $AppList = Get-AppList
    if ($AppList) {
        # Normalize the search term to lower case for case-insensitive search
        $SearchTerm = $SearchTerm.ToLower()

        # Use 'Where-Object' with an explicit condition check
        $FilteredApps = $AppList | Where-Object {
            if ($_.Name.ToLower() -like "*$SearchTerm*") { return $true }
            if ($_.Link.ToLower() -like "*$SearchTerm*") { return $true }
            return $false
        }

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
            $tempDir = [System.IO.Path]::Combine($env:TEMP, "tronkeyinstallerfiles")
            if (-not (Test-Path $tempDir)) {
                New-Item -ItemType Directory -Path $tempDir
            }
            
            $filePath = [System.IO.Path]::Combine($tempDir, $App.SavedFileName)
            
            Write-Host "Downloading $($App.Name) from $($App.Link)..." -ForegroundColor Cyan
            try {
                Invoke-WebRequest -Uri $App.Link -OutFile $filePath
                Write-Host "Running installer: $filePath" -ForegroundColor Cyan
                $process = Start-Process -FilePath $filePath -PassThru -Wait
                # Check if the process is still running or if it was canceled
                if ($process.HasExited -and $process.ExitCode -ne 0) {
                    Write-Host "The installation was canceled or failed." -ForegroundColor Yellow
                } else {
                    Write-Host "$($App.Name) installation completed." -ForegroundColor Green
                }
            } catch {
                # Prevent the error if the installer fails (e.g., UAC prompt was declined)
                Write-Host "Failed to download or run the installer for $($App.Name)." -ForegroundColor Yellow
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
