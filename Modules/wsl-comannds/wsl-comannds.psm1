function Start-fishShell {
	wsl fish $args
}
New-Alias -Name fish -Value Start-fishShell
function Get-AllItem {
	Get-ChildItem -Force $args
}
New-Alias la Get-AllItem
New-Alias ll Get-ChildItem
Export-ModuleMember -Function Start-fishShell, Get-AllItem
Export-ModuleMember -Alias fish, ll, la
