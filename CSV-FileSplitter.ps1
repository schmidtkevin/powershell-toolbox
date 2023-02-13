# @author Kevin Schmidt
# @version 1.0
# @date 23-02-09

# Script that splits large csv-files efficiently
# @param $FilePath: path of the source file
# @param $MaxFileSize: Filesize each splitted file should have at max

$FilePath = "C:\Temp\csv-split\filename.csv" # insert path of .csv file
$MaxFileSize = 350MB # size of each splitted file
$FileIndex = 0 # starting index

$Header = Get-Content $FilePath | Select-Object -First 1
$CurrentFile = "$FilePath-$FileIndex.csv"

if (!(Test-Path -Path $CurrentFile)) {
    New-Item -ItemType File -Path $CurrentFile
}

Add-Content -Path $CurrentFile -Value $Header

Get-Content $FilePath | Select-Object -Skip 1 | ForEach-Object {
    $Line = $_
    Add-Content -Path $CurrentFile -Value $Line
    if((Get-Item $CurrentFile).Length -gt $MaxFileSize) {
        $FileIndex++
        $CurrentFile = "$FilePath-$FileIndex.csv"
        if (!(Test-Path -Path $CurrentFile)) {
            New-Item -ItemType File -Path $CurrentFile
        }
        Add-Content -Path $CurrentFile -Value $Header
    }
}
