function Get-StartFolder {
	Set-Location $StartFolder
}
New-Alias -Name ads -Value Get-StartFolder
Export-ModuleMember -Function Get-StartFolder -Alias ads
