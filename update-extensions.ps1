ForEach ($a in (Get-Item "Extensions\*.vsix")) {
    . "C:\Program Files\Microsoft VS Code\bin\Code.cmd" --verbose --install-extension "Extensions\$($a.Name)"
}
 