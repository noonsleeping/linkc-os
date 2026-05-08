# LinkcOS

> 一个**会成长的、平等协作的、敢质疑你的**个人操作系统。
> 由 AI Agent 维护的 Wiki，承载你的项目、决策、灵感、复盘。

陈言（小红书 @陈言 Linkc-Chen）的个人 OS。基于 [Andrej Karpathy 提出的 LLM-Wiki 想法](https://x.com/karpathy/status/1729609324302360969)，扩展出三层架构 + 三定律 + 6 个 Skill 流水。

**这是模板仓库**——你可以 fork 之后用任意 AI 编程 Agent（Claude Code / Codex / AntiGravity / Cursor / Cline / ...）让它自动帮你 bootstrap 出属于你自己的 LinkcOS。也可以只是来看看设计思路，不复刻。

---

## 三层架构

```
┌─────────────────────────────────────────────────┐
│  03-schema/    规则层 — 你和 AI 共同演化        │
│  03-schema/    Schema layer (你审批，AI 提议)   │
├─────────────────────────────────────────────────┤
│  02-wiki/      知识层 — AI 拥有，你审阅         │
│                Knowledge layer (AI writes)      │
├─────────────────────────────────────────────────┤
│  01-raw/       原文层 — 不可变，可追溯根基      │
│                Raw layer (immutable)            │
└─────────────────────────────────────────────────┘
```

详细见 [`docs/architecture.md`](docs/architecture.md)。

---

## 三定律（系统宪法的 CRITICAL 部分）

1. **平等协作**（Parity）—— AI 有独立判断，你有最终决策权
2. **成长迭代**（Growth）—— 每次互动都是系统自我更新的机会
3. **诚实反馈**（Honesty）—— 顺从比质疑容易，质疑是 AI 的核心价值

详细见 [`docs/philosophy.md`](docs/philosophy.md)。

---

## 6 个 Skill 流水

| Skill | 用途 | 触发 |
|---|---|---|
| **linkc-compile** | 把每条新输入编译到对应 wiki 页（核心流水） | 自动（每次发言） |
| **ingest** | UI/UX 设计资源参考库 | 显式查询 |
| **lint** | wiki 健康检查（断链 / 孤儿页 / 过时内容） | 周度定时 |
| **reflect** | 日 / 周 / 月复盘 | 定时或显式 |
| **query** | 带引用的 wiki 问答 | 显式调用 |
| **evolve** | 双周 schema 演化提案 | 双周定时 |

每个 Skill 的实现：`.claude/skills/<name>/SKILL.md`。

---

## 扩展 Skill（外部数据源接入）

LinkcOS 自带的 6 个 Skill 是核心 wiki 流水。下面这些 Skill 单独维护、独立 repo，专门处理特定外部数据源——通过 `04-workflow/` 接入层把数据搬到 wiki 后再加工。

| Skill | 用途 | 上游依赖 | Repo |
|---|---|---|---|
| **dayflow-ingest** + **dayflow-reflect** | 把 Dayflow 桌面活动 timeline 数据搬到 wiki，并生成 AI 日复盘 | [Dayflow](https://github.com/JerryZLiu/Dayflow)（macOS 桌面活动追踪） | [noonsleeping/dayflow-skills](https://github.com/noonsleeping/dayflow-skills) |

未来其他外部数据源 Skill 加进表格即可。

---

## 你能用这个仓库做什么

### 路径 A · 复刻自己的 LinkcOS

打开你的 AI 编程 Agent（Claude Code / Codex / AntiGravity / Cursor / Cline 等），把这段 prompt 完整复制给它：

```
我想基于 https://github.com/noonsleeping/linkc-os 这个模板搭建属于我自己的个人 OS。

请：
1. 读仓库根目录的 AGENTS.md，了解完整 bootstrap 协议
2. 按协议执行——AGENTS.md 会引导你问我关于我自己的问题（名字 / 角色 / 当前活跃项目），
   也会问我"想给系统起什么名字"（默认 `myos`，可以改）和"想 clone 到本机哪个目录"
3. 如果你不能直接执行 shell（比如你只是个 IDE 里的代码补全 agent），把要跑的命令告诉我，我自己跑

我会逐项回答。
```

详细搭建步骤见 [`SETUP.md`](SETUP.md)。Agent 协议见 [`AGENTS.md`](AGENTS.md)。

### 路径 B · 了解设计思路

不打算复刻，只是想看看一个由 AI 编译的个人 OS 怎么工作？读：

- [`docs/philosophy.md`](docs/philosophy.md) — 三定律的设计动机
- [`docs/architecture.md`](docs/architecture.md) — 三层架构怎么运转 + 双周提案制
- [`CLAUDE.md`](CLAUDE.md) — 系统宪法（直接由 Claude Code 在每次会话启动时加载）
- [`02-wiki/concepts/`](02-wiki/concepts/) — 6 篇方法论：AI Agent 范式 / 三委托原则 / 注意力模式 / 反内卷内容 / Agent Harness / Design.md 规范
- [`02-wiki/build-in-public/`](02-wiki/build-in-public/) — 4 篇 SOP：小红书商业化视频流水 / 副业变现 / 账号 OKR / 小红书内容方法论

### 路径 C · 看看 build-in-public 真实落地

我（陈言）在用这套系统跑自己的小红书账号 + AI Creative Lab 的工作。`02-wiki/build-in-public/` 下的 SOP 都是真实经验沉淀，已经按规则做了脱敏（具体合作品牌名脱敏为 `[品牌 X]`，金额和内部沟通细节略去）——但流程是真实的。

如果你也想做自媒体 / 副业 / Agent 基础设施落地，这些 SOP 是直接可复用的。

---

## 依赖

- **Claude Code**（或等效 AI 编程 Agent） — 必需
- **Obsidian** + Obsidian CLI — 必需（CLI 是官方 Obsidian.app 自带的）
- Bash / Python 3 — 必需

完整依赖清单见 [`docs/dependencies.md`](docs/dependencies.md)。

---

## License

[MIT](LICENSE)

---

## 致谢

- [Andrej Karpathy](https://x.com/karpathy) — LLM-Wiki 想法的原作者
- [Obsidian](https://obsidian.md/) — 双链 Markdown 编辑器和 CLI
- [Anthropic Claude Code](https://claude.com/claude-code) — 主 Agent harness

---

## 联系

- GitHub: [@noonsleeping](https://github.com/noonsleeping)
- 小红书：@陈言 Linkc-Chen

如果你 fork 之后做了有意思的扩展，欢迎提 Issue / PR。如果对设计有质疑或建议，更欢迎——参见第三定律。
