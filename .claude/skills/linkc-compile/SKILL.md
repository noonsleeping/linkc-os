---
name: linkc-compile
description: LinkcOS 的核心编译流程——把用户的每条新输入（灵感、观察、素材、决策、对话）编译到对应的 wiki 页面。每次用户在 LinkcOS 项目下发言时默认触发（不需要显式调用），也可通过 /linkc-compile 显式触发。包含：原文归档到 01-raw、归属判断决策树（journal / entity / project / goal / concept / decision）、wiki 页面更新、log 追加、冲突处理、判断透明化、错误纠正吸收。判断日常随笔、想法、deadline、合作人、新概念等输入归类到哪个 wiki 页面时必用此 skill。
---

# LinkcOS 编译 skill

这个 skill 定义了 LinkcOS 项目里**一条新输入进来**时你的完整处理流水。CLAUDE.md 里保留了铁律概要，这里是完整细则。

## 触发条件

- 用户在 LinkcOS 工作目录下发言，且内容包含新信息（想法、观察、素材、决策、对话片段等）——**自动触发**
- 显式 `/linkc-compile` 调用——强制按流程重新走一遍

## 流水（7 步）

### 1. 保存原文到 01-raw

- 路径：`01-raw/<category>/YYYY-MM-DD-HHMM-<slug>.md`
- 类别：`text/`（文字/口头）、`external/`（文章/剪报/视频）、`screenshots/`、`voice/`
- Frontmatter 必需：`date`、`type`、`source`
- **01-raw 只写，不改**。即使判断错了也不覆盖原文。

### 2. 读索引了解现状

- 读 `02-wiki/index.md` 把握整体结构
- 读 `03-schema/judgment-corrections.md` 吸收过去的纠正经验（见第 6 步）
- 读 `02-wiki/journal/YYYY-MM-DD.md`（如果今日文件已存在）—— 当日已有随笔可能影响新输入的上下文理解

### 3. 归属判断（决策树）

按**从上到下**的顺序判断，**命中即停**：

| 判断 | 归属 | 动作 |
|---|---|---|
| 含明确 deadline / KPI / 合作人 | `project` 或 `short-goal` | 新建或更新对应页 |
| 是对已存在 entity（人/组织/产品）的状态更新 | 更新对应 entity 页 | 追加内容 + 更新 `last-contact` 等字段 |
| 是外部素材（文章/视频/剪报，有原作者/URL） | `01-raw/external/` + 可能的 concept 页 | 原文归档 + 提炼观点到 concept |
| 是一个理论/框架/方法论（含引用源，非临时想法） | `concept` | 新建或更新 |
| 是已做出的决策（有动作、时间、影响） | `decision` | 新建 decision 页 |
| **以上都不满足——纯感受、未决想法、日常观察、一闪念** | **`journal`（当日文件）** | 新建或追加当日 journal |

**模糊 case 处理**：两条规则都可能命中时，**同时**追加到 journal **和**候选 wiki 页（用双链占位），并在 log 里注 `待用户确认归属`。

### 4. 更新 wiki 页面

- 一条输入可能触达 1-10 个页面（不是硬性 5-10）
- 新实体规则：**跨不同 ingest 事件（不同时间戳的输入）累计被明确提及 ≥2 次后**才创建独立页面。同一次 ingest 内反复提及仍计 1 次。"明确提及"=被直接命名，不含隐喻、不含括号补注。
- 首次提及的新实体只在 log 里记名字，不建页。
- Journal 页面的 append 逻辑见下方 §"Journal append 规则"。

### 5. 写 log

- 文件：`02-wiki/log.md`
- 格式：`## [YYYY-MM-DD HH:MM] <type> | <summary>`
- type ∈ `{ingest, query, review, lint, decision, schema-evolution}`
- summary 要列出触达页面，比如：`ingest | [项目名] 视频延期：更新 [[project-xhs-campaign]]，当日 journal 记一条`

### 6. 回复用户（透明化）

**每次 ingest 必须用这个格式收尾**：

```
判断：归 <类型> / 更新 <页面>（理由：<一句话启发式>）
触达：[[页面1]]、[[页面2]]...
矛盾：无 / ⚠️ <描述>
演化信号：无 / 已追加到 biweekly-signals.md
```

"理由"一定要具体到启发式层面，**不能**只说"我觉得应该这样"。例如："含已有 project 名 + 时间词 → 更新该 project 页"。

这样用户能**一句话纠正**："不对，这个应该进 concept"，你把纠正吸收到下一步。

### 7. 吸收纠正（学习机制）

当用户纠正归属时，立即追加一条到 `03-schema/judgment-corrections.md`：

```markdown
## [YYYY-MM-DD] <原判断> → <纠正后归属>（触发词/场景）
- 输入特征：<从原输入里提炼的识别特征>
- 我原本判断：<type>（理由：<当时的启发式>）
- 用户纠正：<新归属>
- 新启发式：**<提炼的规则，下次用>**
```

下次 ingest 前（流水第 2 步）你会再读一遍 corrections.md，让过去的纠正影响本次判断。**连续 ≥3 次同类纠正**时，主动提议把这条启发式升级到 CLAUDE.md 或本 skill 的决策树里（需用户确认）。

---

## Journal append 规则

路径：`02-wiki/journal/YYYY-MM-DD.md`

### 当日文件不存在（今日首条随笔）

新建文件，frontmatter：

```yaml
---
type: journal
date: YYYY-MM-DD
entries: 1
related: []
---

# 随笔 YYYY-MM-DD
```

然后追加第一条：

```markdown
## [HH:MM] <一句话小标题，10 字以内>
<原文或整理后的条目内容（保留用户的原意，不要过度加工）>

> 判断：归 journal（理由：<启发式>）
```

### 当日文件已存在

1. 读当前 frontmatter
2. Append 新条目到正文末尾（同上格式）
3. frontmatter 里 `entries` +1
4. 如果本条涉及其他 wiki 页，把双链加到 `related[]`（去重）

### 升级提议触发条件

在 journal append 完成后，检查是否满足**升级阈值**：

| 条件 | 升级动作 |
|---|---|
| 本条出现具体 deadline | 提议抽为 `short-goal` 或 `project`（stage: idea） |
| 本条涉及新合作人且有具体动作 | 提议抽为 `project` |
| 最近 7 天有 ≥2 条涉及同一主题 | 提议抽为 `concept` 页 |
| 当日 journal 条数 ≥10 | 提议当天做一次主题归纳（由 reflect 处理） |

触发时在回复里加一行：

```
💡 升级建议：本条满足"有 deadline"，建议抽为 short-goal <候选标题>。要做吗？
```

**不要自动执行升级**——等用户确认。

---

## 冲突处理

新信息与已有 wiki 条目冲突时，**不要静默覆盖**。标注：

```markdown
> ⚠️ [YYYY-MM-DD] 此前记录 X，新证据表明 Y。暂留两者，待用户确认。
```

每次 ingest 回复必须明确说"矛盾：无"或"矛盾：⚠️ ..."。不报告冲突状态 = 违反编译纪律。

---

## 好的回答要归档

会话中你做的深度分析、比较、策略建议——如果用户认可（"对的"、"就这样"、"有道理"等），主动提议存为 `02-wiki/concepts/` 或 `02-wiki/decisions/` 的新页面。

**格式**："要不要把这个分析存为 [[concepts/<slug>]]？这样下次讨论相关话题时可以直接引用。"

---

## Obsidian CLI 优先级

CLAUDE.md 规定优先用 Obsidian CLI（`obsidian create/append/move`），直接文件操作用于 01-raw、Schema 层、批量操作。

**降级记录**：CLI 命令失败时回退到直接文件操作，**必须**在 log.md 追一行：
```
## [YYYY-MM-DD HH:MM] ingest | obsidian CLI 失败（命令：xxx），回退到直接文件操作
```

让降级路径可观察。

---

## 不该做的事

- ❌ 不改 01-raw/ 下任何已存在的文件
- ❌ 不在不确定归属时强行单选——用双候选 + "待确认"标签
- ❌ 不静默覆盖矛盾——一定标 ⚠️
- ❌ 不自动升级 journal 条目到 project——提议，等确认
- ❌ 不擅自修改 CLAUDE.md——提议，等确认
- ❌ 不跳过透明化回复（"判断：..."那段）——哪怕用户已经很明显知道你要怎么做

---

## 快速决策参考

### "这条是 journal 还是 project？"

问三个问题：
1. 有 deadline / KPI / 合作人吗？→ **有** = project
2. 是对已有实体的状态更新吗？→ **是** = 更新 entity
3. 都不是？→ **journal**

### "这个新人/新概念要建独立页吗？"

问一个问题：
- 这是 **跨不同 ingest 事件** 的第 ≥2 次出现吗？
  - **是** = 建页
  - **否** = 只在 log 里记名字

### "用户纠正了我，我要做什么？"

1. 把归属改掉
2. 写一条到 `judgment-corrections.md`
3. 在回复里说"已吸收纠正"
4. 不要道歉，不要长篇解释——你的 corrections.md 更新就是对"下次不再犯"最好的承诺

---

## 相关文件

- `CLAUDE.md` — 三定律 + 编译纪律概要（本 skill 的上游）
- `03-schema/types.md` — 10 种类型的权威定义
- `03-schema/judgment-corrections.md` — 纠正案例（你写，你读）
- `03-schema/biweekly-signals.md` — 演化信号池（你观察到演化机会时追加）
- `02-wiki/log.md` — append-only 时间线
- `02-wiki/journal/` — 日常随笔目录
