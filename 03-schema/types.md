---
type: schema-registry
updated: 2026-04-29
---

# LinkcOS 类型定义

> 本文件是所有 wiki 页面类型的权威定义。
> Claude 每次会话启动时必读。
> 修改需通过双周提案或 hotfix 流程。

## entity-person
人物。有社会角色、持续关系、承诺记录。
- frontmatter: name, role, relation, last-contact, status, commitments[], links[]
- 位置: `02-wiki/entities/people/`
- 模板: `03-schema/templates/person.md`

## entity-org
组织。有类型、关键人物。
- frontmatter: name, org-type, key-people[], status, links[]
- 位置: `02-wiki/entities/orgs/`
- 模板: `03-schema/templates/org.md`

## entity-product
产品或工具。有用途、评价。
- frontmatter: name, category, status, links[]
- 位置: `02-wiki/entities/products/`
- 模板: `03-schema/templates/product.md`

## project
有明确产出目标、里程碑、KPI 的工作。
- frontmatter: name, status, stage, kpi[], deadline, stakeholders[], links[]
- 位置: `02-wiki/projects/`
- 模板: `03-schema/templates/project.md`

## short-goal
短期任务（< 3 个月），有具体 deadline。
- frontmatter: name, status, deadline, energy, assigned-by, blockers[], links[]
- 位置: `02-wiki/goals/short/`
- 模板: `03-schema/templates/short-goal.md`

## long-goal
长期目标（≥ 3 个月），关注背景变化。
- frontmatter: name, status, kpi[], last-context-update, links[]
- 位置: `02-wiki/goals/long/`
- 模板: `03-schema/templates/long-goal.md`

## concept
方法论、理论、反复出现的思维模式或知识点。
- frontmatter: name, source[], related-people[], links[]
- 位置: `02-wiki/concepts/`
- 模板: `03-schema/templates/concept.md`

## decision
已做出的重要决策。
- frontmatter: date, context, involved[], consequences[], links[]
- 位置: `02-wiki/decisions/`
- 模板: `03-schema/templates/decision.md`

## review
日/周/月复盘。
- frontmatter: period, date, summary
- 位置: `02-wiki/reviews/`
- 模板: `03-schema/templates/review.md`

## build-in-public
对**他人**有用的成长 / 副业 / 创业 / 自媒体 / 互联网产品经验沉淀。
与 concept 的区别：concept 是陈言私人的方法论锚点（自用），
build-in-public 是抽离个人变量后**对他人可复用**的经验、SOP、案例、playbook。

**判断标准**：内容的受益者是谁？
- 受益者=陈言自己 → concept / project
- 受益者=他人（特别是自媒体/互联网产品/副业创业新手）→ build-in-public

**字段**：
- frontmatter: name, audience, source-experience[], status, related-projects[], links[]
  - `status`: `draft`（仍在迭代）/ `stable`（已成熟，不常变）
  - `audience`: 内容受众（如"自媒体新手"、"想做副业的产品经理"）
  - `source-experience[]`: 经验来源（陈言哪些实践提炼出来的）
- 位置: `02-wiki/build-in-public/`
- 模板: `03-schema/templates/build-in-public.md`

## journal
日常随笔、一闪念、未决想法、纯感受观察——承接那些还没法归到
project/goal/concept/entity 的输入。

**特殊性**：
- 按日期（天粒度）命名，不按实体
- 同一天的所有随笔 append 到同一个文件，不新建
- 条目达到"可升级"阈值（含 deadline、涉及明确产出、同主题 ≥2 次）时，
  Claude 主动**提议**抽为独立 project/goal/concept 页面，不自动执行

**字段**：
- frontmatter: type, date, entries, related[]
- 位置: `02-wiki/journal/YYYY-MM-DD.md`
- 模板: `03-schema/templates/journal.md`

---

# 演化历史

- 2026-04-20: 初始类型集（genesis）—— 9 种基础类型
- 2026-04-24: 新增 `journal` 类型（manual）—— 10 种类型，承接未决想法
- 2026-04-29: 新增 `build-in-public` 类型（manual）—— 11 种类型，分离"对他人可复用经验"
