
# get the main video storage path and if nothing is entered assume c:\video
$basePath = Read-Host -Prompt 'video folder (press enter for [c:\video])'
if ([string]::isNullOrWhiteSpace($basePath)){
    $basePath = "c:\video"
}
# get the show name
$showName = Read-Host -Prompt 'show name'
# and the season number we will be organizing
$seasonNumber = [int](Read-Host -Prompt 'season number')
# make the season number double digits
$seasonNumber = "{0:d2}" -f $seasonNumber
# assemble the full path
$seasonPath = "$basePath\$showName\season $seasonNumber\"
# setup the log file
$logFile = "${basepath}\logs\$(get-date -Format "yyyy-MM-dd_HH.mm")_seasonmove.log"
if (!(Test-Path $logFile)){
    if (!(Test-Path "${basepath}\logs\")){
        New-Item -ItemType Directory -Path "${basepath}\logs"
    }
    new-item -ItemType File -Path $logFile
}

# create the season folder if it doesn't exist, with approval
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

#setup initial defaults
$episodeNumber = 01 # starting episode number
$discNumber = 1
$directories = Get-ChildItem $seasonPath -Directory

# iterate through the disc folders
foreach ($folder in $directories) {
    # verify that the folders are sequential and get the files
    if ($folder.pschildname -eq "Disc $discNumber") {
        $files = get-childitem $folder -Recurse -file

        # iterate through files
        foreach ($file in $files){

            # verify it has the right extensions
            if (((get-item $($file.FullName)).Extension) -eq '.mkv'){
                
                # rename and move stuff
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

        # inerate the disc number
        $discNumber ++
    }
}






