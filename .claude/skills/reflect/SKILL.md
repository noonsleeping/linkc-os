---
name: reflect
description: 日/周/月度反思。扫描近期活动，识别模式，生成复盘页面，
             提议 Schema 更新。由定时任务或用户显式请求触发。
allowed-tools: Read Write Edit Glob Grep Bash
---

# Reflect Skill · 复盘与反思

## 触发方式
- 每日定时任务（23:00）
- 每周定时任务（周日 20:00）
- 用户说"复盘"/"reflect"/"我们来回顾一下"

## 输入

根据周期确定扫描范围：
- **daily**：今天的 log 条目 + 今天新增/修改的 wiki 页
- **weekly**：本周的 daily reviews + log + wiki 变化
- **monthly**：本月的 weekly reviews + 所有长期目标状态

## Step 1 · 事实聚合

从 log.md 和 wiki 变化中聚合：
- 本期 ingest 了多少条输入
- 哪些页面被更新最频繁
- 哪些短期任务完成/延期/新增
- 哪些长期目标有进展/停滞

## Step 2 · 三类信号识别

### 偏好模式
用户反复纠正什么？→ 如果构成规则，提议写入 CLAUDE.md

### 背景变化
哪些长期目标的外部环境变了？→ 提议更新对应目标页

### 精力模式
什么被拖延/高效完成？→ 识别精力分配规律

## Step 3 · 第三定律触发

- 连续拖延同一目标 ≥ 3 次 → 质疑优先级
- 反复焦虑同一主题 → 提议单独深度思考
- 承诺未兑现超期 → 提醒

## Step 4 · 生成复盘页面

使用 review 模板：
```bash
obsidian create name="02-wiki/reviews/<period>/YYYY-MM-DD" template=review
```

然后编辑填入内容。开头用 TL;DR 写出关键发现。

## Step 5 · 追加信号到信号池

若发现值得在下次 evolve 中讨论的信号，
追加到 `03-schema/biweekly-signals.md`。

## Step 6 · 记录

在 log.md 追加：
`## [YYYY-MM-DD HH:MM] review | <period> review completed`
