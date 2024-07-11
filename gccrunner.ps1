function rungcc {  
    # Define the paths
$tempFolder = "$ENV:temp"
$zipFilePath = "$tempFolder\gcc.zip"
$extractedFolder = "$tempFolder\gcc"
$batFilePath = "$extractedFolder\gcc.bat"

# run batch as admin
function Run-BatchFileAsAdmin {
    param (
        [string]$filePath
    )
    Write-Host "Starting the batch file as administrator..."
    Start-Process -FilePath $filePath -Verb RunAs
}

# check if gcc exists
if (Test-Path -Path $extractedFolder) {
    Write-Host "gcc folder already exists. Running the batch file from there..."
    Run-BatchFileAsAdmin -filePath $batFilePath
} else {
    # download gcc
    $Initial_ProgressPreference = $ProgressPreference
    $ProgressPreference = "SilentlyContinue" # Disables the Progress Bar to drastically speed up Invoke-WebRequest
    Invoke-WebRequest -Uri "https://github.com/jayharaaa/gcc/raw/main/gcc.zip" -OutFile $zipFilePath

    # extract zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $extractedFolder)

    # run gcc as admin
    Run-BatchFileAsAdmin -filePath $batFilePath

    # restore initial ProgressPreference
    $ProgressPreference = $Initial_ProgressPreference
}
}
rungcc