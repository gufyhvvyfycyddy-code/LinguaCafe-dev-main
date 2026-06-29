<#
.SYNOPSIS
  LinguaCafe Dev Main - Windows 依赖安装脚本
.DESCRIPTION
  检查环境并在首次运行时安装 Composer / npm 依赖。
  不会修改 package.json。
  不会运行 npm audit fix 或 npm update。
#>

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))

Write-Host "============================================"
Write-Host " LinguaCafe Dev Main - 依赖安装"
Write-Host "============================================"
Write-Host ""

# 1. 检查环境
Write-Host "[1/5] 检查环境..."
$hasPhp = $null -ne (Get-Command php -ErrorAction SilentlyContinue)
$hasComposer = $null -ne (Get-Command composer -ErrorAction SilentlyContinue)
$hasNode = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
$hasNpm = $null -ne (Get-Command npm -ErrorAction SilentlyContinue)

if (-not $hasPhp) { Write-Warning "php 未安装，请安装 PHP 8.2+" }
if (-not $hasComposer) { Write-Warning "composer 未安装" }
if (-not $hasNode) { Write-Warning "node 未安装" }
if (-not $hasNpm) { Write-Warning "npm 未安装" }

if (-not ($hasPhp -and $hasComposer -and $hasNode -and $hasNpm)) {
    Write-Error "环境不完整，请先安装缺失工具。"
    exit 1
}

Write-Host "  php: $(php -v | Select-Object -First 1)"
Write-Host "  composer: $(composer -V | Select-Object -First 1)"
Write-Host "  node: $(node -v)"
Write-Host "  npm: $(npm -v)"

# 2. 检查 vendor
Write-Host ""
Write-Host "[2/5] 检查 vendor/..."
$vendorDir = Join-Path $projectRoot "vendor"
if (-not (Test-Path (Join-Path $vendorDir "autoload.php"))) {
    Write-Host "  vendor 不存在，准备安装 composer 依赖..."
    Set-Location $projectRoot
    composer install --no-dev --ignore-platform-req=ext-pcntl --ignore-platform-req=ext-posix --prefer-dist --no-progress -o
    Write-Host "  composer install 完成"
} else {
    Write-Host "  vendor 已存在，跳过"
}

# 3. 检查 node_modules
Write-Host ""
Write-Host "[3/5] 检查 node_modules..."
$nmDir = Join-Path $projectRoot "node_modules"
if (-not (Test-Path $nmDir)) {
    Write-Host "  node_modules 不存在，准备安装 npm 依赖..."
    Set-Location $projectRoot
    npm install --legacy-peer-deps --package-lock=false
    Write-Host "  npm install 完成"
} else {
    Write-Host "  node_modules 已存在，跳过"
}

# 4. 固定 webpack 版本
Write-Host ""
Write-Host "[4/5] 固定 webpack 版本..."
Set-Location $projectRoot
npm install --no-save --package-lock=false laravel-mix@6.0.49 webpack@5.88.2 webpack-cli@4.10.0
Write-Host "  webpack 版本固定完成"

# 5. 完成
Write-Host ""
Write-Host "[5/5] 完成！"
Write-Host ""
Write-Host "下一步：运行 import-linguacafe-db.ps1 导入数据库，然后运行 start-linguacafe.ps1 启动。"
