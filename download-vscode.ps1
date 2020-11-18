$tempdir = "c:\temp\vscode_update"
$tempdir_extensions = "$tempdir\extensions"
$tempdir_application = "$tempdir\vscode"

$blacklist = '.*(arduino|wsl|snippet|todo|puppet|vdf|jshint|cpptools|github' + `
    '|intellicode|pascal).*'

Remove-Item -Force -Recurse -ErrorAction SilentlyContinue $tempdir_extensions
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue $tempdir_application

New-Item -ItemType Directory -Force $tempdir | Out-Null
New-Item -ItemType Directory -Force $tempdir_extensions | Out-Null
New-Item -ItemType Directory -Force $tempdir_application | Out-Null

$vscode_url = 'https://vscode-update.azurewebsites.net/latest/win32-x64/stable'
.\curl.exe -L -o $tempdir_application\vscode-install.exe  $vscode_url

# Refresh extension list 
#if ( ( get-command code -ErrorAction SilentlyContinue ) -ne $null ) {
#    code --list-extensions >extensionlist
#} 

$extensions = get-content .\extensionlist

$line = 1

foreach ($ext in $extensions) {

    $line+=1

    $extensionPublisher = $ext.split('.')[0]
    $extensionName = $ext.split('.')[1]

    if ( $ext -match $blacklist ) {
        "Skipping extension $ext in line $line"
    } else {

        if ( test-path "$tempdir_extensions\$($extensionPublisher).$($extensionName)-latest.vsix" ) {
            "$($extensionName)-latest.vsix exists, not going to download again"
        } else {

            if ( $extensionPublisher -and  $extensionName ) {
                $url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/" + `
                "$($extensionPublisher)/vsextensions/$($extensionName)/latest/vspackage"
            } else {
                "WARNING: Cannot identified extiension in line $line"
                break 
            }
                
            $Retrycount = 0
            $Stoploop = $false

            do {
                try {
                    "Downloading $($extensionPublisher).$($extensionName)-latest.vsix from $($url)"

                    invoke-webrequest -uri $url -OutFile "$tempdir_extensions\$($extensionPublisher).$($extensionName)-latest.vsix"

                    Write-Host "Download completed"
                    $Stoploop = $true
                }
                catch {
                    if ($Retrycount -gt 5){
                        Write-Host "Could not download  after 5 retries. Giving up. "
                        $Stoploop = $true
                    }
                    else {
                        Write-Host "Could not download retrying in 30 minutes..."
                        Start-Sleep -Seconds 1800
                        $Retrycount = $Retrycount + 1
                    }
                }
            }
            While ($Stoploop -eq $false)

            "Waiting 3 minutes to avoid being blocked"
            Start-Sleep -seconds 180
        }
    }
}

Copy-Item .\update-vscode.ps1 $tempdir\ -Force
Copy-Item .\update-extensions.ps1 $tempdir\ -Force 

Remove-Item -Force $tempdir\vscode-plusextensions.zip*
.\7za.exe a -tzip -v100m $tempdir\vscode-plusextensions.zip $tempdir_extensions $tempdir_application $tempdir\update-vscode.ps1 $tempdir\update-extensions.ps1
.\7za.exe a -tzip $tempdir\vscode-plusextensions.zip $tempdir_extensions $tempdir_application $tempdir\update-vscode.ps1 $tempdir\update-extensions.ps1

Remove-Item "C:\Users\JanossyG\OneDrive - Unisys\Documents\Installers\vscode-plusextensions.zip*" -force
move-item $tempdir\vscode-plusextensions.zip* "C:\Users\JanossyG\OneDrive - Unisys\Documents\Installers\" -Force
