function rungcc {
    # Define the paths
    $tempFolder = "$ENV:temp"
    $zipFilePath = "$tempFolder\gcc.zip"
    $extractedFolder = "$tempFolder\gcc"
    $batFilePath = "$extractedFolder\gcc.bat"

    # Run batch as admin
    function Run-BatchFileAsAdmin {
        param (
            [string]$filePath
        )
        Write-Host "Starting the batch file as administrator..."
        Start-Process -FilePath $filePath -Verb RunAs
    }

    # Remove existing gcc folder if it exists
    if (Test-Path -Path $extractedFolder) {
        Write-Host "existing gcc folder found. deleting it to ensure newest version is used..."
        Remove-Item -Recurse -Force $extractedFolder
    }

    # Download gcc
    $Initial_ProgressPreference = $ProgressPreference
    $ProgressPreference = "SilentlyContinue" # Disables the Progress Bar to drastically speed up Invoke-WebRequest
    Invoke-WebRequest -Uri "https://github.com/jayharaaa/gcc/raw/main/gcc.zip" -OutFile $zipFilePath

    # Extract zip
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $extractedFolder)

    # Run gcc as admin
    Run-BatchFileAsAdmin -filePath $batFilePath

    # Restore initial ProgressPreference
    $ProgressPreference = $Initial_ProgressPreference
}

rungcc
