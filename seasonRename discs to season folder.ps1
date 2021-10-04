

$basePath = Read-Host -Prompt 'video folder (press enter for [c:\video])'
if ([string]::isNullOrWhiteSpace($basePath)){
    $basePath = "c:\video"
}
$showName = Read-Host -Prompt 'show name'
$seasonNumber = [int](Read-Host -Prompt 'season number')
$seasonNumber = "{0:d2}" -f $seasonNumber
$seasonPath = "$basePath\$showName\season $seasonNumber\"
$logFile = "${basepath}\logs\$(get-date -Format "yyyy-MM-dd_HH.mm")_seasonmove.log"
if (!(Test-Path $logFile)){
    if (!(Test-Path "${basepath}\logs\")){
        New-Item -ItemType Directory -Path "${basepath}\logs"
    }
    new-item -ItemType File -Path $logFile
}

if (!(test-path $seasonPath)){
    $folderConfirmation = read-host -Prompt "($seasonPath) does not exist. Create it? (y/n)"
    if ($folderConfirmation -eq 'y'){
        new-item -ItemType directory -path $seasonPath #-WhatIf
        "Directory $seasonPath does not exist and was created`n"| Out-File -FilePath logFile -Append
    }
    elseif ($folderConfirmation -ne 'y') {
        exit
    }
}

$episodeNumber = 01 # starting episode number
$discNumber = 1
$directories = Get-ChildItem $seasonPath -Directory


foreach ($folder in $directories) {
    if ($folder.pschildname -eq "Disc $discNumber") {
        $files = get-childitem $folder -Recurse -file

        foreach ($file in $files){

            if (((get-item $($file.FullName)).Extension) -eq '.mkv'){
                
                $episodeNumber = "{0:d2}" -f $episodeNumber
                $sequence = "$showName - S$($seasonNumber)E$episodeNumber"
                #copy-Item -Path $($file.FullName) -destination "$seasonPath\$sequence.mkv" #-WhatIf
                move-Item -Path $($file.FullName) -destination "$seasonPath\$sequence.mkv" #-WhatIf
                $episodeNumber = [int]$episodeNumber
                $episodeNumber ++
                # "File $($file.FullName) renamed and coppied to $($seasonPath)$($sequence).mkv" | Out-File -FilePath $logFile -Append
                "File $($file.FullName) renamed and moveded to $($seasonPath)$($sequence).mkv" | Out-File -FilePath $logFile -Append
        
            }
        
        }

        $discNumber ++
    }
}






