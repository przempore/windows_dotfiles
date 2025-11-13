# Dotfiles Installation Script
# This script creates symbolic links from the repository to the actual config locations

param(
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Define the dotfiles mappings
$dotfiles = @{
    "wezterm\wezterm.lua" = "$env:USERPROFILE\.config\wezterm\wezterm.lua"
    "powershell\Microsoft.PowerShell_profile.ps1" = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "glazewm" = "$env:USERPROFILE\.glzr"
    "zed" = "$env:APPDATA\Zed"
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

function Test-AdminPrivileges {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Create-Symlink {
    param(
        [string]$Source,
        [string]$Target,
        [bool]$IsDirectory
    )

    if ($DryRun) {
        Write-Info "[DRY RUN] Would create symlink: $Target -> $Source"
        return
    }

    # Create parent directory if it doesn't exist
    $parentDir = Split-Path -Parent $Target
    if (-not (Test-Path $parentDir)) {
        Write-Info "Creating directory: $parentDir"
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Check if target already exists
    if (Test-Path $Target) {
        if ($Force) {
            Write-Warning "Removing existing: $Target"
            Remove-Item -Path $Target -Recurse -Force
        } else {
            Write-Warning "Target already exists: $Target"
            Write-Warning "Use -Force to overwrite or backup first with backup.ps1"
            return
        }
    }

    # Create symbolic link
    try {
        if ($IsDirectory) {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
        } else {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
        }
        Write-Success "Created symlink: $Target -> $Source"
    } catch {
        Write-Error "Failed to create symlink: $_"
    }
}

# Main installation logic
Write-Info "Starting dotfiles installation..."
Write-Host ""

# Check for admin privileges
if (-not (Test-AdminPrivileges)) {
    Write-Warning "This script requires administrator privileges to create symbolic links."
    Write-Warning "Please run PowerShell as Administrator and try again."
    exit 1
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

foreach ($entry in $dotfiles.GetEnumerator()) {
    $sourcePath = Join-Path $repoRoot $entry.Key
    $targetPath = $entry.Value

    Write-Info "Processing: $($entry.Key)"
    
    # Check if source exists in repo
    if (-not (Test-Path $sourcePath)) {
        Write-Warning "Source not found in repository: $sourcePath"
        Write-Info "Skipping..."
        Write-Host ""
        continue
    }

    # Determine if it's a directory or file
    $isDirectory = Test-Path $sourcePath -PathType Container

    Create-Symlink -Source $sourcePath -Target $targetPath -IsDirectory $isDirectory
    Write-Host ""
}

if ($DryRun) {
    Write-Info "Dry run completed. No changes were made."
} else {
    Write-Success "Dotfiles installation completed!"
}

Write-Host ""
Write-Info "Note: After installation, your configs will be managed from this repository."
Write-Info "Any changes to the configs should be made in the repository and committed."
