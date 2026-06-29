# LinguaCafe Dev Main 总控大计划

## 1. 仓库定位

1. 本仓库是未来主开发仓库。
2. 旧仓库 `LinguaCafe-local` 是历史仓库，不再默认 push。
3. 后续开发完成一轮并通过验收后，默认 push 到本仓库。
4. 旧仓库不再默认 push。

## 2. 项目总目标

LinguaCafe Dev Main 的总目标是把 LinguaCafe 改造成英文学习优先的、本地运行的、基于 WordSense 的 FSRS 复习系统，使用户通过阅读积累词义、通过复习稳定记忆、通过管理页维护复习卡、通过导出和 GPT 工作流辅助词义整理，并能在换电脑后继续开发。

## 3. 产品主线

1. **Sense-only FSRS** — 所有复习和统计围绕 WordSense 进行。
2. **WordSense** 是真正复习对象（lemma、surface_form、pos、sense_zh、sense_en、example_sentences、source_chapter_id 等字段）。
3. **ReviewCard.target_type=sense** 是主线。
4. **target_type=word** 是 legacy，不作为新功能主线。
5. **EncounteredWord** 只负责阅读页颜色、熟悉度总览和 legacy 兼容。
6. 当前优先 **English**，不扩散到多语言重构。
7. 不做一次大重构，保持可运行优先。

## 4. 技术主线

1. **Laravel 11** + **PHP 8.2+**
2. **MariaDB / MySQL** 数据库
3. **Vue 2 + Vuetify** 前端
4. **laravel-mix** + **webpack 5.88.2** 构建
5. **fsrs-rs-php** 调度引擎
6. **Windows 本地运行优先**
7. Composer `no-dev` 可作为 Windows 启动方案
8. `.env` 不进入 Git
9. 数据库通过 SQL 迁移，不进普通 Git 历史

## 5. 当前已完成大阶段

| 阶段 | 内容 |
|------|------|
| 1. 早期 FSRS word-only | FSRS 基础集成，word 级调度 |
| 2. WordSense 与 sense review card | 词义概念引入，sense-level 复习卡模型 |
| 3. sense-mapping 导入 | 批量导入词义映射 |
| 4. SenseMappingReview UI | 词义映射审核界面 |
| 5. Sense FSRS Review | 基于 WordSense 的 FSRS 调度 |
| 6. GPT package | GPT 工作流辅助词义整理 |
| 7. Windows scripts | 启动、停止、doctor 等 Windows 脚本 |
| 8. doctor 命令 | 数据库健康检查、FSRS 诊断 |
| 9. 复习卡管理页 | 搜索、筛选、排序、分页、批量操作 |
| 10. FSRS 设置页 Anki 对标 | 设置页信息架构重排、Desired Retention、复习负担预估 |
| 11. FSRS 参数优化 D.3 | 参数优化预览、确认保存、参数来源说明、调度器集成 |
| 12. FSRS 重排与撤销 D.4 | 正式重排 preview/confirm/undo 全链路 |
| 13. 管理页列自定义/紧凑模式/导出/详情抽屉 | 丰富的管理页交互 |
| 14. 右键点词面板 | 阅读页右侧点词面板功能改造 |
| 15. SenseReview Anki 化 UI-Review-a/b/c/e | 信息层级整理、reveal flow、快捷键、代码审查 |
| 16. Dev Main 仓库迁移与公开边界治理 | 仓库迁移、文档体系、公开边界、.gitignore |

## 6. 当前细分计划

### Plan A：新主仓库治理计划

已完成：
- `54bb5fa` 新主仓库初始化
- `f8262e6` AI development context
- `ff68a51` public boundary + schema-only export
- README / AI_CONTEXT / DEV_MAIN_WORKFLOW / .gitignore / schema-only 脚本已建立

待做：
- 本轮总结入库（进行中）
- 总控大计划入库（进行中）
- FSRS roadmap 头部更新

### Plan B：OpenCode Slim 工作流计划

已完成：
- 从 `oh-my-openagent@4.9.2` 切换到 `oh-my-opencode-slim@2.0.6`

待做：
- TTY 终端 smoke（手动运行 opencode）
- `opencode models --refresh`
- `ping all agents`
- 验证 Plan / Build / Composer 界面
- 复杂任务用 Composer / Orchestrator
- 写文件必须明确边界

### Plan C：旧电脑数据迁移计划

待做：
- schema-only 导出脚本 smoke
- 真实数据库 SQL 本地导出
- storage 本地打包
- 不自动上传真实数据
- 后续如公开数据，先区分 schema-only、匿名样例、真实数据

### Plan D：本地可运行验证计划

待做：
- 旧电脑运行 `start-linguacafe.ps1`
- 验证 `/login` 页面
- 验证 `/reviews/senses` 页面
- 用户没有新电脑，不做新电脑测试

### Plan E：SenseReview 真实刷卡验收计划

待做：
- 打开 `/reviews/senses`
- 刷 5 到 10 张卡
- 检查问题面、答案面、快捷键、More 菜单、近义译法 / 搭配显示
- 决定是否进入 UI-Review-d
- 未完成前不进 D.5

### Plan F：FSRS Roadmap 更新计划

待做：
- 更新 `docs/plans/linguacafe-fsrs-roadmap.md` 头部
- 标记旧 roadmap 仍保留为 FSRS 专项路线图
- 指向新的 `linguacafe-master-plan.md`
- 记录 DevMain-1/2/3 阶段

### Plan G：公开仓库与数据安全计划

已完成：
- `.gitignore` 忽略 `.env`、SQL、迁移包、storage 导出
- 文档写入公开边界
- schema-only 脚本加入

长期规则：
- 源码可公开
- schema-only SQL 可公开
- 匿名样例可公开
- 真实学习数据不默认公开

### Plan H：Vibe Coding 协作规则计划

已写入 DEV_MAIN_WORKFLOW.md 和 AI_CONTEXT.md：

- 网页端 GPT 是总流程设计师
- 本地 Agent 是执行端
- 用户是产品设计者
- 每次任务前推荐模型和档位
- 每次提示词后问产品设计问题
- 本地 Agent 每轮输出报告
- 网页端 GPT 基于 GitHub 最新代码验收
- 不凭聊天记录判断代码状态
- 不凭预期行为下结论

## 7. 当前禁止进入的任务

1. 不进入 D.5
2. 不自动进入 UI-Review-d
3. 不做新电脑测试
4. 不上传真实 SQL
5. 不上传 storage
6. 不上传迁移包
7. 不清库
8. 不修改业务代码
9. 不改 Vue / Controller / Service / routes / tests
10. 不新增 migration
11. 不使用 git push --force

## 8. 下一步最高优先级

1. 本轮总结入库
2. 总控大计划入库
3. FSRS roadmap 头部更新
4. schema-only 导出脚本 smoke
5. 真实数据库本地导出
6. `/reviews/senses` 真实刷卡验收
