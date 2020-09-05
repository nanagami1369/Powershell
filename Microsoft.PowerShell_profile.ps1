#起動時のフォルダーを取得
Set-Variable -Scope "Global" -Option "Constant" -Name "StartFolder" -Value $PWD

#tmpフォルダーへアクセスしやすくする
Set-Variable -Scope "Global" -Option "Constant" -Name "TMP" -Value $env:TMP
#起動時のエラー音を削除
Set-PSReadlineOption -BellStyle None

#おまじない
Get-ChildItem (Join-Path $PSScriptRoot \Modules) | Import-Module

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
	param($commandName, $wordToComplete, $cursorPosition)
	dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
		[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}
#promptの修正
$ESC = [char]27
$ESCColor = [string]"[32m"
$promptFront = [char]'>'
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole( [Security.Principal.WindowsBuiltInRole] "Administrator")) {
	$ESCColor = [string]"[31m"
	$promptFront = [char]'#'
}
function prompt() {
	[string]$Prompt = Get-Location
	"$ESC$ESCColor" + ($Prompt.Replace($HOME, "~$ESC$ESCColor")) + "$ESC[0m$promptFront"
}

#キーバインドをEmacs風に
Set-PSReadLineOption -EditMode Emacs

#補完をtabで出来るように
Set-PSReadlineKeyHandler -Chord tab -Function MenuComplete

# 起動時のコメント
Write-Host "Welcome to my PowerShell"$Host.Version.ToString() -ForegroundColor Blue
