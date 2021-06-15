$files = get-childitem 'C:\video\once upon a time\season 01'
foreach ($file in $files){
    $fileNameMeat = ($file.name).Split(' - ')[-1]
    if ($fileNameMeat.startswith('S02')){
        $oldName = $fileNameMeat
        $newName = $oldName.Replace('02','01')
        Rename-Item -Path $($file.FullName) -NewName "Once Upon a Time - $newName"
    }
}