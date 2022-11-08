clear-host

$ver = "1.7"

write-host "Ver $ver"
Write-host "Checking System..."
if (-not(test-path -path PowerDownloader-Linux.ps1)) {
    Write-Warning "PowerDownloader-Linux.ps1 not found in current directory. Please run this script from the same directory as PowerDownloader-Linux.ps1"
    exit
}
else {
    write-host "Directory check passed." -ForegroundColor Green
}


if (-not(get-command pip)) {
    write-warning "Python PIP not found. Installing..."
    sudo apt install python3-pip
    if (-not($?)) {
        write-error "Failed to install PIP. Exiting..."
        write-host "command: [sudo apt install python3-pip]"
        exit
    }
    else {
        write-host "PIP installed successfully." -ForegroundColor Green
    }
}
else {
    write-host "pip OK" -foregroundcolor Green
}

if (-not(get-command yt-dlp)) {
    Write-Warning "YT-DLP is not installed. installing..."
    pip install yt-dlp
    if (-not($?)) {
        Write-Error "Failed to install YT-DLP. Please install it manually."
        write-host "command: [pip install yt-dlp]"
        exit
    }
    else {
        Write-Host "YT-DLP installed successfully." -ForegroundColor Green
    }
}
else {
    Write-Host "yt-dlp OK" -ForegroundColor Green
}

if (-not(get-command ffmpeg)) {
    write-warning "FFMPEG is not installed. Installing..."
    sudo apt install ffmpeg
    if (-not($?)) {
        write-error "Failed to install FFMPEG. Please install it manually."
        write-host "command: [sudo apt install ffmpeg]"
        exit
    }
    else {
        write-host "FFMPEG installed successfully." -ForegroundColor Green
    }
}
else {
    write-host "ffmpeg OK" -ForegroundColor Green
}

function geturl {
    $script:url = read.host "Paste your URL here"
}

$whilemode = $true
while ($whilemode) {
    Clear-Host
    write-host "PowerDownloader Debian Version $ver"
    write-host "by" -NoNewline
    write-host "ContratopDev" -foregroundcolor Cyan
    write-host ""
    if (-not(get-command yt-dlp)) {
        write-warning "yt.dlp not detected. NUll functionallity."
    }
    elseif (-not(get-command ffmpeg)) {
        Write-Warning "ffmpeg not detected, funcionality is limited."
    }
    if ($url) {
        write-host "URL: $url" -ForegroundColor Cyan
        Write-host ""
        $urltitle = Invoke-RestMethod "https://title.mihit.ch/$url"
        if ($?) {
            write-host "Title: $urltitle" -ForegroundColor Cyan
        }
        else {
            write-host "Title: [Failed to get title]" -ForegroundColor Red
        }
    }
    else {
        write-host "URL: Not set"
        write-host ""
    }
    write-host "[url] Pick an url beforehand"
    write-host "[1] Music" -ForegroundColor Cyan
    write-host "[2] Video / Full content"
    write-host "[3] Update" -ForegroundColor Cyan
    write-host "[4] About"
    write-host "[5] Quit" -ForegroundColor Cyan
    write-host ""
    write-host "[torrent] Torrent mode" -ForegroundColor Green
    write-host "[advanced] Custom download"
    write-host ""
    $decision = read.host "pick an option"
    switch ($decision) {
        "url" { geturl }
        "1" {
            if (-not($url)) {
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host ""
            write-host "Downloading MP3..." -ForegroundColor Cyan
            yt-dlp -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 $url
            write-host ""
            write-host "Download finished." -ForegroundColor Green
            exit
        }
        "2" {
            if (-not($url)) {
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host "Downloading content in the best quality possible..." -ForegroundColor Cyan
            yt-dlp -S ext:mp4:m4a -o "%(title)s.%(ext)s" $url
            write-host "Download finished" -ForegroundColor Green
            exit
        }
        "3" {
            write-host ""
            write-host "Updating PowerDownloader" -ForegroundColor Yellow
            write-host ""
            Remove-Item PowerDownloader-Linux.ps1
            if (-not($?)) {
                sudo rm PowerDownloader-Linux.ps1
                if (-not($?)) {
                    write-error "Failed to remove old version. Please remove it manually."
                    write-host "command: [sudo rm PowerDownloader-Linux.ps1]"
                    exit
                }
            }
            Invoke-WebRequest "https://raw.githubusercontent.com/ContratopDev/PowerDownloader/main/PowerDownloader-Linux.ps1" -OutFile PowerDownloader-Linux.ps1
            if (-not($?)) {
                write-warning "Error when downloading the update"
                exit
            }
            write-host "Updated succesfully." -ForegroundColor Green
            exit
        }
        "4" {
            write-host ""
            Write-host "PowerDownloader $ver" -ForegroundColor Cyan
            write-host "Made by ContratopDev in Powershell"
            write-host "For debian-based distros"
            write-host "Want it for android? check README.md"
            Pause
        }
        "5" {
            Clear-Host
            write-host "Exiting..." -ForegroundColor Cyan
            exit
        }
        advanced {
            if (-not($url)) {
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host "Obtaining format list..." -ForegroundColor Cyan
            yt-dlp -F $url
            write-host ""
            write-host "if thereś any error, please type " -ForegroundColor Cyan -NoNewline
            write-host "[back]" -ForegroundColor Yellow
            write-host "You can also use " -ForegroundColor Cyan -NoNewline
            write-host "[best] "  -ForegroundColor Yellow -NoNewline
            write-host "for the best option in your case" -ForegroundColor Cyan
            $fcode = read-host "Select code format"
            if ($fcode -eq "Back") {
                write-host "REversing changes"
                start-sleep -s 2
            }
            else {
                clear-host
                write-host "URL: $url"
                if ($fcode -eq "best") {
                    write-host "Format code: $fcode (Automatic Max Quality" -ForegroundColor Cyan
                }
                else {
                    write-host "Format Code: $fcode (Manual)"
                }
                write-host ""
                write-host "Downloading..." -ForegroundColor Cyan
                yt-dlp -o "%(title)s.%(ext)s" -f $fcode $url
                write-host ""
                write-host "Siccessfully downloaded." -ForegroundColor Green
                exit
            }
        }
        "torrent" {
            Clear-Host
            8### Check PowerTorrent-Windows ###
            if (-not(test-path -path PowerTorrent-Linux.ps1)) {
                write-warning "PowerTorrent-Linux.ps1 not found"
                if (-not(test-path -path yt.dlp.exe)) {
                    write-warning "Not on the same directory or PowerDownloaded not downloadef fully"
                    $null = read-host "Press enter to exit"
                    break
                }
                write-host "Downloading..."
                Invoke-WebRequest -uri "https://github.com/contratop/PowerDownloader/raw/main/PowerTorrent-Linux.ps1" -OutFile "PowerTorrent-Linux.ps1"
                if (-not($?)) {
                    write-warning "Failed to download PowerTorrent-Linux.ps1"
                    $null = read-host "Press enter to exit"
                    break
                }
                else {
                    write-host "Downloaded succesfully" -ForegroundColor Green
                    start-sleep -s 2
                }
            }
            ### Start PowerTorrent Linux ###
            pwsh PowerTorrent-Linux.ps1
            write-host "PowerTorrent finished" -ForegroundColor Green
            $null = read-host "Press enter to back to PowerDownloader Menu"
        }




        default {
            Write-Warning "This option is not valid"
            start-sleep -s 2
        }
    }    
    



}