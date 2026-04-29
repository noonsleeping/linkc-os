---
type: concept
name: DESIGN.md 规范
source:
  - "https://github.com/google-labs-code/design.md"
  - "Google Labs 介绍视频（2026-04 发布）"
related-people:
  - "[[me]]"
links:
  - "[[ai-creative-lab]]"
  - "[[ai-agent-paradigms]]"
created: 2026-04-29
updated: 2026-04-29
---

# DESIGN.md 规范

## 核心观点

Google Labs 提出的格式规范，让 AI Agent 持久、结构化地理解一个**视觉设计系统**。

一个 DESIGN.md 文件由两层组成：
1. **YAML front matter**：机器可读的设计 token（颜色、字体、圆角、间距、组件……）
2. **Markdown 正文**：人类可读的设计理由（为什么是这些值、什么场合用）

> Token 给 agent 精确数值，正文告诉 agent **为什么**这些值存在以及如何应用。

## 关键设计

### Token 即"具名的设计决策"
- **角色（Role）**：定义元素的用途（如 `primary` = 页面主要墨水/文字色）
- **数值（Value）**：填充该角色的具体参数（如 `#1A1C1E`）
- 改 role 数值，所有引用该 role 的组件自动更新

### Components 字段（实验性）
- 组件属性可直接引用上层颜色 token（不写死色值）
- 支持变体（如 `button-primary-hover`）
- 顶层颜色 role 变化时所有组件外观同步调整

### 工具链
- **CLI Linter**：`npx @google/design.md lint DESIGN.md` — 验证规范合规、检查 WCAG 对比度
- **Diff 工具**：`npx @google/design.md diff DESIGN.md DESIGN-v2.md` — 检测 token 级和正文级回归
- **Stitch**（Google Labs 工具）：生成 DESIGN.md
- **Antigravity 环境**：AI Agent（如 Gemini 3.1 Pro）可直接读 DESIGN.md 生成 UI 组件，结合 Linter 自动校验对比度（< 4.5:1 自动调整以符合 WCAG）

## 与我的关联

直接相关 [[ai-creative-lab]] 的工作面：
- **AI 驱动的展览/策展项目**需要"设计语言交付给 AI"——传统方式是给 PSD / Figma，DESIGN.md 提供了一个**给 Agent 看的版本**
- 与陈言"AI Agent 三范式"的关系：DESIGN.md 是给"自定义工具"范式（agent + MCP）提供的标准化输入格式

## 待观察信号

- 是否会扩展到**完整的设计系统格式**（除视觉外，还含交互、动效、信息架构）
- Anthropic / OpenAI 的 Coding Agent 是否会原生支持 DESIGN.md 解析
- 在 [[ai-creative-lab]] 内部要不要试一次：把现有展览项目的视觉系统写成 DESIGN.md，看交付给 AI Agent 后的产出对比

## 相关

- [[ai-creative-lab]]
- [[ai-agent-paradigms]]
