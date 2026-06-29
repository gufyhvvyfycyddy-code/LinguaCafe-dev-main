# LinguaCafe Dev Main 本轮对话总结与总计划报告

## 1. 基本信息

- **报告日期**：2026-06-29
- **当前新主仓库**：`https://github.com/gufyhvvyfycyddy-code/LinguaCafe-dev-main`
- **旧历史仓库**：`git@github.com:gufyhvvyfycyddy-code/LinguaCafe-local.git`
- **旧电脑可运行路径**：`D:\Document\lingl\LinguaCafe-main`
- **本地 staging 路径**：`C:\Users\Administrator\Desktop\LinguaCafe-dev-main`
- **迁移数据目录**：`C:\Users\Administrator\Desktop\LinguaCafe-new-main-migration`
- **目标数据库**：`linguacafe_fsrs`

## 2. 本轮对话的核心变化

1. 从 `oh-my-openagent@4.9.2` 切换到 `oh-my-opencode-slim@2.0.6`。
2. 从 `LinguaCafe-local`（旧仓库）迁移到 `LinguaCafe-dev-main`（新主仓库）。
3. 旧仓库转为历史仓库，不再默认 push。
4. 新仓库从 private 转为 public（源码可公开，真实学习数据不公开）。
5. 建立完整的公开边界规则和 `.gitignore` 防护。
6. 建立 AI 二次开发上下文文档体系。
7. 建立新的总控大计划（本文档 + `linguacafe-master-plan.md`）。

## 3. 本轮对话前的项目背景

旧仓库 `LinguaCafe-local` 上已完成大量 FSRS 开发工作：

- 早期 FSRS word-only
- WordSense 与 sense review card
- sense-mapping 导入
- SenseMappingReview UI
- Sense FSRS Review
- GPT package
- Windows scripts / doctor 命令
- 复习卡管理页
- FSRS 设置页 Anki 对标
- FSRS 参数优化 D.3
- FSRS 重排与撤销 D.4
- 管理页列自定义 / 紧凑模式 / 导出 / 详情抽屉
- 右键点词面板
- SenseReview Anki 化 UI-Review-a/b/c/e

## 4. 新电脑运行失败与环境问题梳理

新电脑之前 clone 旧仓库代码后发现无法运行，主要问题：

1. `vendor/autoload.php` 不存在（Composer 依赖未安装）。
2. Composer 在 Windows 上因 `ext-pcntl` / `ext-posix` 报错。
3. `laravel/pint` 是 dev dependency，no-dev 安装时排除。
4. webpack 5.108.1 缺少 `SizeFormatHelpers.js`（需要固定 5.88.2）。
5. MariaDB 未安装。
6. `Access denied for user 'root'@'localhost' (using password: NO)`。
7. `Unknown database 'linguacafe_fsrs'`。

## 5. 对"完整克隆"的重新定义

GitHub clone 不等于完整运行环境。完整迁移需要五部分：

1. **代码**（Git clone）。
2. **依赖**（`composer install` + `npm install` + webpack 固定）。
3. **本地配置**（`.env`，含 DB_PASSWORD / APP_KEY）。
4. **数据库**（`linguacafe_fsrs` 的 SQL 导出 → 导入）。
5. **storage**（用户导入材料、GPT workflow 数据、图片等）。

## 6. 新主仓库决策

1. 创建新仓库 `LinguaCafe-dev-main`，与旧仓库完全分离。
2. 旧仓库 `LinguaCafe-local` 转为历史仓库，不再默认 push。
3. 新仓库初始 commit `54bb5fa`（793 files）。
4. 后续开发完成一轮并通过验收后 push 到新仓库。

## 7. OpenCode Slim 切换与使用规则

- 旧插件：`oh-my-openagent@4.9.2`
- 新插件：`oh-my-opencode-slim@2.0.6`
- OpenCode 版本：`1.17.11`
- 安装方式：`npx oh-my-opencode-slim@latest install`
- 配置路径：`C:\Users\Administrator\.config\opencode`

使用原则：

1. **Plan**：只读侦察、列计划、拆任务。
2. **Build**：在明确边界内执行修改。
3. **Composer / Orchestrator**：适合多阶段复杂任务。
4. 多 Agent 可并行侦察和审查，但写文件时必须明确文件边界。
5. 使用前建议刷新模型列表。
6. 先执行 `ping all agents` 做只读 smoke。

## 8. 新主仓库创建过程

1. 备份 OpenCode 配置到 `opencode-config-backup-20260629-120617`。
2. 确认旧项目路径 `D:\Document\lingl\LinguaCafe-main`（commit `90436dc`）。
3. 创建 staging 副本（robocopy，11850 files）。
4. 清理敏感文件（`.env.bak`、`.env.testing`、`.claude`、`.trae`、`.uploads`、`.venv-tokenizer`、session/view/cache）。
5. 创建文档（README-DEV-MAIN.md、.env.example.local、setup/import/start 脚本）。
6. 安全扫描通过。
7. 初始化 Git（`54bb5fa`），push 到 `LinguaCafe-dev-main`。
8. 创建 GitHub Release `dev-main-initial-20260629-123646`。
9. 验证新旧仓库 remote 互不干扰。

## 9. 新仓库公开状态与边界调整

1. 新仓库可以 **public**。
2. 源码、文档、安全脚本、schema-only SQL、匿名示例数据可以公开。
3. `.env`、账号凭据、OpenCode Key、API Key、storage 个人学习数据不公开。
4. 包含真实学习记录的原始 SQL 不公开。
5. 完整迁移包不公开。
6. `.gitignore` 已防护 `.env`、`.sql`、`.dump`、`.bak`、`.7z`、`.rar` 等。

## 10. f8262e6 文档修复

commit `f8262e6` — "docs: add AI development context"

1. 修复 README.md：顶部加入本仓库说明。
2. 修复 README-DEV-MAIN.md：代码块乱码修复、加入真实仓库 URL。
3. 新增 docs/AI_CONTEXT.md：11 章节完整 AI 上下文。
4. 扩展 docs/DEV_MAIN_WORKFLOW.md：完整工作流规则。
5. 修复 start-linguacafe.ps1：移除 key:generate --force，改为提示手动运行。

## 11. ff68a51 公开边界修复

commit `ff68a51` — "docs: clarify public data boundaries"

1. `.gitignore` 新增 30 行防护规则。
2. 公开说明精确化：schema-only 可公开，真实学习数据默认不公开。
3. 数据库公开规则五条精确化。
4. 新增 `tools/windows/export-db-schema-only.ps1`。
5. 新增 DEV_MAIN_WORKFLOW.md 的公开仓库与数据库边界小节。

## 12. 当前 GitHub 中的大计划状态

旧 FSRS roadmap（`docs/plans/linguacafe-fsrs-roadmap.md`）头部仍引用旧仓库，需要更新。

当前缺少：
1. 本轮对话总结入库。
2. 项目总控大计划（`linguacafe-master-plan.md`）。
3. FSRS roadmap 头部更新。

## 13. 当前应写入大计划的内容

- 当前已完成大阶段（1-16 个阶段）。
- 当前细分计划（Plan A-H）。
- 当前禁止进入的任务。
- 下一步最高优先级。
- Vibe Coding 协作规则。

## 14. 当前细分计划

### Plan A：新主仓库治理计划
已完成：初始化、AI context、公开边界、schema-only 脚本。
待做：本轮总结入库、总控大计划入库、FSRS roadmap 更新。

### Plan B：OpenCode Slim 工作流计划
已完成：切换安装。
待做：TTY smoke、models refresh、ping all agents、验证 Plan/Build/Composer。

### Plan C：旧电脑数据迁移计划
待做：schema-only smoke、真实 SQL 本地导出、storage 本地打包、不自动上传。

### Plan D：本地可运行验证计划
待做：旧电脑运行 start-linguacafe.ps1、验证 /login、验证 /reviews/senses（无新电脑，不做新电脑测试）。

### Plan E：SenseReview 真实刷卡验收计划
待做：打开 /reviews/senses、刷 5-10 张卡、检查体验、决定是否进入 UI-Review-d。

### Plan F：FSRS Roadmap 更新计划
待做：更新 roadmap 头部、指向总控大计划、记录 DevMain-1/2/3。

### Plan G：公开仓库与数据安全计划
已完成：.gitignore、文档边界、schema-only 脚本。
长期规则：源码可公开、schema-only 可公开、真实学习数据不默认公开。

### Plan H：Vibe Coding 协作规则计划
已写入 DEV_MAIN_WORKFLOW.md 和 AI_CONTEXT.md。

## 15. 当前不应做的事情

1. 不进入 D.5。
2. 不自动进入 UI-Review-d。
3. 不做新电脑测试。
4. 不上传真实 SQL。
5. 不上传 storage。
6. 不上传迁移包。
7. 不清库。
8. 不修改业务代码。
9. 不改 Vue / Controller / Service / routes / tests。
10. 不新增 migration。
11. 不使用 git push --force。

## 16. 下一步最高优先级

1. 本轮总结入库（本文件）。
2. 总控大计划入库（`linguacafe-master-plan.md`）。
3. FSRS roadmap 头部更新。
4. schema-only 导出脚本 smoke。
5. 真实数据库本地导出。
6. `/reviews/senses` 真实刷卡验收。

## 17. 建议写入仓库的文件结构

```
docs/
├── AI_CONTEXT.md                    # 已有 — AI 二次开发上下文
├── DEV_MAIN_WORKFLOW.md             # 已有 — 开发工作流规则
├── context/
│   └── conversation-summary-2026-06-29-dev-main.md   # 本文件
└── plans/
    ├── linguacafe-master-plan.md    # 总控大计划
    └── linguacafe-fsrs-roadmap.md   # FSRS 专项路线图（已有，需更新头部）
tools/windows/
├── export-db-schema-only.ps1        # 已有 — schema-only 导出脚本
├── export-db.bat                    # 已有 — 完整数据库导出脚本
├── setup-deps-windows.ps1           # 已有 — 依赖安装
├── import-linguacafe-db.ps1         # 已有 — 数据库导入
└── start-linguacafe.ps1             # 已有 — 项目启动
```

## 18. 下一轮 WorkBuddy 任务建议

下一轮应执行 Context-Plan-1：
1. 新增本轮对话总结。
2. 新增总控大计划。
3. 更新 FSRS roadmap 头部。

## 19. 当前项目一句话状态

LinguaCafe Dev Main 已完成仓库迁移和公开边界治理，OpenCode 已切换为 Slim，文档体系已建立，下一步是入库总结和大计划、完成 schema-only smoke 和真实刷卡验收。
