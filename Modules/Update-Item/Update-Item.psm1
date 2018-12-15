function Update-Item {
	foreach ($item in $args) {
		if (Test-Path $item) {
			# 存在する場合 (ファイルの更新日時を変更)
			Set-ItemProperty -Path $item -Name LastWriteTime -Value $(Get-Date)
		}
		else {
			# 存在しない場合 (ファイルを作成)
			New-Item -Type File "$item"
		}
	}
}
New-Alias -Name touch -Value Update-Item
Export-ModuleMember -Function Update-Item -Alias touch
