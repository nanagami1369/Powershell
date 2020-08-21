#tmpフォルダーへアクセスしやすくする
Set-Variable -Scope "Global" -Option "Constant" -Name "TMP" -Value $env:TMP

#起動時のエラー音を削除
Set-PSReadlineOption -BellStyle None
#関数読み込み
function Update-Item {
	[CmdletBinding()]
	param(
		[Parameter(
			ValueFromPipeline = $true,
			Position = 1,
			ValueFromPipelineByPropertyName = $True,
			Mandatory = $true
		)]
		[ValidateNotNullOrEmpty()]
		$path
	)

	process {
		if (Test-Path $path) {
			# 存在する場合 (ファイルの更新日時を変更)
			Set-ItemProperty -Path $path -Name LastWriteTime -Value $(Get-Date)
		}
		else {
			# 存在しない場合 (ファイルを作成)
			New-Item -Type File "$path"
		}
	}
}
New-Alias -Name touch -Value Update-Item
function Start-fishShell {
	wsl fish $args
}
New-Alias -Name fish -Value Start-fishShell
function Get-AllItem {
	Get-ChildItem -Force $args
}
New-Alias la Get-AllItem
New-Alias ll Get-ChildItem
New-Alias .. cd..
function Get-Env {
	Get-ChildItem Env:*$args*
}
New-Alias -Name printenv -Value Get-Env
#ESC文字の登録(文字色の変換に使う)zzglobal:Get-AllItem
$ESC = [char]27
#promptの修正
function prompt() {
	[string]$Prompt = Get-Location
	"$ESC[32m" + ($Prompt.Replace($HOME, "~$ESC[32m")) + "$ESC[0m>"
}
#キーバインドをEmacs風に
Set-PSReadLineOption -EditMode Emacs
