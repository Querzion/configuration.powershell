# Download and install JetBrains Mono
Invoke-WebRequest -Uri "https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip" -OutFile "$env:TEMP\JetBrainsMono.zip"
Expand-Archive -Path "$env:TEMP\JetBrainsMono.zip" -DestinationPath "$env:TEMP\JetBrainsMono"
Copy-Item -Path "$env:TEMP\JetBrainsMono\ttf\*.*" -Destination "$env:WINDIR\Fonts"

# Register JetBrains Mono as a PowerShell font
Set-ItemProperty -Path "HKCU:\Console\%SystemRoot%_system32_windowsPowerShell_v1.0_powershell.exe" -Name "FaceName" -Value "JetBrains Mono"

# Install Scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# Install fastfetch and starship using Scoop
scoop install fastfetch starship

# Set starship as the default prompt in PowerShell profile
$profilePath = "$PROFILE"
if (!(Test-Path -Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}

# Add fastfetch to the beginning of the profile
Add-Content -Path $profilePath -Value @"
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch
}
"@

# Add starship initialization to the profile
Add-Content -Path $profilePath -Value @"
Invoke-Expression (&starship init powershell)
"@

# Configure the starship prompt with Tokyo Night theme
$starshipConfigPath = "$env:USERPROFILE\.config\starship.toml"
if (!(Test-Path -Path $starshipConfigPath)) {
    New-Item -ItemType File -Path $starshipConfigPath -Force
}

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
"@

# Configure fastfetch
$fastfetchConfigDir = "$env:USERPROFILE\.config\fastfetch"
if (-Not (Test-Path -Path $fastfetchConfigDir)) {
    New-Item -ItemType Directory -Path $fastfetchConfigDir -Force
}

$fastfetchConfigPath = "$fastfetchConfigDir\config.conf"
if (-Not (Test-Path -Path $fastfetchConfigPath)) {
    New-Item -ItemType File -Path $fastfetchConfigPath -Force
}

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

Set-Content -Path $fastfetchConfigPath -Value $fastfetchConfigContent
