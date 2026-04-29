---
type: changelog-entry
date: 2026-04-24
kind: manual
source: 陈言要求审计 ingest 机制，确认 3 项改动
status: executed
executor: claude
reviewed-by: linkc
---

# 引入 journal 类型 + 独立 linkc-compile skill + 学习机制

## 1. 迭代原因

### 触发信号
陈言问："我如果有一些灵感希望加入到笔记里，你会如何处理？"
→ 审计发现 3 个坑：
- **坑 1**：`.claude/skills/ingest/SKILL.md` 已被 plugin 的 UI/UX 设计 skill 覆盖，
  LinkcOS 自己的编译规则只存在 CLAUDE.md 里，没有独立 skill 文件
- **坑 2**：没有专门的"日常随笔/未决想法"类型，模糊输入（纯感受、一闪念）
  只能硬塞进 project / concept，分类不清
- **坑 3**：CLAUDE.md 的 "≥2 次规则" 语义模糊（跨会话？同一次输入里多次提及算几次？）

### 根本问题
缺了两个东西：
1. **一个正式的"未决想法"收件箱**——每天的日常随笔有地方落，不硬套已有类型
2. **一个学习回路**——让 Claude 的归属判断随时间变准，不靠陈言反复重复指令

## 2. 具体迭代内容

### 新增
- `.claude/skills/linkc-compile/SKILL.md`：完整编译流程的独立 skill 文件
  （7 步流水、归属判断决策树、journal append 规则、纠正吸收机制）
- `02-wiki/journal/`：日常随笔目录（每天一个 `YYYY-MM-DD.md`，当天追加）
- `02-wiki/journal/.gitkeep`：目录占位
- `03-schema/templates/journal.md`：新类型模板
- `03-schema/judgment-corrections.md`：归属纠正日志（Claude 追加，
  每次 ingest 前扫描，累积 ≥3 次同类纠正后提议升级为正式规则）
- `03-schema/types.md`：追加 `journal` 类型定义（第 10 种类型），
  更新 frontmatter `updated: 2026-04-24`，追加演化历史行

### 修改
- `CLAUDE.md # Wiki 编译纪律`：
  - 补清 "≥2 次" 规则的精确语义（跨不同 ingest 事件、不同时间戳累计）
  - 补一条：陈言纠正归属时追加到 judgment-corrections.md
  - 补一条：每次 ingest 回复必须明示 `判断：归 X（理由：...）` 和 `矛盾：无/⚠️`
  - 详细流程指向 `.claude/skills/linkc-compile/SKILL.md`
- `CLAUDE.md # 你能做的四件事` → `五件事`：追加 "**学习**" 为第 5 件

### 迁移
无（现有 9 种类型的 wiki 页面不受影响）

## 3. 有什么改进

### 直接改进
- 陈言的日常随笔有了归属——不用再硬塞进 project 页或丢失在 log 里
- Claude 的归属判断变**透明**：每次回复都说出 "归 X（理由：...）"，
  陈言可以一句话纠正
- 纠正被**吸收**：写入 corrections.md，下次 ingest 参照；累积后升级为规则
- "≥2 次规则" 不再模糊：同一次 ingest 多次提及不重复计数，跨时间戳才计

### 系统级改进
- **学习回路**落地：单次纠正 → 会话记忆 → 3 次后升级正式规则。
  系统可以从使用中自我训练，不靠陈言反复写规则
- 编译流程从 CLAUDE.md 内嵌升级为独立 skill 文件，可以独立演化、
  独立 lint、独立 benchmark（future）
- 类型系统从 9 种扩展到 10 种，增加的是"未分类收件箱"，降低了分类压力

## 4. 可能的影响

### 已评估的风险
- ⚠️ **归属判断一开始可能不准**：刚引入 journal 类型，Claude 可能过度
  把本该是 project 的输入也归为 journal，或反之。
  缓解：透明化回复 + corrections.md 吸收，2-3 周自稳
- ⚠️ **journal 文件膨胀**：一天 20 条随笔会让单个文件变长。
  缓解：types.md 写明"≥10 条当日由 reflect 做主题归纳"（未来由 reflect skill 处理）
- ⚠️ **corrections.md 无限膨胀**：纠正条目永远增长。
  缓解：累积 ≥3 次同类升级为正式规则后，对应 corrections 条目标注
  `↑ 已升级为正式规则`，reflect 周度整理可归档早期已解决条目

### 待观察的影响
- 📊 journal 条目的实际使用频率（每天几条？主要是什么主题？）
- 📊 归属纠正的频率（前两周预计多，之后应明显下降）
- 📊 "升级建议"的采纳率（journal → project 的升级提议有多少被陈言接受？）
- 📊 `.claude/skills/ingest/` 被 plugin 重装时会不会再次覆盖——本次绕开了它
  （新 skill 在 `linkc-compile/`），但下次 plugin 更新需要留意

### 回退预案
所有改动落在独立文件，回退路径干净：
- 删 `.claude/skills/linkc-compile/` 整个目录
- 删 `02-wiki/journal/` 整个目录
- 删 `03-schema/judgment-corrections.md`
- 删 `03-schema/templates/journal.md`
- `types.md` 移除 journal 类型条目 + 恢复演化历史
- `CLAUDE.md` 恢复原"Wiki 编译纪律"章节 + 恢复"四件事"章节

全部可 git revert 单次回退。
