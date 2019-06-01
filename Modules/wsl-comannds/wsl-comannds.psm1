function Start-fishShell {
	wsl fish $args
}
New-Alias -Name fish -Value Start-fishShell
function Get-AllItem {
	Get-ChildItem -Force $args
}
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
function Get-Env {
	Get-ChildItem Env:*$args*
}
New-Alias la Get-AllItem
New-Alias ll Get-ChildItem
New-Alias -Name touch -Value Update-Item
New-Alias -Name printenv -Value Get-Env
Export-ModuleMember -Function Start-fishShell, Get-AllItem, Update-Item, Get-Env
Export-ModuleMember -Alias fish, ll, la, touch, printenv
