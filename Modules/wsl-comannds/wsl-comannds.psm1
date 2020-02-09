function Start-fishShell {
	wsl fish $args
}
New-Alias -Name fish -Value Start-fishShell
function Get-AllItem {
	Get-ChildItem -Force $args
}
function Get-Env {
	Get-ChildItem Env:*$args*
}
New-Alias la Get-AllItem
New-Alias ll Get-ChildItem
New-Alias -Name touch -Value Update-Item
New-Alias -Name printenv -Value Get-Env
New-Alias  .. cd..
Export-ModuleMember -Function Start-fishShell, Get-AllItem, Get-Env
Export-ModuleMember -Alias fish, ll, la, printenv, ..
