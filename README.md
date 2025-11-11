# Windows Dotfiles

This repository manages my Windows configuration files (dotfiles) for version control and easy deployment.

## Managed Configurations

- **WezTerm**: Terminal emulator configuration
  - Location: `~\.config\wezterm\wezterm.lua`
  
- **PowerShell**: PowerShell profile and configuration
  - Location: `C:\Users\PP\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
  
- **GlazeWM**: Tiling window manager configuration
  - Location: `C:\Users\PP\.glzr`

## Directory Structure

```
windows_dotfiles/
├── wezterm/
│   └── wezterm.lua
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
├── glazewm/
│   └── (GlazeWM config files)
├── backup.ps1
├── install.ps1
└── README.md
```

## Usage

### First Time Setup

1. **Backup your existing configurations**:
   ```powershell
   .\backup.ps1
   ```
   This copies your current configs from their system locations to this repository.

2. **Review and commit the backed up files**:
   ```powershell
   git add .
   git commit -m "Initial dotfiles backup"
   ```

3. **Install dotfiles (create symlinks)**:
   ```powershell
   # Run PowerShell as Administrator
   .\install.ps1
   ```
   This creates symbolic links from the repository to the actual config locations.

### Scripts

#### `backup.ps1`

Copies configuration files from their system locations to this repository.

**Options**:
- `-Force`: Skip confirmation prompts and overwrite existing files
- `-DryRun`: Preview what would be backed up without making changes

**Examples**:
```powershell
# Interactive backup (prompts for overwrites)
.\backup.ps1

# Force backup without prompts
.\backup.ps1 -Force

# Preview what would be backed up
.\backup.ps1 -DryRun
```

#### `install.ps1`

Creates symbolic links from the repository to the actual config locations.

**Requirements**: Must run as Administrator (required for creating symbolic links on Windows)

**Options**:
- `-Force`: Overwrite existing files/symlinks
- `-DryRun`: Preview what would be installed without making changes

**Examples**:
```powershell
# Install dotfiles (run as Administrator)
.\install.ps1

# Force install, overwriting existing configs
.\install.ps1 -Force

# Preview what would be installed
.\install.ps1 -DryRun
```

## Workflow

### Making Changes

After running `install.ps1`, your configs are managed from this repository:

1. Edit files in this repository (they're symlinked to the actual locations)
2. Test your changes
3. Commit when satisfied:
   ```powershell
   git add .
   git commit -m "Update wezterm config"
   git push
   ```

### Setting Up on a New Machine

1. Clone this repository:
   ```powershell
   git clone <your-repo-url> ~/Projects/windows_dotfiles
   cd ~/Projects/windows_dotfiles
   ```

2. Run the install script as Administrator:
   ```powershell
   .\install.ps1
   ```

3. Your configs are now set up and synced!

## Troubleshooting

### "Access Denied" when running install.ps1

Make sure you're running PowerShell as Administrator. Symbolic links require elevated privileges on Windows.

### "File exists" error

Use the `-Force` flag to overwrite existing files, or backup first:
```powershell
.\install.ps1 -Force
```

### Verify symbolic links

Check if symlinks were created correctly:
```powershell
Get-Item $env:USERPROFILE\.config\wezterm\wezterm.lua | Select-Object LinkType, Target
Get-Item $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 | Select-Object LinkType, Target
Get-Item $env:USERPROFILE\.glzr | Select-Object LinkType, Target
```

## Notes

- After installation, any changes to the configs should be made in this repository
- The symbolic links ensure that changes are automatically reflected in both locations
- Always commit and push changes to keep your dotfiles in sync across machines
- Run `backup.ps1` before `install.ps1` to preserve your current configurations
