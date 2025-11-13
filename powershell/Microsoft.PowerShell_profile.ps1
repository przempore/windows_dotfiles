Set-PSReadLineOption -EditMode Emacs

Set-Alias ll ls
Set-Alias vi nvim

function sb { Set-Location C:\Users\PP\Projects\second-brain\; vi . }

function dev {
    $qslogPath = "C:\Users\PP\work\libraries\QsLog-3b32a0848e4f2fa60d080183367369ead254632c"
    $qledPath = "C:\Users\PP\work\libraries\qledplugin-Desktop_Qt_5_15_2_MSVC2019_64bit-c898fe6"
    $gdalPath = "C:\Users\PP\work\libraries\release-1928-x64-gdal-3-9-1-mapserver-8-2-0-libs"
    $env:PATH = "$gdalPath;$qslogPath;$qledPath;C:\Qt\6.7.2\msvc2019_64\bin;$env:PATH"

    # Visual Studio DevShell setup
    Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell a6d746a5 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"

    Write-Host "Development environment ready (Qt + Visual Studio)" -ForegroundColor Green
}

function qgisdev {
    $qgisPath = "C:\Program Files\QGIS 3.34.4"

    # Set PYTHONPATH to include QGIS Python modules
    $env:PYTHONPATH = "$qgisPath\apps\qgis-ltr\python;$qgisPath\apps\Python39\Lib\site-packages"

    # Add QGIS binaries to PATH
    $env:PATH = "$qgisPath\bin;$qgisPath\apps\qgis\bin;$env:PATH"

    # Set additional QGIS environment variables
    $env:QGIS_PREFIX_PATH = "$qgisPath\apps\qgis"

    Write-Host "QGIS development environment ready (Python paths configured)" -ForegroundColor Green
}
