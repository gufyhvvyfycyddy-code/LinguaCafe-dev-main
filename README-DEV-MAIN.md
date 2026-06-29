# LinguaCafe Dev Main

本仓库是 LinguaCafe 后续继续开发的主仓库。

## 仓库定位

- **原仓库**（`LinguaCafe-local`）逐渐作为历史仓库，不再自动推送。
- **本仓库** 是后续主要开发基线。
- 每完成一轮开发并通过网页端 GPT 验收后，应 push 到本仓库。
- 只有用户明确要求时才进行更新。

## 安全说明

- 本仓库 **不包含** `.env`、数据库密码、API Key。
- 本仓库 **不直接提交** 数据库 SQL 文件。
- 数据库通过 Release 迁移包或用户本地备份导入。
- 首次在新电脑恢复时，参考下方流程。

## 公开仓库边界

用户确认本仓库可以公开。公开范围仅限源码、文档、说明和安全脚本。

不要公开：

- 本机私有配置文件
- storage 个人学习数据
- 迁移包
- 账号凭据或服务访问令牌
- OpenCode 私有配置

数据库公开规则：

- 可以公开数据库结构、表设计说明、schema-only SQL。
- 可以公开匿名示例数据。
- 不要公开包含真实用户、真实学习材料、复习日志、阅读记录、storage 文件路径或个人使用痕迹的原始 SQL。
- 真实迁移包只用于本地迁移，除非用户明确要求并完成脱敏。

如果需要迁移旧电脑数据，请使用本地 SQL 备份或单独的加密迁移包，不要把个人数据提交进 Git 历史。

如果只是让其他 AI 理解项目结构，可以使用 `tools/windows/export-db-schema-only.ps1` 导出 schema-only SQL。
如果要迁移真实使用环境，仍应使用本地完整 SQL 备份，但不要提交进 Git 历史。

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

   ```bash
   git clone https://github.com/gufyhvvyfycyddy-code/LinguaCafe-dev-main.git
   cd LinguaCafe-dev-main
   ```

2. **配置环境变量**

   ```powershell
   copy .env.example.local .env
   ```

   然后打开 `.env`，填写你自己的 DB_PASSWORD。

3. **安装依赖**

   ```powershell
   .\tools\windows\setup-deps-windows.ps1
   ```

   或手动：

   ```bash
   composer install --no-dev --ignore-platform-req=ext-pcntl --ignore-platform-req=ext-posix --prefer-dist --no-progress -o
   npm install --legacy-peer-deps --package-lock=false
   npm install --no-save --package-lock=false laravel-mix@6.0.49 webpack@5.88.2 webpack-cli@4.10.0
   ```

4. **导入数据库**

   - 方式 A：从本仓库的 GitHub Release 下载加密迁移包，解密后使用导入脚本。
   - 方式 B：如果你有旧电脑的 SQL 备份，手动导入。

   ```powershell
   .\tools\windows\import-linguacafe-db.ps1
   ```

5. **启动项目**

   ```powershell
   .\tools\windows\start-linguacafe.ps1
   ```

   或手动：

   ```bash
   php artisan config:clear
   php artisan serve --host=127.0.0.1 --port=8000
   ```

   然后打开 http://127.0.0.1:8000/login

### 注意事项

- **严禁** 运行 `migrate:fresh` 或 `db:wipe`（会销毁学习数据）。
- 如果没有旧数据库备份，可以先创建空库并运行 `php artisan migrate`，但这会丢失所有旧学习数据。
- 每次开发前，网页端 GPT 应基于 GitHub 最新代码分析。
- 本地 Agent 只执行当前任务。
