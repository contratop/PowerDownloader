# Windows Edition
clear-host

$host.ui.RawUI.WindowTitle = "PowerTorrent by ContratopDev"
$ver = "0.3"

function checkaria2 {
    $script:architectureproc = (Get-WmiObject -Class Win32_ComputerSystem).SystemType
    if ($script:architectureproc -match "x64") {
        write-host "64-bit architecture detected" -ForegroundColor Green
        if (-not(test-path "aria2c64.exe")) {
            Write-Warning "aria2c64 not found"
            write-host "Downloading aria2c64 core..."
            Invoke-WebRequest -Uri "https://github.com/contratop/PowerDownloader/raw/main/aria2c64.exe" -OutFile "aria2c64.exe"
            if (-not($?)) {
                Write-Warning "Download Failed"
                Pause
                exit
            }
            else {
                write-host "Downloaded successfully" -ForegroundColor Green
                start-sleep -s 1
            }
        }
        else {
            write-host "aria2c64 core found" -ForegroundColor Green
            start-sleep -s 1
        }
    }
    elseif ($script:architectureproc -match "x86") {
        write-host "32-bit architecture detected" -ForegroundColor Green
        if (-not(test-path "aria2c32.exe")) {
            Write-Warning "aria2c32 not found"
            write-host "Downloading aria2c32 core..."
            Invoke-WebRequest -Uri "https://github.com/contratop/PowerDownloader/raw/main/aria2c32.exe" -OutFile "aria2c32.exe"
            if (-not($?)) {
                Write-Warning "Download Failed"
                Pause
                exit
            }
            else {
                write-host "Downloaded successfully" -ForegroundColor Green
                start-sleep -s 1
            }
        }
        else {
            write-host "aria2c32 core found" -ForegroundColor Green
            start-sleep -s 1
        }
    }
    else {
        Write-Warning "Unknown architecture"
        write-host "Assuming x86"
        exit
    }
    start-sleep -s 1
}
checkaria2


function workdirselect {
    $workdir = Read-Host "Enter download path"
    if (Test-Path $workdir) {
        Set-Location $workdir
    }
    else {
        Write-Host "Directory not found"
        workdirselect
    }
}
$loopmenu1 = $true
while ($loopmenu1) {
    # MENU INICIAL ########################################################
    clear-host
    write-host "----------------------------"
    write-host "PowerTorrent by ContratopDev $ver"
    write-host "----------------------------"
    ""
    if (test-path -path "aria2c64.exe") {
        write-host "Aria2c 64 bits Ready" -ForegroundColor Green
    }
    elseif (test-path -path "aria2c32.exe") {
        write-host "Aria2c 32 bits Ready" -ForegroundColor Green
    }
    else {
        $script:ariafail = $true
        Write-Warning "Aria2c not ready"
    }
    ""
    write-host "Download directory: $pwd" -ForegroundColor cyan
    ""
    if ($ariafail) { write-host "[R] Retry Aria2c core" -foregroundcolor Yellow }
    write-host "[1] Download Torrent from File" -ForegroundColor Magenta
    ""
    write-host "[opn] Open download directory" -ForegroundColor Blue
    write-host "[pwd] Change download directory" -ForegroundColor Blue
    write-host "[x] Exit" -ForegroundColor Yellow
	
    $choice = Read-Host "Select an option"
    switch ($choice) {
        "1" {
            $torrent = Read-Host "Drag here the torrent file"
            write-host "Initializing torrent download... on $pwd" -ForegroundColor Cyan
            .\aria2c64.exe $torrent
            if (-not($?)) {
                Write-Warning "Torrent download failed"
            }
            else {
                Write-Host "Torrent download completed" -ForegroundColor Green
            }
            pause
            $loopmenu1 = $false
        }

        "opn" {
            explorer $pwd
        }

        "pwd" {
            workdirselect
        }

        "x" {
            exit
            $loopmenu1 = $false
        }


        default {
            Write-Warning "Invalid option"
            start-sleep -s 2
        }
    }
}
