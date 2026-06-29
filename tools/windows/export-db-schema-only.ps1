<#
.SYNOPSIS
  Export LinguaCafe database schema only.

.DESCRIPTION
  This script exports database structure only, without table data.
  It is safe for documentation/review purposes, but still should be reviewed before publishing.
  It does not record database passwords.
#>

$ErrorActionPreference = "Stop"

Write-Host "============================================"
Write-Host " LinguaCafe Dev Main - Schema Only Export"
Write-Host "============================================"
Write-Host ""

$dbName = Read-Host "Database name (default: linguacafe_fsrs)"
if ([string]::IsNullOrWhiteSpace($dbName)) {
    $dbName = "linguacafe_fsrs"
}

$outDir = Read-Host "Output directory (default: .\local-migration)"
if ([string]::IsNullOrWhiteSpace($outDir)) {
    $outDir = ".\local-migration"
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outFile = Join-Path $outDir "$dbName-schema-only-$stamp.sql"

$mysqldump = Get-Command mysqldump -ErrorAction SilentlyContinue
if (-not $mysqldump) {
    $candidates = @(
        "C:\Program Files\MariaDB 12.3\bin\mysqldump.exe",
        "C:\Program Files\MariaDB 11.4\bin\mysqldump.exe",
        "C:\Program Files\MariaDB 11*\bin\mysqldump.exe",
        "C:\Program Files\MySQL*\bin\mysqldump.exe"
    )

    foreach ($candidate in $candidates) {
        $resolved = Resolve-Path $candidate -ErrorAction SilentlyContinue
        if ($resolved) {
            $mysqldump = $resolved[0].Path
            break
        }
    }
}

if (-not $mysqldump) {
    Write-Error "mysqldump not found. Please install MariaDB/MySQL client tools or add them to PATH."
    exit 1
}

Write-Host "Using mysqldump: $mysqldump"
Write-Host "Output: $outFile"
Write-Host ""
Write-Host "You will be prompted for the database password by mysqldump."
Write-Host "The password will not be recorded by this script."
Write-Host ""

& $mysqldump -u root -p -h 127.0.0.1 -P 3306 --no-data --routines --triggers --events --default-character-set=utf8mb4 $dbName > $outFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "Schema export failed."
    exit 1
}

Write-Host ""
Write-Host "Schema-only SQL exported:"
Get-Item $outFile | Select-Object FullName, Length, LastWriteTime

Write-Host ""
Write-Host "Important:"
Write-Host "- This file contains schema only, no table data."
Write-Host "- Review before publishing."
Write-Host "- The repository ignores *.sql by default, so this will not be committed accidentally."
