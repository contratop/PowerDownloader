Clear-Host

$ver = "0.2 (Development WIP)"

Write-host "Ver $ver"
Write-host "Checking System..."
if(-not(test-path -path yt-dlp.exe)){
    Write-Warning "La instalacion de PowerDownloader esta dañada (Faltan dependencias)"
    if(Get-Command git){
        $continue = read-host "Escriba [reinstall] para reinstalar la instalacion completa"
        if($continue -eq "reinstall"){
            $savedpwd = $PWD
            Set-Location ..
            Remove-Item -Recurse -Force $savedpwd
            git clone github.com/contratop/powerdownloader
            Set-Location powerdownloader
            Write-host "Reinstalacion completada, reinicie PowerDownloader" -ForegroundColor Green
            exit
        }
        else{
            Write-Warning "No se puede proceder sin reinstall"
            write-host "Esta instalacion esta dañada" -ForegroundColor Yellow
            exit
        }
    }
    else{
        Write-Warning "No se puede reinstalar automaticamentes porque falta git"
        write-host "Elimine PowerDownloader y reinstalelo de nuevo manualmente"
        exit
    }
}
if(-not(test-path -path ffmpeg.exe)){
    Write-Warning "ffmpeg no esta integrado"
    $confirm = read-host "Deseas descargarlo ahora? (120MB) [download]"
    if($confirm){
        Invoke-WebRequest -uri "https://github.com/contratop/PowerDownloader/releases/download/Dependencies/ffmpeg.exe" -OutFile ffmpeg.exe
        if(-not($?)){
            Write-Warning "Ha ocurrido un error al descargar ffmpeg"
            exit
        }
        write-host "Descarga de ffmpeg finalizada" -ForegroundColor Green
    }
}




function geturl{
    $script:url = read-host "Pega la URL aqui"
}

########################
# Menu Principal
########################
$whilemode = $true
while($whilemode){
    clear-host
    Write-host "PowerDownloader Version $ver"
    Write-host "by" -NoNewline
    Write-host "ContratopDev" -ForegroundColor Cyan
    Write-host ""
    if(-not(test-path -path ffmpeg.exe)){
        Write-Warning "ffmpeg no detectado, funcionalidad limitada"
        write-host ""
    }
    if($url){
        Write-host "URL: $url"
        Write-host ""
    }
    else{
        Write-host "URL aun no seleccionada"
        Write-host ""
    }
    Write-host "[url] Seleccionar una URL de antemano"
    Write-host "[1] Musica"
    Write-host "[2] Video / Contenido Integro"
    Write-host "[3] Actualizar"
    Write-host "[4] About"
    Write-host "[5] Salir"
    Write-host ""
    Write-host "[advanced] Descarga Personalizada"
    Write-host ""
    $decision = read-host "Seleccione una opcion"
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
            Write-host "Descargando MP3.." -ForegroundColor Cyan
            ty-dlp -o "$HOME\Desktop\%(title)s.%(ext)s" --extract-audio --audio-format mp3 $url
            Write-host ""
            write-host "Descarga finalizada" -ForegroundColor Green
            exit
        }
        2{
            if(-not($url)){
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host "Descargando la mejor version del contenido..." -ForegroundColor Cyan
            yt-dlp -S ext:mp4:m4a -o "$HOME\Desktop\%(title)s.%(ext)s" $url
            write-host "Descarga inalizada" -ForegroundColor Green
            exit
        }
        3 {
            write-host ""
            write-host "Actualizando PowerDownloader" -ForegroundColor Yellow
            Write-Host ""
            Remove-Item PowerDownloader.ps1
            if(-not($?)){
                Write-Warning "No se puede eliminar la version anterior"
                Write-host "Ejecute PowerDownloader en su carpeta o instalelo en un directorio con permisos" -ForegroundColor Yellow
                exit
            }
            Invoke-WebRequest -uri "https://raw.githubusercontent.com/contratop/powerdownloader/main/powerdownloader.ps1" -OutFile PowerDownloader.ps1
            if(-not($?)){
                Write-host "Error al descargar la actualizacion"
                exit
            }
            Write-host "Actualizacion finalizada" -ForegroundColor Green
            exit
        }
        4 {
            write-host ""
            Write-host "PowerDownloader $ver" -ForegroundColor Cyan
            write-host "Hecho por ContratopDev en Powershell"
            write-host "Para WIndows 7 en adelante"
            write-host "Quieres version android? consulta el README.md"
            Pause
        }
        5{
            Clear-Host
            write-host "Saliendo de PowerDownloader..." -ForegroundColor Cyan
            exit
        }
        advanced {
            if(-not($url)){
                geturl
            }
            Clear-Host
            write-host "URL: $url"
            write-host "OBteniendo lista de formatos..." -ForegroundColor Cyan
            yt-dlp -F $url
            write-host ""
            write-host "Si hay algun error, escribe [back]" -ForegroundColor Yellow
            write-host "Tambien puedes [best] para la mejor opcion" -ForegroundColor Cyan
            $fcode = read-host "Selecciona un formato"
            if($fcode -eq "Back"){
                write-host "Revirtiendo cambios"
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
                Write-host "Destino: $HOME\Desktop"
                write-host "Descargando el contenido..." -ForegroundColor Cyan
                yt-dlp -o "$HOME\Desktop\%(title)s.%(ext)s" -f $fcode $url
                write-host ""
                write-host "Descarga finalizada" -ForegroundColor Cyan
                exit
            }
        }   




        default {
            Write-Warning "Opcion no valida"
            start-sleep -s 2}
    } 
}
