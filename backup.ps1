# Dotfiles Backup Script
# This script backs up existing config files from their system locations to this repository

param(
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Define the dotfiles mappings (same as install.ps1)
$dotfiles = @{
    "wezterm\wezterm.lua" = "$env:USERPROFILE\.config\wezterm\wezterm.lua"
    "powershell\Microsoft.PowerShell_profile.ps1" = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "glazewm" = "$env:USERPROFILE\.glzr"
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Backup-Item {
    param(
        [string]$Source,
        [string]$Destination
    )

    if ($DryRun) {
        Write-Info "[DRY RUN] Would backup: $Source -> $Destination"
        return
    }

    # Create parent directory if it doesn't exist
    $parentDir = Split-Path -Parent $Destination
    if (-not (Test-Path $parentDir)) {
        Write-Info "Creating directory: $parentDir"
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Check if destination already exists in repo
    if (Test-Path $Destination) {
        if ($Force) {
            Write-Warning "Overwriting existing file in repository: $Destination"
        } else {
            $response = Read-Host "File exists in repository: $Destination. Overwrite? (y/N)"
            if ($response -ne 'y' -and $response -ne 'Y') {
                Write-Info "Skipping..."
                return
            }
        }
    }

    # Copy the file or directory
    try {
        if (Test-Path $Source -PathType Container) {
            Copy-Item -Path $Source -Destination $Destination -Recurse -Force
            Write-Success "Backed up directory: $Source -> $Destination"
        } else {
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-Success "Backed up file: $Source -> $Destination"
        }
    } catch {
        Write-Error "Failed to backup: $_"
    }
}

function Resolve-SymbolicLink {
    param([string]$Path)
    
    if (Test-Path $Path) {
        $item = Get-Item $Path -Force
        if ($item.LinkType -eq "SymbolicLink") {
            return $true
        }
    }
    return $false
}

# Main backup logic
Write-Info "Starting dotfiles backup..."
Write-Host ""

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$backedUpCount = 0
$skippedCount = 0

foreach ($entry in $dotfiles.GetEnumerator()) {
    $sourcePath = $entry.Value
    $destPath = Join-Path $repoRoot $entry.Key

    Write-Info "Processing: $($entry.Key)"
    
    # Check if source exists on system
    if (-not (Test-Path $sourcePath)) {
        Write-Warning "Config not found on system: $sourcePath"
        Write-Info "Skipping..."
        Write-Host ""
        $skippedCount++
        continue
    }

    # Check if it's already a symbolic link
    if (Resolve-SymbolicLink $sourcePath) {
        Write-Warning "Already a symbolic link: $sourcePath"
        Write-Info "Skipping... (use install.ps1 to manage symlinks)"
        Write-Host ""
        $skippedCount++
        continue
    }

    Backup-Item -Source $sourcePath -Destination $destPath
    Write-Host ""
    $backedUpCount++
}

if ($DryRun) {
    Write-Info "Dry run completed. No changes were made."
} else {
    Write-Host ""
    Write-Success "Backup completed!"
    Write-Info "Backed up: $backedUpCount file(s)/directory(ies)"
    Write-Info "Skipped: $skippedCount file(s)/directory(ies)"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Info "1. Review the backed up files in this repository"
    Write-Info "2. Commit the changes to version control (git add . && git commit)"
    Write-Info "3. Run install.ps1 to create symbolic links"
}
