Set-PSReadLineOption -EditMode Emacs

Set-Alias ll ls
Set-Alias vi nvim

function sb { Set-Location C:\Users\PP\Projects\second-brain\; vi . }

function dev {
    # Qt environment setup
    $env:PATH = "C:\Qt\6.7.2\msvc2019_64\bin;$env:PATH"

    # Visual Studio DevShell setup
    Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell a6d746a5 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"

    Write-Host "Development environment ready (Qt + Visual Studio)" -ForegroundColor Green
}

function qgisdev {
    # QGIS Python environment setup
    $qgisPath = "C:\Program Files\QGIS 3.34.4"

    # Set PYTHONPATH to include QGIS Python modules
    $env:PYTHONPATH = "$qgisPath\apps\qgis-ltr\python;$qgisPath\apps\Python39\Lib\site-packages"

    # Add QGIS binaries to PATH
    $env:PATH = "$qgisPath\bin;$qgisPath\apps\qgis\bin;$env:PATH"

    # Set additional QGIS environment variables
    $env:QGIS_PREFIX_PATH = "$qgisPath\apps\qgis"

    Write-Host "QGIS development environment ready (Python paths configured)" -ForegroundColor Green
}
