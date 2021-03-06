$dir = (Get-Location).ToString()
$umdDir = $dir + "\UMD"
$src = $dir + "\src"
$unumd = $dir + "\Tools\unumd.exe"

Invoke-Expression -Command ./setpath.ps1

$dirConfig = Get-Content -Path ./directory.ini
$configData = ConvertFrom-StringData -StringData $dirConfig
$systemDir = $configData["SystemFolder"]
$systemUMD = $systemDir + "\UMDS\Blacklist.umd"


$existingUMD = $umdDir + "\Blacklist.umd"
$test = Test-Path -Path $existingUMD
if ($test -eq $true)
{
    $blacklistFile = Get-Item $existingUMD
    if ($blacklistFile.length/1MB -gt 5)
    {
        Remove-Item $blacklistFile
        Copy-Item -Path $systemUMD -Destination $umdDir
    }
}
else 
{
    Copy-Item -Path $systemUMD -Destination $umdDir
}



New-Item $umddir\Temp -ItemType Directory -ea 0
Remove-Item $umddir\Temp\*.umd
Start-Process -NoNewWindow -FilePath $unumd -ArgumentList "-unpack -noxor -path=$umddir -out=$umddir\Temp" -wait
Rename-Item $umddir\Temp\Blacklist.umd Uncompressed.umd
Start-Process -NoNewWindow -FilePath $unumd -ArgumentList "-noxor -path=$umddir -out=$src" -wait
Move-Item $umddir\Temp\Uncompressed.umd $umddir
Remove-Item $umddir\Temp

Write-Host "Generating manifest. Please wait..."
Start-Process -NoNewWindow -FilePath "python" -ArgumentList "manifest.py"