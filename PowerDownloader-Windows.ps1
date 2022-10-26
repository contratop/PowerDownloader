Clear-Host

$ver = "1.7"

Write-host "Ver $ver"
Write-host "Checking System..."
if(-not(test-path -path PowerDownloader-Windows.ps1)){
    Write-host "PowerDownloader-Windows.ps1 not found in current directory. Please run this script from the same directory as PowerDownloader-Windows.ps1"
    exit
}
else{
    Write-host "Directory check passed." -ForegroundColor Green
}


if(-not(test-path -path yt-dlp.exe)){
    Write-Warning "This installation of PowerDownloader is damaged (missing dependencies)"
    if(Get-Command git){
        $continue = read-host "Write [reinstall] to reinstall PowerDownloader completely"
        if($continue -eq "reinstall"){
            $savedpwd = $PWD
            Set-Location ..
            Remove-Item -Recurse -Force $savedpwd
            git clone github.com/contratop/powerdownloader
            Set-Location powerdownloader
            Write-host "Reinstalation completed, please re-start PowerDownloader" -ForegroundColor Green
            exit
        }
        else{
            Write-Warning "Can not go on without reinstalling"
            write-host "This installation is damaged" -ForegroundColor Yellow
            exit
        }
    }
    else{
        Write-Warning "Can not reinstall automatically, missing git"
        write-host "Please delete PowerDownloader and reinstall it manually"
        exit
    }
}
if(-not(test-path -path ffmpeg.exe)){
    Write-Warning "ffmpeg is not integrated"
    $confirm = read-host "Do you want to download ffmpeg now? (120MB) [download]"
    if($confirm){
        clear-host
        Invoke-WebRequest -uri "https://github.com/contratop/PowerDownloader/releases/download/Dependencies/ffmpeg.exe" -OutFile ffmpeg.exe
        if(-not($?)){
            Write-Warning "There was an error trying to download ffmpeg"
            exit
        }
        write-host "ffmpeg was downloades successfully" -ForegroundColor Green
    }
}




function geturl{
    $script:url = read-host "Paste your URL here"
}

########################
# Menu Principal
########################
$whilemode = $true
while($whilemode){
    clear-host
    Write-host "PowerDownloader Version $ver"
    Write-host "by " -NoNewline
    Write-host "ContratopDev" -ForegroundColor Cyan
    Write-host ""
    if(-not(test-path -path ffmpeg.exe)){
        Write-Warning "Could not find ffmpeg, functionality is limited" -ForegroundColor Yellow
        write-host ""
    }
    if(-not(test-path -path yt-dlp.exe)){
        write-host "ERROR: could not find yt-dlp. Null functionality" -ForegroundColor Red
    }
    if($url){
        Write-host "URL: $url" -ForegroundColor Cyan
        Write-host ""
        $urltitle = Invoke-RestMethod "https://title.mihir.ch/$url"
        if($?){
            write-host "Title: $urltitle" -ForegroundColor Cyan
        }
        else{
            Write-Warning "Could not obtain title"
        }
    }
    else{
        Write-host "URL not selected yet"
        Write-host ""
    }
    Write-host "[url] Pick an url beforehand"
    Write-host "[1] Music" -ForegroundColor Cyan
    Write-host "[2] Video / Full content"
    Write-host "[3] Update" -ForegroundColor Cyan
    Write-host "[4] About"
    Write-host "[5] Quit" -ForegroundColor Cyan
    Write-host ""
    Write-host "[advanced] Custom download"
    Write-host ""
    $decision = read-host "Pick an option"
    switch($decision){
        url {
            geturl
        }
        1 {
            if(-not($url)){
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            Write-host ""
            Write-host "Downloading MP3.." -ForegroundColor Cyan
            .\yt-dlp -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 $url
            Write-host ""
            write-host "Successfully downloaded" -ForegroundColor Green
            exit
        }
        2{
            if(-not($url)){
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host "Downloading content in the best quality possible..." -ForegroundColor Cyan
            .\yt-dlp -S ext:mp4:m4a -o "%(title)s.%(ext)s" $url
            write-host "Download finished" -ForegroundColor Green
            exit
        }
        3 {
            write-host ""
            write-host "Updating PowerDownloader" -ForegroundColor Yellow
            Write-Host ""
            Remove-Item PowerDownloader-Windows.ps1
            if(-not($?)){
                Write-Warning "Could not delete the previous version"
                Write-host "Please run PowerDownloader in it's folder or install in a directory with permits" -ForegroundColor Yellow
                exit
            }
            Invoke-WebRequest -uri "https://raw.githubusercontent.com/contratop/PowerDownloader/main/PowerDownloader-Windows.ps1" -OutFile PowerDownloader-Windows.ps1
            if(-not($?)){
                Write-host "Error when downloading the update"
                exit
            }
            Write-host "Updated succesfully" -ForegroundColor Green
            exit
        }
        4 {
            write-host ""
            Write-host "PowerDownloader $ver" -ForegroundColor Cyan
            write-host "Made by ContratopDev in Powershell"
            write-host "For windows 7 owards"
            write-host "Want it for android? check README.md"
            Pause
        }
        5{
            Clear-Host
            write-host "Exiting PowerDownloader..." -ForegroundColor Cyan
            exit
        }
        advanced {
            if(-not($url)){
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host "Obtaining format list..." -ForegroundColor Cyan
            yt-dlp -F $url
            write-host ""
            write-host "If there's any error, please type" -ForegroundColor Cyan -NoNewline
            write-host "[back]" -ForegroundColor Yellow
            write-host "You can also use [best] for the best option in your case" -ForegroundColor Cyan
            $fcode = read-host "Select code format"
            if($fcode -eq "Back"){
                write-host "Reversing changes"
                Start-Sleep -s 2
            }
            else {
                Clear-Host
                write-host "URL: $url"
                if($fcode -eq "best"){
                    write-host "Format code: $fcode (Automatic Max Quality)" -ForegroundColor Cyan
                }
                else{
                    write-host "Format code: $fcode (Manual)"
                }
                write-host ""
                write-host "Downloading content..." -ForegroundColor Cyan
                .\yt-dlp -o "%(title)s.%(ext)s" -f $fcode $url
                write-host ""
                write-host "Successfully downloaded" -ForegroundColor Green
                exit
            }
        }   




        default {
            Write-Warning "This option is not valid"
            start-sleep -s 2}
    } 
}
