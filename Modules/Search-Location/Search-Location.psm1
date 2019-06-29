# 注意scoopをインストールしてないと動かない
function Search-Location {
	param (
		[string]$FilePath = ""
	)
	scoop which $FilePath;
}
New-Alias -Name which -Value Search-Location
Export-ModuleMember  -Alias whith -Function Search-Location
