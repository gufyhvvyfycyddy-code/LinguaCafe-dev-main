# LinguaCafe Dev Main AI Context

本文件用于帮助新的 AI 对话窗口、OpenCode、WorkBuddy、Trae 和网页端总流程设计师快速理解本仓库。

## 1. 仓库定位

本仓库是 LinguaCafe 后续继续开发的主仓库，不再只是一次性快照。

- 新主仓库：`https://github.com/gufyhvvyfycyddy-code/LinguaCafe-dev-main`
- clone 地址：`https://github.com/gufyhvvyfycyddy-code/LinguaCafe-dev-main.git`
- 旧历史仓库：`git@github.com:gufyhvvyfycyddy-code/LinguaCafe-local.git`
- 旧电脑可运行项目路径：`D:\Document\lingl\LinguaCafe-main`
- 旧电脑 staging 路径：`C:\Users\Administrator\Desktop\LinguaCafe-dev-main`
- 旧电脑迁移目录：`C:\Users\Administrator\Desktop\LinguaCafe-new-main-migration`
- 目标数据库名：`linguacafe_fsrs`

后续开发完成一轮并通过网页端 GPT 验收后，应优先推送到本仓库。旧仓库逐渐作为历史仓库，不再默认推送。

## 2. 当前进度

1. OpenCode 已从 `oh-my-openagent@4.9.2` 切换到 `oh-my-opencode-slim@2.0.6`。
2. 新主仓库已创建，初始 commit 为 `54bb5fa`。
3. 新仓库已包含 Windows 依赖安装、数据库导入、项目启动脚本。
4. 数据库 SQL 尚未完成导出，迁移包尚未上传。
5. storage 目录发现 `storage/app`，需要等数据库导出后一起迁移。
6. OpenCode Slim 的 Plan / Build / Composer 界面仍需手动 smoke 验证。

## 3. 产品方向

本项目当前目标是把 LinguaCafe 改造成英文学习优先的 sense-only FSRS 复习系统。

核心原则：

1. 阅读页负责学习入口，复习页负责稳定记忆。
2. WordSense 是真正的复习对象。
3. EncounteredWord 主要负责阅读页颜色、熟悉度总览和 legacy 兼容。
4. ReviewCard 主线应是 `target_type=sense`。
5. `target_type=word` 视为 legacy，不作为新功能主线。
6. 当前优先 English，不扩散到多语言重构。
7. 保持可运行优先，避免大范围重构。

## 4. 当前 UI / FSRS 阶段

最近已完成 Sense Review 页面的早期 Anki 化改造：

1. UI-Review-a：简化信息层级，管理按钮收进更多菜单。
2. UI-Review-b：加入"先看题，再显示答案"的 reveal flow。
3. UI-Review-c：加入 Space 显示答案，1/2/3/4 评分快捷键。
4. UI-Review-e：代码审查 smoke 已记录，但真实浏览器刷卡验收仍未完成。

下一步不应直接进入 D.5，也不应自动进入 UI-Review-d。应先完成真实浏览器体验验收：打开 `/reviews/senses`，刷 5 到 10 张卡，确认问题面、答案面、快捷键、更多菜单、近义译法 / 搭配显示方式。

## 5. 协作流程

网页端 GPT 是总流程设计师，负责产品目标、任务拆分、模型与档位建议、验收标准、Accept / Refuse 和下一轮提示词。

本地 Agent 负责执行当前任务，不能擅自扩大范围，不能跳阶段，不能把预期行为当真实验收。

用户负责产品方向、手动体验、敏感配置输入、把本地执行报告贴回网页端 GPT。

每轮闭环：

1. 用户提出产品目标。
2. 网页端 GPT 查看 GitHub 最新代码。
3. 网页端 GPT 推荐模型和档位。
4. 网页端 GPT 给 OpenCode / WorkBuddy 提示词。
5. OpenCode / WorkBuddy 执行当前任务。
6. 本地 Agent 跑测试和 smoke，并输出报告。
7. 用户把报告贴回网页端 GPT。
8. 网页端 GPT 根据报告和 GitHub 最新代码判断 Accept / Refuse。

## 6. 模型与档位规则

| 任务类型 | 推荐模型 | 推荐档位 |
| --- | --- | --- |
| 简单文案、纯 docs 小改 | DeepSeek Flash | 低 / 中 |
| 小型前端样式或文案改动 | DeepSeek Flash | 中 |
| 多文件代码、测试、风险边界 | DeepSeek Pro | 中 / 中高 |
| 数据库、权限、删除、导入导出、FSRS 逻辑 | DeepSeek Pro | 高 |
| 侦察 + 产品判断 + roadmap 整合 | DeepSeek Pro | 中 / 中高 |
| 浏览器 smoke，只读验收 | DeepSeek Flash | 中 |
| 失败恢复、上下文异常、任务偏离复盘 | DeepSeek Pro | 中高 |

## 7. OpenCode Slim 使用说明

当前旧电脑 OpenCode 信息：

- OpenCode 版本：`1.17.11`
- Slim 插件：`oh-my-opencode-slim@2.0.6`
- 主配置目录：`C:\Users\Administrator\.config\opencode`

使用原则：

1. Plan：只读侦察、列计划、拆任务。
2. Build：在明确边界内执行修改。
3. Composer / Orchestrator：适合多阶段复杂任务。
4. 多 Agent 可并行侦察和审查，但写文件时必须明确文件边界。
5. 使用前建议刷新模型列表。
6. 进入 OpenCode 后建议先执行 `ping all agents` 做只读 smoke。

## 8. 新电脑恢复流程

1. clone 新主仓库。
2. 复制本地环境模板为本机配置文件。
3. 用户本人填写本机数据库连接信息。
4. 安装 PHP 8.2+、Composer、Node、npm、MariaDB / MySQL。
5. 运行 `tools/windows/setup-deps-windows.ps1` 安装依赖。
6. 导入旧电脑导出的 SQL 到 `linguacafe_fsrs`。
7. 运行 `tools/windows/import-linguacafe-db.ps1`。
8. 运行 `tools/windows/start-linguacafe.ps1`。
9. 打开 `http://127.0.0.1:8000/login` 或 `/reviews/senses`。

如果没有旧数据库备份，可以创建空库并运行普通 migration，但会丢失旧学习数据。严禁清空数据库式初始化。

## 9. 公开仓库与本地配置规则

本仓库可以公开，但公开内容仅限源码、文档和安全脚本。

数据库规则：

1. schema-only SQL 可以公开。
2. 匿名示例数据可以公开。
3. 原始数据库 SQL 通常包含用户、学习材料、复习记录和阅读历史，不应公开。
4. storage 个人学习数据不公开。
5. 如果用户明确要公开数据库内容，必须先确认是 schema-only、匿名样例，还是完整真实数据。

用户本人可以查看和编辑本机配置文件。本地脚本可以为了运行项目读取配置。AI Agent 默认不应输出配置内容、不应把配置内容写入报告、不应把配置文件提交到仓库。

## 10. 禁止事项

1. 禁止提交本机私有配置文件。
2. 禁止公开个人数据库备份和迁移包。
3. 禁止公开账号凭据或服务访问令牌。
4. 禁止修改 `AGENTS.md`。
5. 禁止处理 `.omo/`，只能报告。
6. 禁止使用 `git push --force`。
7. 禁止 `git reset --hard`、`git clean`。
8. 禁止 `migrate:fresh`、`db:wipe`、清库。
9. 禁止运行 notification script。
10. 默认禁止 DCP。
11. 禁止自动进入下一任务。
12. 禁止只凭聊天记录判断代码状态。
13. 禁止凭预期行为下结论。
14. 禁止向旧仓库自动 push。

## 11. 每轮最终报告必须包含

1. 当前 commit。
2. 是否 push。
3. git status。
4. 修改文件列表。
5. 实现内容。
6. 测试结果。
7. 浏览器 smoke 结果。
8. 合规确认。
9. 是否进入下一任务：否。
