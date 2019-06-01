function Set-MyAlias {
	Param(
		#参照先
		[Parameter(Mandatory)]
		[string]$fromFileName,
		#作成されるリンクの名前
		[string]$linkName = $PWD,
		# なにを作るのかデフォルトだとシンボリックリンク
		[char]$option
	)
	if (!(Test-Path $fromFileName)) {
		Write-Error -Message 参照元のファイルが存在しません。
	}
	if ((Split-Path $linkName | Select-Object -Property Length) -lt 1) {

	}
}
Export-ModuleMember -Function Set-MyAlias
