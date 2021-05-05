Start-Process -NoNewWindow -FilePath "python" -ArgumentList "pack.py" -wait

$dir = (Get-Location).ToString()
$dirConfig = Get-Content -Path ./directory.ini
$configData = ConvertFrom-StringData -StringData $dirConfig
$systemDir = $configData["SystemFolder"]
$umdDir = $systemDir + "\UMDS"

if ($systemDir -ne "")
{
    Write-Host "Blacklist System Folder found:"$systemDir
    $existingUMD = $umdDir + "\Blacklist.umd"
    try 
    {
        $blacklistFile = Get-Item $existingUMD
        if ($blacklistFile.length/1MB -lt 5)
        {
            # Blacklist.umd is compressed, so rename it as backup
            Rename-Item -Path $existingUMD -NewName $existingUMD".backup"
        }
        else
        {
            # Blacklist.umd is uncompressed, so delete it
            Remove-Item -Path $existingUMD
        }
    } catch {}

    $buildFile = $dir + "\Build\Blacklist.umd"
    Copy-Item -Path $buildFile -Destination $umdDir
    Write-Host "Done copying. Starting game..."
    $gameFile = $systemDir + "\blacklist_game.exe"
    Start-Process -FilePath $gameFile
}
else
{
    Write-Host "Blacklist System folder not configured in directory.ini"
}