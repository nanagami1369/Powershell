function Get-AllItem {
	Get-ChildItem -Force $args
}
function Get-Env {
	Get-ChildItem Env:*$args*
}
function Update-Item {
	[CmdletBinding()]
	param(
		[Parameter(
			ValueFromPipeline = $true,
			Position = 1,
			ValueFromPipelineByPropertyName = $True,
			Mandatory = $true
		)]
		[ValidateNotNullOrEmpty()]
		$path
	)

	process {
		if (Test-Path $path) {
			# 存在する場合 (ファイルの更新日時を変更)
			Set-ItemProperty -Path $path -Name LastWriteTime -Value $(Get-Date)
		}
		else {
			# 存在しない場合 (ファイルを作成)
			New-Item -Type File "$path"
		}
	}
}


New-Alias la Get-AllItem
New-Alias ll Get-ChildItem
New-Alias -Name touch -Value Update-Item
New-Alias -Name printenv -Value Get-Env
New-Alias .. cd..
Export-ModuleMember -Function Get-AllItem, Get-Env, Update-Item
Export-ModuleMember -Alias ll, la, printenv, .., touch, whith
