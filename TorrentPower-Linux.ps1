# Debian Edition
Clear-Host

$host.UI.RawUI.WindowTitle = "PowerTorrent by ContratopDev"
$ver = "1.0"

function checkaria2 {
    if (Get-Command "aria2c" -ErrorAction SilentlyContinue) {
        write-host "aria2c is installed" -ForegroundColor Green
    }
    else {
        Write-Warning "aria2c is not installed"
        write-host "Installing..."
        sudo apt install aria2
        if ($?) {
            write-host "aria2c is installed" -ForegroundColor Green
        }
        else {
            write-host "aria2c is not installed" -ForegroundColor Red
            write-host "Exiting..."
            break
        }
    }
}

function workdirselect {
    $workdir = Read-Host "Enter download path"
    if (Test-path $workdir) {
        Set-Location $workdir
    }
    else {
        Write-Warning "Directory not found"
        Pause
        workdirselect
    }
}


if (-not(test-path -path powerdownloads)) {
    write-host "Powerdownloaded folder not found, creating it..."
    start-sleep -s 1
    New-Item -ItemType Directory -Path powerdownloads
    write-host "Powerdownloads folder created" -ForegroundColor Green
    start-sleep -s 1
    Set-Location powerdownloads
}
else {
    Set-Location powerdownloads
}



$loopmenu1 = $true # ? Loop Start here ###################################
while ($loopmenu1) {
    # * MENU INICIAL ########################################################
    clear-host 
    write-host "------------------------------------------------------------------------"
    write-host "PowerTorrent Debian Edition by ContratopDev" $ver
    write-host "------------------------------------------------------------------------"
    ""
    if (Get-Command "aria2c" -ErrorAction SilentlyContinue) {
        write-host "Aria2C Ready" -ForegroundColor Green
    }
    else {
        write-warning "Aria2C not ready"
        $ariafail = $true
    }
    ""
    write-host "Download directory: $pwd" -ForegroundColor Cyan
    ""
    if ($ariafail) {
        write-host "[R] Retry Aria2c core" -ForegroundColor Yellow
    }
    write-host "[1] Download Torrent from File"
    ""
    write-host "[pwd] Change download directory" -ForegroundColor Blue
    write-host "[x] Exit" -ForegroundColor Blue

    $choice = Read-Host "Select an option"
    switch ($choice) {
        "1" {
            Clear-Host
            write-host "[1] Drag torrent file to console" -ForegroundColor Cyan
            write-host "[2] Enter torrent file path" -ForegroundColor Cyan
            if (test-path -path $HOME/torrent.torrent) {
                write-host "(AutoDetected) [3] use $HOME/torrent.torrent file" -ForegroundColor Green
            }
            write-host "[x] Exit" -ForegroundColor Blue
            $choice = Read-Host "Select an option"
            switch ($choice) {
                "1" {
                    $torrent = Read-Host "Drag here the torrent file"
                    write-host "Initializing torrent download on $pwd" -ForegroundColor Cyan
                    aria2c $torrent
                    if (-not($?)) {
                        write-warning "Torrent download failed"
                    }
                    else {
                        write-host "Torrent download complete" -ForegroundColor Green
                    }
                    Pause
                    $loopmenu1 = $false
                }
                "2" {
                    $torrent = Read-host "Enter torrent file path (x to cancel)"
                    if (test-path $torrent) {
                        write-host "Initializing torrent download on $pwd" -ForegroundColor Cyan
                        aria2c $torrent
                        if (-not($?)) {
                            write-warning "Torrent download failed"
                        }
                        else {
                            write-host "Torrent download complete" -ForegroundColor Green
                        }
                        Pause
                        $loopmenu1 = $false
                    }
                    else {
                        write-warning "File not found"
                        start-sleep -s 2
                        $loopmenu1 = $false
                    }
                }
                "3" {
                    write-host "Initializing torrent download on $pwd" -ForegroundColor Cyan
                    aria2c $HOME/torrent.torrent
                    if (-not($?)) {
                        write-warning "Torrent download failed"
                    }
                    else {
                        write-host "Torrent download complete" -ForegroundColor Green
                    }
                    Pause
                    $loopmenu1 = $false
                }
                "x" {
                    $loopmenu1 = $false
                }
                default {
                    write-warning "Invalid option"
                    Pause
                    $loopmenu1 = $false
                }
            }
        }
        "pwd" {
            workdirselect
        }
        "R" {
            checkaria2
        }
        "x" {
            exit
        }
        default {
            write-warning "Invalid option"
            Pause
            start-sleep -s 1
        }
    }
}