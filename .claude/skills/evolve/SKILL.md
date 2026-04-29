---
name: evolve
description: 每两周一次的 LinkcOS 演进评议。读取信号池和近期活动，
             生成涵盖类型/系统/交互三个维度的综合提案。
             仅由定时任务或用户显式请求触发。
allowed-tools: Read Write Edit Glob Grep Bash
---

# Evolve Skill · 双周演进评议

## 触发方式
- 定时任务（每两周周一 09:00）
- 用户显式说"做一次演进评议"或"evolve"

## Step 0 · 读历史（防循环演化）

读取 `03-schema/CHANGELOG.md` 主索引。
读取最近 3 次 `03-schema/changelog/` entry 的"可能影响"字段。
若当前信号与历史决策冲突，必须在本期提案中明确说明。

## Step 1 · 聚合信号

读取 `03-schema/biweekly-signals.md` 中的所有信号。
读取过去 14 天的 `02-wiki/log.md` 条目。
读取过去 14 天的 `02-wiki/reviews/` 文件。
读取当前 `03-schema/types.md`。

合并同类信号，去除噪音：
- 上次提案中已被 rejected 的方向，降低权重
- 仅出现 1 次且证据薄弱的信号，标记为 observation 而非 proposal

## Step 2 · 三维度分析

### 维度 A · 类型演化
- 频次阈值：同类新实体 ≥ 3 次出现在错误类型下
- 结构异质性：同类型内 frontmatter 字段明显分化
- 用户纠正：用户对同一归类纠正 ≥ 2 次

### 维度 B · 系统优化
- 性能问题（某操作变慢）
- 冗余（同样信息多处手动维护）
- 盲点（Dataview 视图未覆盖的重要查询）
- 脆弱性（双链断裂、模板过期）

### 维度 C · 交互方式
- 沟通模式变化（口头协议、缩写、反复澄清）
- 回复被忽略/打开的比例
- 输入模式变化（语音 vs 文字 vs 截图的频率）
- 定时任务产出是否被阅读

## Step 3 · 生成提案

写入 `03-schema/proposals/YYYY-MM-DD-biweekly-<nn>.md`。

### 提案必须包含
- 三个维度都覆盖（无候选则写"本期无"）
- 每个候选：证据、建议、迁移成本、回退策略
- decision 字段留空（待用户审批）
- 被否决/搁置的候选也要透明展示
- 系统健康度评分（1-10）
- 总长 ≤ 300 行

## Step 4 · 归档信号池

将 `03-schema/biweekly-signals.md` 移动到
`03-schema/signals-archive/YYYY-MM-DD-signals.md`。
创建新的空 `03-schema/biweekly-signals.md`。

## Step 5 · 记录

在 `02-wiki/log.md` 追加：
`## [YYYY-MM-DD HH:MM] schema-evolution | biweekly-<nn> proposal ready`

不主动打断当前会话。用户下次打开会话时 SessionStart 会提醒。

## 绝对禁止
- 不自动执行任何修改
- 不修改 types.md / CLAUDE.md / 任何 wiki 页
- 不删除旧提案
- 不在日常对话中被调用（除非用户显式请求）
