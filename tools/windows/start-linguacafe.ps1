<#
.SYNOPSIS
  LinguaCafe Dev Main - Windows 启动脚本
.DESCRIPTION
  启动 Laravel Server 和前端 Watch，打开浏览器。
  不会运行 migrate，不会修改 .env。
#>

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
Set-Location $projectRoot

Write-Host "============================================"
Write-Host " LinguaCafe Dev Main - 启动"
Write-Host "============================================"
Write-Host ""

# 1. 环境检查
Write-Host "[1/8] 检查环境..."
$hasPhp = $null -ne (Get-Command php -ErrorAction SilentlyContinue)
$hasComposer = $null -ne (Get-Command composer -ErrorAction SilentlyContinue)
$hasNode = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
$hasNpm = $null -ne (Get-Command npm -ErrorAction SilentlyContinue)

if (-not $hasPhp) { Write-Error "php 未安装" ; exit 1 }
if (-not $hasComposer) { Write-Warning "composer 未安装（部分功能可能受限）" }
if (-not $hasNode) { Write-Error "node 未安装" ; exit 1 }
if (-not $hasNpm) { Write-Error "npm 未安装" ; exit 1 }

Write-Host "  OK"

# 2. 检查 .env
Write-Host "[2/8] 检查 .env..."
$envFile = Join-Path $projectRoot ".env"
if (-not (Test-Path $envFile)) {
    Write-Error ".env 不存在！请从 .env.example.local 复制并填写数据库密码。"
    exit 1
}

# 检查是否仍为模板密码
$envContent = Get-Content $envFile -Raw
if ($envContent -match "请在本机填写自己的数据库密码") {
    Write-Warning ".env 中 DB_PASSWORD 仍为模板值，请先修改。"
    Write-Warning "按 Ctrl+C 退出，修改后再运行本脚本。"
    Write-Host ""
    pause
}

Write-Host "  OK"

# 3. 检查 vendor
Write-Host "[3/8] 检查 vendor/autoload.php..."
if (-not (Test-Path "vendor\autoload.php")) {
    Write-Error "vendor 不存在！请先运行 setup-deps-windows.ps1 或 composer install。"
    exit 1
}
Write-Host "  OK"

# 4. 检查 node_modules
Write-Host "[4/8] 检查 node_modules..."
if (-not (Test-Path "node_modules")) {
    Write-Error "node_modules 不存在！请先运行 setup-deps-windows.ps1 或 npm install。"
    exit 1
}
Write-Host "  OK"

# 5. 检查 .env 中的 APP_KEY（仅提示，不自动生成）
Write-Host "[5/8] 检查 APP_KEY..."
try {
    $appKey = php -r "try { echo env('APP_KEY', ''); } catch (Throwable \$e) { echo ''; }" 2>$null
    if ([string]::IsNullOrWhiteSpace($appKey) -or $appKey -eq "") {
        Write-Warning "APP_KEY 为空。请在项目根目录手动运行：php artisan key:generate"
        Write-Warning "按 Ctrl+C 退出并执行上述命令后再重新运行本脚本。"
        Write-Host ""
        pause
    } else {
        Write-Host "  APP_KEY 已存在"
    }
} catch {
    Write-Warning "无法检测 APP_KEY 状态。如果启动后出现错误，请手动运行：php artisan key:generate"
}

# 6. 清理配置缓存
Write-Host "[6/8] 清理配置缓存..."
php artisan config:clear 2>&1 | Out-Null
Write-Host "  OK"

# 7. 启动服务
Write-Host "[7/8] 启动 Laravel Server + npm watch..."
Write-Host ""

# 启动 Laravel Server 在新窗口
$laravelCmd = "php artisan serve --host=127.0.0.1 --port=8000"
$serverWindow = Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot'; $laravelCmd" -PassThru
Write-Host "  Laravel Server 启动中... (PID: $($serverWindow.Id))"
Start-Sleep 2

# 启动 npm watch 在新窗口
$npmCmd = "npm run watch"
$npmWindow = Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectRoot'; $npmCmd" -PassThru
Write-Host "  npm watch 启动中... (PID: $($npmWindow.Id))"
Start-Sleep 2

# 8. 打开浏览器
Write-Host "[8/8] 打开浏览器..."
Start-Sleep 3
Start-Process "http://127.0.0.1:8000/login"
Write-Host "  已打开 http://127.0.0.1:8000/login"

Write-Host ""
Write-Host "============================================"
Write-Host " LinguaCafe 已启动！"
Write-Host "============================================"
Write-Host ""
Write-Host "Laravel Server: http://127.0.0.1:8000"
Write-Host "npm watch: 后台运行中"
Write-Host ""
Write-Host "注意事项："
Write-Host "  - 关闭此窗口不会关闭 Laravel Server 和 npm watch"
Write-Host "  - 如需停止，请手动关闭对应的 PowerShell 窗口"
Write-Host "  - 不要运行 migrate:fresh 或 db:wipe"
