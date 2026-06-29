# LinguaCafe Dev Main

本仓库是 LinguaCafe 后续继续开发的主仓库。

## 仓库定位

- **原仓库**（LinguaCafe-local）逐渐作为历史仓库，不再自动推送。
- **本仓库** 是后续主要开发基线。
- 每完成一轮开发并通过网页端 GPT 验收后，应 push 到本仓库。
- 只有用户明确要求时才进行更新。

## 安全说明

- 本仓库 **不包含** .env、数据库密码、API Key。
- 本仓库 **不直接提交** 数据库 SQL 文件。
- 数据库通过 Release 迁移包或用户本地备份导入。
- 首次在新电脑恢复时，参考下方流程。

## 新电脑恢复 / 开发继续流程

### 环境要求

| 工具 | 版本 |
|------|------|
| PHP | 8.2+ |
| Composer | 最新 |
| Node.js | v20+ |
| npm | v10+ |
| MariaDB / MySQL | 10.6+ / 8.0+ |

### 快速启动

1. **clone 本仓库**
   `ash
   git clone <本仓库URL>
   cd LinguaCafe-dev-main
   `

2. **配置环境变量**
   `ash
   copy .env.example.local .env
   `
   然后打开 .env，填写你自己的 DB_PASSWORD。

3. **安装依赖**
   `powershell
   # 命令行执行：
   .\tools\windows\setup-deps-windows.ps1
   `
   或手动：
   `ash
   composer install --no-dev --ignore-platform-req=ext-pcntl --ignore-platform-req=ext-posix --prefer-dist --no-progress -o
   npm install --legacy-peer-deps --package-lock=false
   npm install --no-save --package-lock=false laravel-mix@6.0.49 webpack@5.88.2 webpack-cli@4.10.0
   `

4. **导入数据库**
   - 方式 A：从本仓库的 GitHub Release 下载加密迁移包，解密后使用导入脚本。
   - 方式 B：如果你有旧电脑的 SQL 备份，手动导入。
   `powershell
   .\tools\windows\import-linguacafe-db.ps1
   `

5. **启动项目**
   `powershell
   .\tools\windows\start-linguacafe.ps1
   `
   或手动：
   `ash
   php artisan config:clear
   php artisan serve --host=127.0.0.1 --port=8000
   `
   然后打开 http://127.0.0.1:8000/login

### 注意事项

- **严禁** 运行 migrate:fresh 或 db:wipe（会销毁学习数据）。
- 如果没有旧数据库备份，可以先创建空库并运行 php artisan migrate，但这会丢失所有旧学习数据。
- 每次开发前，网页端 GPT 应基于 GitHub 最新代码分析。
- 本地 Agent 只执行当前任务。
