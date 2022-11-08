Clear-Host
$version = "1.0"
write-host "PowerDownloader Safe Updater $version" -ForegroundColor Cyan

function safecheck {
    # Check 1: Winget Check
    if (-not(Get-Command "winget" -ErrorAction SilentlyContinue)) {
        Write-Warning "Winget not found"
        write-host "run Far-Resolver form github.com/contratop/far-resolver"
        break
    }
    else {
        write-host "Winget OK" -ForegroundColor Green
    }
    # Check 2: Git Command
    if (-not(Get-Command "git" -ErrorAction SilentlyContinue)) {
        $check2 = Read-Host"Git not installed, install? (y/n)"
        if ($check2 -eq "y") {
            write-host "Installing Git"
            winget install git.git
            write-host "Please restart the script after installing Git"
            break
        }
        else {
            write-host "Git not installed" -ForegroundColor Yellow
            Write-Warning "Safe Updater will not work without Git"
            break
        }
    }
    else {
        write-host "Git OK" -ForegroundColor Green
    }
    # Check 3: Same Directory
    if (-not(test-path -path yt-dlp.exe)) {
        write-host "Not detected in the same directory as yt-dlp.exe" -ForegroundColor Yellow
        write-host "Current Directory: $pwd"
        $check3 = Read-Host "Continue? (continue)"
        if ($check3 -ne "continue") {
            break
        }

    }
    else {
        write-host "Same Directory OK" -ForegroundColor Green
    }

}

""
""


$confirm = Read-Host "to update, type [update]"

if ($confirm -eq "update") {
    write-host "Initializing Safe Update sequence..." -ForegroundColor Cyan
    $cachedir = $pwd
    if (-not($?)) {
        Write-Warning "Error: Could not get current directory"
        $null = Read-Host "Press any key to exit"
        exit
    }
    write-host "Current Directory: $cachedir (SAVED!)" -ForegroundColor Green
    start-sleep -s 1
    write-host "Directory up..."
    start-sleep -s 1
    Set-Location ..
    if (-not($?)) {
        Write-Warning "Error: Could not change directory"
        $null = Read-Host "Press any key to exit"
        exit
    }
    write-host "Directory up OK" -ForegroundColor Green
    start-sleep -s 1
    write-host "Removing directory..."
    start-sleep -s 2
    Remove-Item -Recurse -Force $cachedir
    if (-not($?)) {
        Write-Warning "Error: Could not remove directory"
        $null = Read-Host "Press any key to exit"
        exit
    }
    write-host "Directory Removed" -ForegroundColor Green
    start-sleep -s 1
    write-host "Cloning repository..."
    start-sleep -s 2
    git clone "https://github.com/contratop/powerdownloader"
    if (-not($?)) {
        Write-Warning "Error: Could not clone repository"
        $null = Read-Host "Press any key to exit"
        exit
    }
    write-host "Repository cloned" -ForegroundColor Green
    start-sleep -s 1
    write-host "Safe Update sequence complete" -ForegroundColor Green
    $null = Read-Host "Press any key to exit"
    exit


}
else {
    write-host "Update cancelled"
    break
}