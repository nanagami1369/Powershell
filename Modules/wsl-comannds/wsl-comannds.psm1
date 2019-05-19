function Start-fishShell {
	wsl fish $args
}
New-Alias -Name fish -Value Start-fishShell
function Get-AllItem {
	Get-ChildItem -Force $args
}
New-Alias la Get-AllItem
New-Alias ll Get-ChildItem
function Get-Env {
	Get-ChildItem Env:*$args*
}
New-Alias printenv Get-Env
Export-ModuleMember -Function Start-fishShell, Get-AllItem,Get-Env
Export-ModuleMember -Alias fish, ll, la, printenv
