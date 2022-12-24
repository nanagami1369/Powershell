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
    return  where.exe $FilePath;
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

function powerlinePrompt {
    $defaulutOutput = [System.Console]::OutputEncoding
    [System.Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    & "$env:GOPATH\bin\powerline-go.exe" -modules 'venv,ssh,cwd,perms,git,hg,jobs,exit' -cwd-max-depth 2 -cwd-mode semifancy
    [System.Console]::OutputEncoding = $defaulutOutput
}

#プロンプトをPowerlinePromptに変更する
# 注意 powerline-goをインストールしていないと使えない
function Set-PowerlinePrompt {
    function global:prompt() {
        powerlinePrompt
    }
}

function isAdmin {
    if ($IsWindows) {
        return	([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole( [Security.Principal.WindowsBuiltInRole] 'Administrator')
    }
    if ($IsLinux) {
        return $env:USER -eq 'root'
    }
    return false;
}

function defaultPrompt {
    $ESCColor = [string]"`e[32m"
    $promptFront = [char]'>'
    if (isAdmin) {
        $ESCColor = [string]"`e[31m"
        $promptFront = [char]'#'
    }
    "$ESCColor$((Get-Location).Path.Replace($HOME, '~'))`e[0m$(git branch --show-current)$promptFront"
}
function prompt() {
    defaultPrompt
}


function Set-DefaultPrompt {
    function global:prompt() {
        promptSetting
    }
}

#ビデオから音声を抜き出す関数
# 注意ffmpegをインストールしていないと使えない
function Get-AudioFromVideo {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$path
    )
    $movie = Get-Item $path
    $codic = Get-AudioCodicFromVideo $movie.FullName
    $extension = $codic
    if ($codic -eq 'aac') {
        $extension = 'm4a'
    }
    $outputFilePath = $movie.Directory.ToString() + '\' + $movie.BaseName + '.' + $extension
    ffmpeg.exe -i $movie.FullName -acodec copy $outputFilePath
}

function Get-AudioCodicFromVideo {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$path
    )
    (ffmpeg.exe -i $path 2>&1 | Select-String 'Stream' | Select-String 'Audio')[0].Line -match '(?<=Audio: )[A-za-z0-9]*' > $null
    return $Matches[0]
}

# Youtubeから音声をダウンロードする関数
# 注意 yt-dlpをインストールしていないと使えない
function Get-AudioFromYoutube {
    param (
        [Parameter(
            ValueFromPipeline = $false,
            Position = 1,
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$url,
        [ValidateNotNullOrEmpty()]
        [String]$outputDirectory = $PWD
    )
    # 251 wabmの一番良い音質の形式
    # -x 動画コーディックから音声だけ抽出
    Push-Location $outputDirectory
    yt-dlp.exe $url.Split('&')[0] -x --cookies-from-browser firefox
    Pop-Location
}

# Youtubeから音声をダウンロードする関数
# 注意 yt-dlpをインストールしていないと使えない
function Get-VideoFromYoutube {
    param (
        [Parameter(
            ValueFromPipeline = $false,
            Position = 1,
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$url,
        [ValidateNotNullOrEmpty()]
        [String]$outputDirectory = $PWD
    )
    # 251 wabmの一番良い音質の形式
    Push-Location $outputDirectory
    yt-dlp.exe $url.Split('&')[0] --embed-thumbnail --cookies-from-browser firefox
    Pop-Location
}

function Get-DecordedUrl {
    param (
        [Parameter(
            ValueFromPipeline = $false,
            Position = 1,
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$url
    )
    Add-Type -AssemblyName System.Web
    [System.Web.HttpUtility]::UrlDecode($url);
}

function Get-DecordedUnicodeString {
    param (
        [Parameter(
            ValueFromPipeline = $false,
            Position = 1,
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$value
    )
    [System.Text.RegularExpressions.Regex]::Unescape($value)
}


Export-ModuleMember -Function New-ModuleSet , Search-Location, Remove-NoneImagesForDocker, Set-SecretPrompt, Get-AudioFromVideo, Set-PowerlinePrompt, Get-AudioFromYoutube, Set-DefaultPrompt, Get-VideoFromYoutube, Get-DecordedUrl, Get-DecordedUnicodeString
