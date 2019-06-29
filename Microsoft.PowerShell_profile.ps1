chcp 65001

#起動時のフォルダーを取得
Set-Variable -Scope "Global" -Option "Constant" -Name "StartFolder" -Value $PWD

#起動時のエラー音を削除
Set-PSReadlineOption -BellStyle None

#おまじない
#ESC文字の登録(文字色の変換に使う)
Import-Module New-ModuleSet
Import-Module wsl-comannds
Import-Module Get-StartFolder
Import-Module Search-Location
Import-Module posh-vagrant
$ESC = [char]27

#promptの修正
function prompt() {
	[string]$Prompt = Get-Location
	"$ESC[32m" + ($Prompt.Replace($HOME, "~$ESC[32m")) + "$ESC[0m>"
}

# 起動時のコメント
Write-Host "Welcome to my PowerShell.exe" -ForegroundColor Blue
