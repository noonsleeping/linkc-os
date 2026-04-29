---
type: concept
name: Agent Harness
source:
  - "向阳乔木 2026-04-18"
  - "Anthropic Claude Code 文档"
  - "LangChain / OpenAI 实践"
  - "Vikash Rungta《Claude Code Architecture Reverse Engineered》2026-02-17"
related-people:
  - "[[me]]"
links:
  - "[[claude-code]]"
  - "[[ai-agent-paradigms]]"
  - "[[linkc-os]]"
created: 2026-04-20
updated: 2026-04-21
---

# Agent Harness

## 核心定义

**包裹 LLM 的完整软件基础设施**，使模型能够实际完成任务。

LangChain 公式："如果你不是模型，你就是 harness"

类比：原始 LLM = 没有内存/硬盘/I/O 的 CPU；Harness = 操作系统。

## 三层工程（从低到高）

| 层次 | 范围 |
|------|------|
| 提示词工程 | 精心制作模型接收的指令 |
| 上下文工程 | 管理模型看到什么、何时看到 |
| **Harness 工程** | 以上全部 + 工具编排、状态持久化、错误恢复、验证循环、安全执行、生命周期管理 |

## 生产级 Harness 的 12 个组件

1. **编排循环**：TAO/ReAct 循环（思考-行动-观察），本质是个 while 循环，复杂性在循环管理的所有内容
2. **工具**：注册、Schema 验证、沙盒执行、结果格式化
3. **记忆**：短期（对话历史）+ 长期（跨会话持久化）
4. **上下文管理**：对抗"上下文腐烂"（关键内容落在窗口中间性能下降 30%+）
5. **提示词构建**：系统提示 + 工具定义 + 记忆文件 + 对话历史 + 用户消息的分层组装
6. **输出解析**：现代 harness 依赖原生 tool_calls 结构化输出，无需解析自由文本
7. **状态管理**：检查点、中断恢复、时间旅行调试
8. **错误处理**：10 步流程每步 99% 成功率 → 端到端 90.4%，错误快速复合
9. **防护栏与安全**：输入/输出/工具三层防护，权限执行与模型推理分离
10. **验证循环**：规则验证（测试/linter）+ 视觉验证 + LLM 作为评判者；验证能力 → 质量提升 2-3 倍
11. **子智能体编排**：Fork / Teammate / Worktree（Claude Code）；智能体作为工具 / 交接（OpenAI）
12. *(提示词构建已含在第 5 条，第 12 项为生命周期管理)*

## 七个架构决策

1. 单智能体 vs 多智能体（优先最大化单 agent，工具 >10 个才考虑拆分）
2. ReAct vs 计划-执行（LLMCompiler 报告快 3.6 倍）
3. 上下文窗口策略（时间清除 / 总结 / 遮蔽 / 结构化笔记 / 子智能体委托）
4. 验证循环设计（计算验证 + 推理验证组合）
5. 权限架构（宽松 vs 限制性，取决于部署环境）
6. 工具范围（更多工具 ≠ 更好；Vercel 删除 80% 工具后效果更好）
7. **Harness 厚度**：薄 harness + 强模型（Anthropic 路线） vs 显式控制图（LangGraph 路线）

## Rungta 六大架构转变（Claude Code 案例）

Vikash Rungta 逆向工程 Claude Code 后提炼的框架，与上述通用 harness 理论高度吻合：

1. **Loop 取代 Workflow** — "代码控制模型"→"模型控制循环"。Runtime 是哑的，模型是 CEO。
2. **Harness is the Body** — LLM = 大脑，Harness 给它身体（Shell、文件系统、内存）
3. **Primitives > Integrations** — Bash/Grep/Edit 原语可组合任意工作流，胜过 100 个脆弱插件
4. **Context Economy** — auto-compaction + sub-agents + 语义搜索对抗"Context Collapse"
5. **结构性失败 → 托管特性** — 失控循环、失忆、权限混乱是可管理的架构约束，不是 bug
6. **Co-Evolution** — Harness 设计为随模型变强而变薄；Anthropic 定期删除已被模型内化的规划步骤

### Claude Code 的 5 个设计支柱

1. **Model-Driven Autonomy** — 模型决定下一步，非硬编码脚本
2. **Context as a Resource** — auto-compaction + 语义搜索保护上下文窗口
3. **Layered Memory** — 6 层记忆在会话开始时加载，agent 永不从零启动
4. **Declarative Extensibility** — 通过 .md 和 .json 添加 Skills/Agents/Hooks，无需写 TypeScript
5. **Composable Permissions** — 工具级 allow/deny/ask，从"全问"到"全放行"可调

### 其他细节

- **Session Continuity** — 会话像 git branch：可 checkpoint、rollback、fork 探索路径
- **"Collapsed but Available" UX** — 三层展示：默认最小化噪音，但信息永不隐藏；用户见到的模型也见到
- **Context Collapse** — 命名的失败模式：记忆退化导致幻觉，是结构性瓶颈非偶发 bug

## 关键洞察

- **Harness 就是产品**：相同模型，仅改变 harness，TerminalBench 排名移动 20+ 位
- **协同进化**：模型在使用特定 harness 的过程中被后训练，改变工具实现可能降低性能
- **harness 随模型变薄**：Manus 六个月重建五次，每次删减复杂性；Anthropic 定期从 Claude Code 删除规划步骤
- **未来验证测试**：性能随更强模型提升但 harness 复杂性不增加 → 设计合理

## Claude Code 的 harness 设计亮点

- "哑循环"哲学：所有智能在模型里，harness 只管理回合
- 延迟加载工具：95% 上下文减少
- git 提交作为检查点
- 三层记忆：轻量索引（始终加载）/ 详细文件（按需）/ 原始记录（仅搜索）
- Ralph Loop：跨上下文窗口的两阶段长任务模式

## 与 LinkcOS 的关联

LinkcOS 本身就是一个以 Claude Code 为 harness 的个人知识操作系统。文章的框架提供了理解 LinkcOS 架构的语言：
- CLAUDE.md = 系统提示词 + 提示词构建层
- Skills = 工具层
- Wiki = 长期记忆层
- 01-raw = 状态持久化层
- Hooks = 验证循环层

## 相关

- [[claude-code]]（文章多次引用其 harness 设计作为标杆）
- [[ai-agent-paradigms]]（陈言的 agent 分类框架，互补视角）
- [[linkc-os]]（LinkcOS 自身是一个 harness 实例）
