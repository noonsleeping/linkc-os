---
type: changelog-entry
date: 2026-04-27
kind: manual
source: 陈言要求把"对他人可复用的成长/副业/创业/自媒体经验"从 concept 中切分出来
status: executed
executor: claude
reviewed-by: linkc
---

# 新增 build-in-public 类型 + 目录

## 1. 迭代原因

### 触发信号
2026-04-27 复盘 inbox 时，发现 04-27 当天集中产出 5 个 ChatGPT 长对话
（自媒体内容建设策略 / 账号 OKR / 小红书方法论 / 创作 SOP / 副业变现）。
按现有类型归类时，这些内容性质暧昧：
- 不是 `concept`（concept 是陈言私人方法论锚点，自用为主）
- 不是 `project`（不是要交付的具体产出）
- 不是 `journal`（不是未决想法）

陈言主动指出：这类内容的受众是**他人**——尤其在自媒体和互联网产品创业方向上
对其他人的成长有帮助的经验。他把这类内容统称为 "Build in Public"。

### 根本问题
现有 10 种类型缺一个**受众轴**：
- 现有所有类型默认受众都是陈言自己（用于 LinkcOS 内部辅助决策）
- 缺少一类专门承接"对他人可复用经验"的载体
- 这部分内容若硬塞进 concept，会污染 concept 的语义清晰度
  （concept 应该是陈言对话中复用的私人方法论锚点）

## 2. 具体迭代内容

### 新增
- `02-wiki/build-in-public/`：新分类目录
- `03-schema/templates/build-in-public.md`：新类型模板
  （字段：name, audience, source-experience[], status, related-projects[], links[]）
- 4 个首批入驻页面（来自 04-27 ingest）：
  - `xhs-methodology.md`（小红书打法手册，来自分享会笔记+陈言独立校准）
  - `xhs-commercial-video-sop.md`（商业化视频流程 SOP）
  - `side-hustle-monetization.md`（6 段副业变现历程）
  - `account-okr-thinking.md`（账号 OKR 思考方法）

### 修改
- `03-schema/types.md`：
  - 追加 `build-in-public` 类型定义（含与 concept 的判断标准）
  - 更新 frontmatter `updated: 2026-04-27`
  - 追加演化历史行（11 种类型）
- `03-schema/CHANGELOG.md`：追加本次 entry 索引

### 迁移
无（现有 wiki 页面不动；新建目录和文件）

## 3. 有什么改进

### 直接改进
- **受众轴显式化**：归属判断时多一个维度——这内容是给陈言用，还是给他人用？
- **concept 语义保护**：concept 不再被"对外可发布的经验"稀释
- **build-in-public 内容有归宿**：未来产出（小红书分享、播客、课程素材）有地方落

### 系统级改进
- 类型系统从 10 种扩展到 11 种，增加的是**受众导向**的分类轴
- 为未来"内容产品化"留接口：build-in-public 页面可直接作为
  小红书 / 播客 / 课程的素材库

## 4. 可能的影响

### 已评估的风险
- ⚠️ **判断模糊**：某些内容可能既是 concept 又是 build-in-public
  （例：陈言的"AI 委托三原则"既自用也可对外讲）。
  缓解：以**主要受益者**判断；同主题可在两边各放一份（侧重不同）
- ⚠️ **build-in-public 页面可能膨胀**：04-27 一次性就加了 4 个，未来 ingest 还会更多。
  缓解：按子主题（自媒体 / 副业 / 产品 / 创业）分目录或前缀

### 待观察的影响
- 📊 build-in-public 实际增长速度（每月几篇？）
- 📊 是否需要再细分子目录（如 `build-in-public/xhs/`、`/side-hustle/`）
- 📊 status 字段（draft / stable）是否会被实际使用

### 回退预案
- 删 `02-wiki/build-in-public/` 整个目录
- 删 `03-schema/templates/build-in-public.md`
- `types.md` 移除 build-in-public 类型条目 + 恢复演化历史
- 全部可 git revert 单次回退
