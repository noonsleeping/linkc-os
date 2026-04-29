# SETUP.md — 给人类读者的快速搭建指南

> 想把这套 LinkcOS 在自己机器上搭起来？跟着这份指南走。整个流程的核心理念是：**让 AI Agent 帮你做大部分初始化**，你只需要回答几个关于自己的问题。

---

## 1. 装好依赖

详细列表见 [`docs/dependencies.md`](docs/dependencies.md)。最少需要：

- **Claude Code**（或类似的 AI 编程 Agent，比如 Codex / AntiGravity / Cursor / Cline）
  - 装：https://claude.com/claude-code
- **Obsidian** 桌面应用
  - macOS 推荐：`brew install --cask obsidian`（这种装法会自动配好 CLI）
  - 其他平台：从 https://obsidian.md 下载

装完验证：
```bash
obsidian version    # 应该输出 Obsidian 版本号
```

如果 `obsidian` 命令找不到，按 `docs/dependencies.md` 里"Obsidian CLI"那段处理。

---

## 2. Clone 仓库

先决定两件事：
- **你想给你的个人 OS 起什么名字？** 默认 `myos`；也可以改成 `<你的名字>OS` / `Brain` / `第二大脑` / `LinkcOS`（保留模板原名）/ 任意你喜欢的
- **想放在本机哪个目录？** 默认 `~/myos`（和系统名对齐）；起了别的名字建议对应改

然后 clone：

```bash
git clone https://github.com/noonsleeping/linkc-os.git ~/myos
cd ~/myos
```

如果你想用别的目录名（比如保留 LinkcOS 原名）：

```bash
git clone https://github.com/noonsleeping/linkc-os.git ~/linkc-os
cd ~/linkc-os
```

---

## 3. 让你的 AI Agent 接手 bootstrap

在你 clone 好的仓库目录下打开 AI 编程 Agent（Claude Code 在该目录启动；Codex / Cursor / AntiGravity 用 "open folder" 打开），把下面这段 prompt 完整复制给它：

```
请按 AGENTS.md 的 8 步 bootstrap 协议帮我初始化这个仓库。
先读 AGENTS.md 了解流程，然后从第 1 步"核对依赖"开始执行。
我会在你需要时回答关于我自己的问题，以及关于"系统名字"和"目录路径"的偏好。
```

Agent 会：
1. 检查依赖
2. 问你的名字 / 角色 / 当前活跃项目，以及你想给系统起的名字 + 仓库目录路径
3. 改写 `CLAUDE.md` 的身份锚点
4. 在 `02-wiki/entities/people/me.md` 写你的 self 页
5. 为每个活跃项目生成一个 project 页
6. 起一个今日 journal
7. 绑定 hooks 路径
7.5. 如果你给系统改了名字，把 LinkcOS → 你的新名字替换掉（CLAUDE.md / Skills / session-brief.sh，不动 LICENSE / changelog / docs）
8. 报告完成 + 下一步操作建议

整个过程大概 5-10 分钟。

---

## 4. 手动 fallback（不用 AI Agent 时）

如果你想自己一步步配，按 [`AGENTS.md`](AGENTS.md) 的步骤手工做：

1. 读 `docs/dependencies.md` 装齐依赖
2. 想清楚：身份 / 角色 / 1-3 个活跃项目，以及你想给系统起的名字 + clone 到哪个目录
3. clone 到你选的目录
4. 编辑 `CLAUDE.md` 的"# 身份锚点"块（删掉占位 + 注释）
5. 复制 `03-schema/templates/person.md` → `02-wiki/entities/people/me.md` 填好
6. 复制 `03-schema/templates/project.md` × N 份 → `02-wiki/projects/` 填好
7. 复制 `03-schema/templates/journal.md` → `02-wiki/journal/<今日>.md` 写第一条
8. 如果你的 Agent harness 不识别 `${CLAUDE_PROJECT_DIR}`，改 `.claude/settings.json` 和 `.claude/scripts/session-brief.sh` 里的路径变量为你的实际绝对路径
9. **如果你给系统起了非 LinkcOS 的名字**：在 `CLAUDE.md` / `.claude/skills/*/SKILL.md` / `.claude/scripts/session-brief.sh` 里把 `LinkcOS` 替换成你的新名字（不要动 `LICENSE` / `03-schema/changelog/` / `docs/`，那些是模板溯源信息）
10. 重启你的 Agent，给它说点你今天发生的事，看 `linkc-compile` skill 有没有正常工作

---

## 5. 第一次跑通后

回 [`README.md`](README.md) 看完整功能介绍，或者：

- 读 [`docs/philosophy.md`](docs/philosophy.md) 了解三定律的设计动机
- 读 [`docs/architecture.md`](docs/architecture.md) 了解三层架构怎么运转
- 读 `.claude/skills/*/SKILL.md` 看每个 Skill 具体能做什么

---

## 常见问题

**Q：我已经有自己的 Obsidian vault，可以把 LinkcOS 套到它上面吗？**
A：可以。把 LinkcOS 仓库 clone 到你 vault 里作为子目录，或者把 LinkcOS 的 `01-raw/`、`02-wiki/`、`03-schema/`、`CLAUDE.md`、`.claude/` 拷贝到你 vault 根目录。但要先备份。

**Q：必须用 Obsidian 吗？**
A：不严格必须。Obsidian 主要负责双链可视化和审批 UI，没它系统照样跑（Skills 里有 fallback）。但有它体验好得多。

**Q：能不能用其他 AI Agent，比如 Codex / Cursor / AntiGravity？**
A：可以读懂 `AGENTS.md` 和所有 SKILL.md 的 Agent 都能跑核心流程。Hooks（SessionStart / Stop）只对 Claude Code 生效——其他 Agent 不会自动加载会话简报和 log 收尾，但手工 `/linkc-compile` 调用照常工作。

**Q：我能 fork 之后自己改 Skills 吗？**
A：当然。每个 SKILL.md 都是纯 Markdown，按你的工作流调整。如果你做出有意思的改进欢迎提 PR。
