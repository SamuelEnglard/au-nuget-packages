
Import-Module au

function global:au_GetLatest {
    $assets = Get-GitHubRelease -OwnerName ruffle-rs -RepositoryName ruffle | Sort-Object ID -Descending | Select-Object -First 1 -ExpandProperty assets | ForEach-Object {
        if ($_.name -match '^ruffle-nightly-(?<date>\d{4}_\d{2}_\d{2})-(?<platform>\w+)-(?<subplatform>[\w-]+)') {
            Write-Output (Add-Member -InputObject $_ -NotePropertyMembers @{
                Platform="$($Matches.platform)"
                SubPlatform="$($Matches.subplatform)"
                Version="$($Matches.date -replace '_','.')-nightly"
            } -PassThru)
        }
    } | Where-Object platform -eq 'windows'
    return @{
        Version = ($assets | Select-Object -First 1 -ExpandProperty Version)
        URL32 = ($assets | Where-Object SubPlatform -eq "x86_32" | Select-Object -First 1 -ExpandProperty browser_download_url)
        URL64 = ($assets | Where-Object SubPlatform -eq "x86_64" | Select-Object -First 1 -ExpandProperty browser_download_url)
    }
}
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package -NoCheckUrl