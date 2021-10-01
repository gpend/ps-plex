$basePath = Read-Host -Prompt 'video folder (e.g. c:\video)'
$showName = Read-Host -Prompt 'show name'
$seasonNumber = [int](Read-Host -Prompt 'season number')
$seasonNumber = "{0:d2}" -f $seasonNumber
$seasonPath = "$basePath\$showName\season $seasonNumber\"
if (!(test-path $seasonPath)){
    $folderConfirmation = read-host -Prompt "($seasonPath) does not exist. Create it? (y/n)"
    if ($folderConfirmation -eq 'y'){
        new-item -ItemType directory -path $seasonPath -WhatIf
    }
    elseif ($folderConfirmation -ne 'y') {
        exit
    }
}
Write-Host "Please place files in $seasonPath"
Read-Host "Press enter to continue"
$episodeNumber = 01 # starting episode number
$files = get-childitem $seasonPath -Recurse -file
$logFile = "${basepath}logs\$(get-date -Format "yyyy-MM-dd_HH.mm")_seasonmove.log"
if (!(Test-Path $logFile)){new-item -ItemType File -Path $logFile}

foreach ($file in $files){

    if (((get-item $($file.FullName)).Extension) -eq '.mkv'){
        
        $episodeNumber = "{0:d2}" -f $episodeNumber
        $sequence = "$showName - S$($seasonNumber)E$episodeNumber"
        copy-Item -Path $($file.FullName) -destination "$seasonPath\$sequence.mkv" -WhatIf
        $episodeNumber = [int]$episodeNumber
        $episodeNumber ++
        "File $($file.FullName) renamed and copied to $seasonPath\$sequence.mkv" | Out-File -FilePath $logFile -Append

    }

}
