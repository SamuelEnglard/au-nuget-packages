$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters
$installDir = $toolsPath
if ($pp.InstallDir -or $pp.InstallationPath ) {
    $InstallDir = $pp.InstallDir + $pp.InstallationPath
}
Write-Verbose "Ruffle is going to be installed in '$installDir'"
$packageArgs = @{
  packageName    = 'ruffle.portable'
  url            = 'https://github.com/ruffle-rs/ruffle/releases/download/nightly-2021-04-26/ruffle-nightly-2021_04_26-windows-x86_32.zip'
  url64bit       = 'https://github.com/ruffle-rs/ruffle/releases/download/nightly-2021-04-26/ruffle-nightly-2021_04_26-windows-x86_64.zip'
  checksum       = '0fe310eca225856f9fbb615b11a4fae2f1f0d06d87ade70edf62a2f2e76c59a5'
  checksum64     = '75fd27b70a06cfba5a1126259c8a16e1cc69efcfa4ca838ea4d9487bb15365fd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  unzipLocation  = $installDir
}
Install-ChocolateyZipPackage @packageArgs
