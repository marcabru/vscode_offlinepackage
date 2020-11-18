$tempdir = "c:\temp\vscode_update"

$tempdir_other_application = "$tempdir\other"

Remove-Item -Force -Recurse -ErrorAction SilentlyContinue $tempdir_other_application

New-Item -ItemType Directory -Force $tempdir | Out-Null
New-Item -ItemType Directory -Force $tempdir_other_application | Out-Null


# Firefox latest
#.\curl.exe -L -o $tempdir_other_application\firefox-install.msi "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US"
# Firefox ESR
.\curl.exe -L -o $tempdir_other_application\firefox-install.msi "https://download.mozilla.org/?product=firefox-esr-next-msi-latest-ssl&os=win64&lang=en-US"
.\curl.exe -L -o $tempdir_other_application\postman-install.exe "https://dl.pstmn.io/download/latest/win64"
.\curl.exe -L -o $tempdir_other_application\python3-install.exe "https://www.python.org/ftp/python/3.8.6/python-3.8.6-amd64.exe"
.\curl.exe -L -o $tempdir_other_application\python2-install.msi "https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi"
.\curl.exe -L -o $tempdir_other_application\ruby-install.exe "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.1-1/rubyinstaller-devkit-2.7.1-1-x64.exe"
.\curl.exe -L -o $tempdir_other_application\perl-install.msi "http://strawberryperl.com/download/5.32.0.1/strawberry-perl-5.32.0.1-64bit.msi"
.\curl.exe -L -o $tempdir_other_application\git-install.exe "https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe"
.\curl.exe -L -o $tempdir_other_application\winscp-install.exe "https://winscp.net/download/WinSCP-5.17.7-Setup.exe"
.\curl.exe -L -o $tempdir_other_application\putty-install.msi "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.74-installer.msi"


Copy-Item .\update-other.ps1 $tempdir\ -Force 

Remove-Item $tempdir\other.zip*
.\7za.exe a -tzip -v100m $tempdir\other.zip $tempdir_other_application  $tempdir\update-other.ps1
.\7za.exe a -tzip        $tempdir\other.zip $tempdir_other_application  $tempdir\update-other.ps1

Remove-Item "C:\Users\JanossyG\OneDrive - Unisys\Documents\Installers\other.zip*" -force
Move-Item $tempdir\other.zip* "C:\Users\JanossyG\OneDrive - Unisys\Documents\Installers\" -force