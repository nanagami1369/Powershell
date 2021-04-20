#新しいモジュールを作る関数
function New-ModuleSet {
	Param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$ModuleName
	)
	$moduleDir = "$HOME\Documents\PowerShell\$ModuleName"
	if (Test-Path $moduleDir) {
		'This Module is Existing'
		break 1
	}
	# モジュールフォルダーへ移動
	Set-Location "$HOME\Documents\PowerShell\Modules"
	# 作成
	mkdir "$HOME\Documents\PowerShell\Modules\$ModuleName"
	Set-Location "$ModuleName"
	New-Item -Name "$ModuleName.psm1"
}

#指定したファイルorアプリの絶対パスを取得する関数
function Search-Location {
	[CmdletBinding()]
	param (
		[string]$FilePath = ''
	)
	if (Test-Path $FilePath) {
		return (Get-Item $FilePath).FullName
	}
	return (where.exe youtube-dl)[-1]
}

Export-ModuleMember -Function New-ModuleSet , Search-Location
