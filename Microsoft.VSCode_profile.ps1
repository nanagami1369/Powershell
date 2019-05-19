#helpコマンドが文字化けを起こすので治るまでUTF-8にしない
# chcp 65001

#起動時のフォルダーを取得
Set-Variable -Scope "Global" -Option "Constant" -Name "StartFolder" -Value $PWD

#起動時のエラー音を削除
Set-PSReadlineOption -BellStyle None

#おまじない
Get-ChildItem $HOME\OneDrive\vscode\PowerShell\Modules | Import-Module
#ESC文字の登録(文字色の変換に使う)
$ESC = [char]27

#promptの修正
function prompt() {
	[string]$Prompt = Get-Location
	"$ESC[32m" + ($Prompt.Replace($HOME, "$ESC[0m~$ESC[32m")) + "$ESC[0m>"
}

# 起動時のコメント
Write-Host "Welcome to my PowerShell.exe" -ForegroundColor Blue
