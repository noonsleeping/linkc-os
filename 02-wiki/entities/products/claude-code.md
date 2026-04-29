---
type: entity-product
name: Claude Code
category: AI 开发工具
status: active
links:
  - "[[linkc-os]]"
  - "[[ai-agent-paradigms]]"
created: 2026-04-20
updated: 2026-04-29
---

# Claude Code

## 是什么

Anthropic 推出的命令行 AI 代理工具，可在终端中直接委托编码和文件操作任务。

## 我怎么用

- LinkcOS 的核心引擎——编译、维护 wiki、运行 Skills
- 个人助理平台（探索中）：内容创作、知识管理、日程自动化
- 项目位于 `~/Desktop/claude-personal-assistant`

## 关键功能

- CLAUDE.md 分层指令系统
- Auto Memory / Skills / Hooks / Subagents
- Obsidian CLI 集成
- Scheduled Tasks

## Harness 架构定位

Anthropic 官方文档明确：SDK 就是"驱动 Claude Code 的 Agent harness"。设计哲学：
- **薄 harness**：所有智能在模型里，harness 只管理回合（"哑循环"，runtime is dumb，model is CEO）
- **TAOR 循环**：Think-Act-Observe-Repeat，编排器不懂代码/文件，只跑循环让模型决定何时停止
- 工具延迟加载，实现 95% 上下文减少
- git 提交作为检查点；会话 = git branch，可 checkpoint / rollback / fork
- 三层记忆结构（6 层在会话启动时加载）
- 定期从 harness 删除规划步骤，因为新模型版本内化了该能力
- **Declarative Extension**：通过 .md/.json 扩展能力，无需写 TypeScript/Python

> 来源：Vikash Rungta 对 Claude Code 的逆向工程分析（2026-02-17），通过 runtime transcript、`~/.claude` 文件系统及行为压测得出，非 Anthropic 官方。

详见 [[agent-harness]]。

## 事件记录

### 2026-04-23 质量回归事件（Anthropic 官方复盘）
> 来源：[anthropic.com/engineering/april-23-postmortem](https://www.anthropic.com/engineering/april-23-postmortem)
> 全部修复于 v2.1.116（4-20）。Anthropic 4-23 重置所有订阅用户的 usage limits。

3 个独立 bug **同时影响**了 Claude Code 体验，叠加起来呈现"模型变笨"的错觉（API 本身未受影响）：

#### Bug 1：默认 reasoning effort 被降为 medium（影响 Sonnet 4.6 / Opus 4.6）
- **3-4** 改为 medium 默认（理由：high 模式偶尔思考过久导致 UI 假死）
- 用户反馈"Claude 变笨了"
- **4-7 回滚**：Opus 4.7 默认 `xhigh`，其他模型 `high`

#### Bug 2：thinking history 被持续清空（影响 Sonnet 4.6 / Opus 4.6）
- **3-26** 上线优化：session idle > 1 小时时清空旧 thinking 节省 cache
- 实现 bug：本应只清一次 → 实际**每个 turn 都清**
- 表现：Claude 显得健忘、重复、工具选择诡异
- 副作用：cache miss 急剧增加 → 用户 usage limits 被快速消耗
- **4-10 修复**（v2.1.101）
- 教训：用 Opus 4.7 跑 Code Review 能发现这个 bug，Opus 4.6 不能 → Anthropic 已加大 Code Review 的 repo 上下文

#### Bug 3：system prompt 减口水话指令伤了智能（影响 Sonnet 4.6 / Opus 4.6 / Opus 4.7）
- **4-16** 加入指令：`tool 间文本 ≤25 字，最终回复 ≤100 字`
- 内部 eval 没发现问题，**ablation 后**发现某些 eval 在 Opus 4.6/4.7 上掉 3%
- **4-20 回滚**

#### 陈言相关性
陈言用 Opus 4.7（[[linkc-os]] 引擎）— 主要受 Bug 3 影响（4-16 至 4-20 期间体验有损）。
Bug 1/2 不影响 Opus 4.7。

#### Anthropic 后续改进
- 更多内部员工用**真实公开版本**的 Claude Code（不只是测试版）
- system prompt 改动加强 review：每次改都跑全模型 eval、ablation 看每行影响、新建 tooling 让改动易审计
- 加了 CLAUDE.md 规范：模型特定的改动要 gate 到对应模型
- 任何可能损害智能的改动：加 soak period + 更广 eval suite + 灰度发布
- 新建 @ClaudeDevs（X 账号）解释产品决策

## 相关

- [[linkc-os]]
- [[ai-agent-paradigms]]
- [[agent-harness]]
