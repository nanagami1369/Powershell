chcp 65001

#起動時のフォルダーを取得
Set-Variable -Scope "Global" -Option "Constant" -Name "StartFolder" -Value $PWD

#起動時のエラー音を削除
Set-PSReadlineOption -BellStyle	 None

#おまじない
Get-ChildItem $HOME\OneDrive\vscode\PowerShell\Modules | Import-Module

#キーバインドをEmacs風に
Set-PSReadLineOption -EditMode Emacs

# 起動時のコメント
Write-Host "Welcome to my PowerShell.exe" -ForegroundColor Blue
