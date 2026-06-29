<#
.SYNOPSIS
  LinguaCafe Dev Main - 数据库导入脚本
.DESCRIPTION
  从 SQL 文件导入数据库。不会 drop 现有数据库。
#>

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))

Write-Host "============================================"
Write-Host " LinguaCafe Dev Main - 数据库导入"
Write-Host "============================================"
Write-Host ""

# 1. 确认 SQL 文件路径
$sqlPath = Read-Host "请输入 SQL 备份文件路径（拖拽文件到此处）"
if (-not (Test-Path $sqlPath)) {
    Write-Error "文件不存在: $sqlPath"
    exit 1
}

Write-Host "  SQL 文件: $sqlPath"

# 2. 确认数据库名
$defaultDb = "linguacafe_fsrs"
$dbName = Read-Host "请输入数据库名 (默认: $defaultDb)"
if ([string]::IsNullOrWhiteSpace($dbName)) {
    $dbName = $defaultDb
}
Write-Host "  数据库: $dbName"

# 3. 检查 mysql CLI
$mysqlPath = Get-Command mysql -ErrorAction SilentlyContinue
if (-not $mysqlPath) {
    # 尝试 MariaDB 默认路径
    $candidates = @(
        "C:\Program Files\MariaDB 12.3\bin\mysql.exe",
        "C:\Program Files\MariaDB 11*\bin\mysql.exe",
        "C:\Program Files\MySQL*\bin\mysql.exe"
    )
    foreach ($c in $candidates) {
        $resolved = Resolve-Path $c -ErrorAction SilentlyContinue
        if ($resolved) {
            $mysqlPath = $resolved.Path
            break
        }
    }
}

if (-not $mysqlPath) {
    Write-Error "找不到 mysql CLI。请确保 MariaDB/MySQL 已安装并加入 PATH。"
    exit 1
}

Write-Host "  mysql CLI: $mysqlPath"

# 4. 创建数据库(如果不存在)
Write-Host ""
Write-Host "[1/3] 确保数据库存在..."
& $mysqlPath -u root -p -h 127.0.0.1 -P 3306 -e "CREATE DATABASE IF NOT EXISTS \`$dbName\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
if ($LASTEXITCODE -ne 0) {
    Write-Error "数据库创建失败。请确认连接信息。"
    exit 1
}
Write-Host "  数据库 $dbName 已就绪"

# 5. 导入 SQL
Write-Host ""
Write-Host "[2/3] 导入 SQL 文件（此步骤可能需要几分钟）..."
& $mysqlPath -u root -p -h 127.0.0.1 -P 3306 $dbName < $sqlPath
if ($LASTEXITCODE -eq 0) {
    Write-Host "  SQL 导入成功"
} else {
    Write-Error "SQL 导入失败，请检查 SQL 文件格式。"
    exit 1
}

# 6. 完成
Write-Host ""
Write-Host "[3/3] 完成！"
Write-Host ""
Write-Host "数据库 $dbName 已导入。"
Write-Host "下一步：运行 start-linguacafe.ps1 启动项目。"
Write-Host ""
Write-Host "注意事项："
Write-Host "  - 不要运行 migrate:fresh（会销毁数据）"
Write-Host "  - 不要运行 db:wipe"
Write-Host "  - 如需清理，请手动操作数据库"
pause
