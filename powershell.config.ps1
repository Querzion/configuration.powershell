###
###    JetBrains Mono Font| https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
###
###
###

# Function to pause the script
function Pause-Script {
    Write-Host "Press any key to continue..."
    [void][System.Console]::ReadKey($true)
}

# Function to handle errors
function Handle-Error {
    Write-Error $_.Exception.Message
    Write-Host "An error occurred. Press any key to exit..."
    [void][System.Console]::ReadKey($true)
    exit
}

# Main script
try {
    Write-Output "Starting the setup process..."
    Pause-Script

    # Download and install JetBrains Mono
    Write-Output "Downloading JetBrains Mono font..."
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" -OutFile "$env:TEMP\JetBrainsMono.zip" -ErrorAction Stop
    Pause-Script

    Write-Output "Extracting JetBrains Mono font..."
    Expand-Archive -Path "$env:TEMP\JetBrainsMono.zip" -DestinationPath "$env:TEMP\JetBrainsMono" -ErrorAction Stop
    Pause-Script

    Write-Output "Installing JetBrains Mono font..."
    Copy-Item -Path "$env:TEMP\JetBrainsMono\ttf\*.*" -Destination "$env:WINDIR\Fonts" -ErrorAction Stop
    Pause-Script

    # Register JetBrains Mono as a PowerShell font
    Write-Output "Setting JetBrains Mono as PowerShell terminal font..."
    Set-ItemProperty -Path "HKCU:\Console\%SystemRoot%_system32_windowsPowerShell_v1.0_powershell.exe" -Name "FaceName" -Value "JetBrains Mono" -ErrorAction Stop
    Pause-Script

    # Install Scoop
    Write-Output "Installing Scoop package manager..."
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') -ErrorAction Stop
    Pause-Script

    # Install fastfetch and starship using Scoop
    Write-Output "Installing fastfetch using Scoop..."
    scoop install fastfetch -ErrorAction Stop
    Pause-Script

    Write-Output "Installing starship using Scoop..."
    scoop install starship -ErrorAction Stop
    Pause-Script

    # Set starship as the default prompt in PowerShell profile
    $profilePath = "$PROFILE"
    if (!(Test-Path -Path $profilePath)) {
        Write-Output "Creating PowerShell profile..."
        New-Item -ItemType File -Path $profilePath -Force -ErrorAction Stop
        Pause-Script
    }

    # Add fastfetch to the beginning of the profile
    Write-Output "Adding fastfetch to PowerShell profile..."
    Add-Content -Path $profilePath -Value @"
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch
}
"@ -ErrorAction Stop
    Pause-Script

    # Add starship initialization to the profile
    Write-Output "Adding starship initialization to PowerShell profile..."
    Add-Content -Path $profilePath -Value @"
Invoke-Expression (&starship init powershell)
"@ -ErrorAction Stop
    Pause-Script

    # Configure the starship prompt with Tokyo Night theme
    $starshipConfigPath = "$env:USERPROFILE\.config\starship.toml"
    if (!(Test-Path -Path $starshipConfigPath)) {
        Write-Output "Creating starship configuration directory..."
        New-Item -ItemType File -Path $starshipConfigPath -Force -ErrorAction Stop
        Pause-Script
    }

    Write-Output "Configuring starship prompt with Tokyo Night theme..."
    Set-Content -Path $starshipConfigPath -Value @"
format = """
[░▒▓](#a3aed2)\
[  ](bg:#a3aed2 fg:#090c0c)\
[](bg:#769ff0 fg:#a3aed2)\
\$directory\
[](fg:#769ff0 bg:#394260)\
\$git_branch\
\$git_status\
[](fg:#394260 bg:#212736)\
\$nodejs\
\$rust\
\$golang\
\$php\
[](fg:#212736 bg:#1d2230)\
\$time\
[ ](fg:#1d2230)\
\n\$character"""

[directory]
style = "fg:#e3e5e5 bg:#769ff0"
format = "[ \$path ](\$style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:#394260"
format = '[[ \$symbol \$branch ](fg:#769ff0 bg:#394260)](\$style)'

[git_status]
style = "bg:#394260"
format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)](\$style)'

[nodejs]
symbol = ""
style = "bg:#212736"
format = '[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)'

[rust]
symbol = ""
style = "bg:#212736"
format = '[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)'

[golang]
symbol = ""
style = "bg:#212736"
format = '[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)'

[php]
symbol = ""
style = "bg:#212736"
format = '[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)'

[time]
disabled = false
time_format = "%R" # Hour:Minute Format
style = "bg:#1d2230"
format = '[[  \$time ](fg:#a0a9cb bg:#1d2230)](\$style)'
"@ -ErrorAction Stop
    Pause-Script

    # Configure fastfetch
    $fastfetchConfigDir = "$env:USERPROFILE\.config\fastfetch"
    if (-Not (Test-Path -Path $fastfetchConfigDir)) {
        Write-Output "Creating fastfetch configuration directory..."
        New-Item -ItemType Directory -Path $fastfetchConfigDir -Force -ErrorAction Stop
        Pause-Script
    }

    $fastfetchConfigPath = "$fastfetchConfigDir\config.conf"
    if (-Not (Test-Path -Path $fastfetchConfigPath)) {
        Write-Output "Creating fastfetch configuration file..."
        New-Item -ItemType File -Path $fastfetchConfigPath -Force -ErrorAction Stop
        Pause-Script
    }

    Write-Output "Configuring fastfetch with additional options..."
    # Extended content for fastfetch config
    $fastfetchConfigContent = @"
# Fastfetch configuration file

# General information
title: My Custom Fastfetch
color: 2
separator: " | "

# Fetch specific information
fetchTime: true
fetchCpu: true
fetchMemory: true
fetchBattery: true
fetchOs: true
fetchHost: true
fetchKernel: true
fetchUptime: true
fetchPackages: true
fetchShell: true
fetchResolution: true
fetchDE: true
fetchWM: true
fetchTheme: true
fetchIcons: true
fetchTerminal: true
fetchCpuUsage: true
fetchDiskUsage: true
fetchProcesses: true
fetchGpu: true
fetchNetwork: true
fetchFont: true
"@

    Set-Content -Path $fastfetchConfigPath -Value $fastfetchConfigContent -ErrorAction Stop
    Pause-Script

    Write-Output "Setup process completed successfully!"
} catch {
    Handle-Error
}
