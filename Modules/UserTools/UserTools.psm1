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

#Dockerから使われなくなったNoneコンテナを削除する関数
# 注意dockerをインストールしていないと使えない
function Remove-NoneImagesForDocker {
    docker image ls | ForEach-Object { if ($_ -match '<none>') { ($_ -split '\s\s*')[2] } } | ForEach-Object { docker image rm $_ }
}

#他人にシェルを見せる場合にプロンプトからパス情報を消す関数
function Set-SecretPrompt {
    function global:prompt() {
        $ESC = [char]27
        $ESCColor = [string]'[32m'
        $promptFront = [char]'>'
        return "$ESC$ESCColor" + '~/sample' + "$ESC[0m$promptFront"
    }
}
Export-ModuleMember -Function New-ModuleSet , Search-Location, Remove-NoneImagesForDocker, Set-SecretPrompt
