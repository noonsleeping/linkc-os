---
type: concept
name: AI Agent 三范式框架
source:
  - "陈言分析"
related-people:
  - "[[me]]"
links:
  - "[[museum-agent]]"
  - "[[claude-code]]"
created: 2026-04-20
updated: 2026-04-29
---

# AI Agent 三范式框架

## 核心观点

陈言提出的 AI agent 分类框架，将当前 agent 方案归为三种范式：

1. **模拟人类界面**：让 AI 操控人类 UI（如 Computer Use），通用但效率低
2. **自定义工具**：给 AI 专用 API/MCP 工具，高效但需开发
3. **平台原生 agent**：直接在平台内构建 agent（如 Claude Code），最自然但受限于平台

## 来源与上下文

在分析 Manus vs Claude MCP vs 平台原生方案时提出。

## 与我的关联

这个框架指导了 [[museum-agent|博物馆策展智能体]] 的技术选型，也影响了对 Claude Code 生态（Computer Use、MCP、Skills）的理解。

## 外部视角：Rungta 的"LLM 应用三纪元"

Vikash Rungta（2026-02-17）提出的历史演进框架，与陈言三范式互补：

| 纪元 | 特征 | 代表 |
|------|------|------|
| Chatbot | 无状态 Q&A | 早期 ChatGPT |
| Workflow | 代码驱动的刚性链 | n8n、LangChain DAG |
| **Autonomous Agent（Superagent）** | 模型驱动的循环 | Claude Code |

两个框架的切入角不同：陈言框架按**接入方式**（UI/API/平台原生）分类，Rungta 框架按**控制权归属**（代码 vs 模型）分类——合并使用可以更全面描述一个 agent 的定位。

## 信号补充

### 2026-04-21｜屏幕作为 Agent 的记忆来源（OpenAI Codex Chronicle）

OpenAI 给 Codex 上线 Chronicle 功能：让 agent 把**用户屏幕内容**作为持久 memory 源。
- 不是新的范式分类——是对范式 1（模拟人类界面）的**反向应用**：
  - 范式 1：agent 操控人类 UI（如 Computer Use）
  - Chronicle：agent **观察**人类操控 UI，补全上下文
- 关键能力：补全代词指代（"this / that / latest"）、记住常用工具和工作流、跨 session 持久
- 待观察：是否会成为 agent 通用模式（Anthropic / 其他 IDE 是否会跟进）

详见 [[journal/2026-04-24]] 的"Codex Chronicle"条目。

## 相关

- [[museum-agent]]
- [[claude-code]]
- [[agent-harness]]
- [[design-md-spec]]
