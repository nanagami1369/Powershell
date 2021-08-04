#起動時のフォルダーへアクセスしやすくする
Set-Variable -Scope 'Global' -Option 'Constant' -Name 'StartFolder' -Value $PWD
function global:Get-StartFolder {
    Set-Location $StartFolder
}
New-Alias -Name ads -Value Get-StartFolder

#tmpフォルダーへアクセスしやすくする
Set-Variable -Scope 'Global' -Option 'Constant' -Name 'TMP' -Value $env:TMP
#起動時のエラー音を削除
Set-PSReadLineOption -BellStyle None

#おまじない
if ($PSVersionTable.Platform -eq 'Win32NT') {
    Get-ChildItem (Join-Path $PSScriptRoot \Modules) | Import-Module
}
if ($PSVersionTable.Platform -eq 'Unix') {
    Get-ChildItem "$HOME/.local/share/powershell/Modules" | Import-Module
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#promptの修正
function isAdmin {
    if ($PSVersionTable.Platform -eq 'Win32NT') {
        return	([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole( [Security.Principal.WindowsBuiltInRole] 'Administrator')
    }
    if ($PSVersionTable.Platform -eq 'Unix') {
        return $env:USER -eq 'root'
    }
    return false;
}

function promptSetting {
    $ESCColor = [string]"`e[32m"
    $promptFront = [char]'>'
    if (isAdmin) {
        $ESCColor = [string]"`e[31m"
        $promptFront = [char]'#'
    }
    "$ESCColor$((Get-Location).Path.Replace($HOME, '~'))`e[0m$(git branch --show-current)$promptFront"
}
function prompt() {
    promptSetting
}

#キーバインドをEmacs風に
Set-PSReadLineOption -EditMode Emacs

#補完をtabで出来るように
Set-PSReadLineKeyHandler -Chord tab -Function MenuComplete

# 起動時のコメント
Write-Host 'Welcome to my PowerShell'$Host.Version.ToString() -ForegroundColor Blue
