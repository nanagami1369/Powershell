# 絶対にWindowsPowerShellで実行してください
#コマンドプロンプトを最低限使いやすくする
Set-Variable -Name OneDrive -Value $HOME\OneDrive\
New-Item -path $HOME -Name bat_commands -ItemType Junction -Value $Onedrive\vscode\cmd\bat_commands
# Powershellの使用準備
#Powershell Core
New-Item -Path $HOME\Documents\ -Name Powershell -ItemType Junction -Value $OneDrive\vscode\PowerShell\
#Windows PowerShell
New-Item -Path $HOME\Documents\WindowsPowerShell -Name Microsoft.PowerShell_profile.ps1 -ItemType SymbolicLink -Value $OneDrive\vscode\PowerShell\Windows\Microsoft.PowerShell_profile.ps1

#標準プリインストールアプリを削除
Get-Appxpackage -Name *Microsoft.ZuneMusic* | Remove-Appxpackage
Get-Appxpackage -Name *MicrosoftStickyNotes* | Remove-Appxpackage
Get-Appxpackage -Name *Microsoft.3DViewer* | Remove-Appxpackage
Get-Appxpackage -Name *Xbox* | Remove-Appxpackage
Get-Appxpackage -Name *Microsoft.Windows.Photos* | Remove-Appxpackage
Get-Appxpackage -Name *Microsoft.WindowsMaps* | Remove-Appxpackage
Get-Appxpackage -Name *Microsoft.ZuneVideo* | Remove-Appxpackage
Get-Appxpackage -Name *Microsoft.BingWeather* | Remove-Appxpackage
Get-AppxPackage -Name *Microsoft.GetHelp* | Remove-AppPackage
#scoop installed
Set-ExecutionPolicy -ExecutionPolicy -Scoop CurrentUser Unrestricted
iex (New-Object net.webclient).downloadstring('https://get.scoop.sh')
scoop install 7zip
scoop install dopamine
scoop install ffmpeg
scoop install GeekUninstaller
scoop install gimp
scoop install git
scoop install imagemagick
scoop install go
scoop install less
scoop install LLVM
scoop installmupdf
scoop install neofetch
scoop install nodejs
scoop install nomacs
scoop install pwsh
scoop install python
scoop install ruby
scoop install rufus
