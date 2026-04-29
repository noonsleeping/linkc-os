# 依赖清单

LinkcOS 本身只是一组 Markdown + Skill 文件，运行时依赖外部 Agent harness 和工具链。下面是完整列表。

## 必需依赖

### 1. Claude Code（或等效 AI 编程 Agent）
- **用途**：主 Agent harness。所有 Skills（`.claude/skills/`）和 hooks（`.claude/settings.json`）都按 Claude Code 的格式编写。
- **安装**：https://claude.com/claude-code
- **替代**：理论上 Codex / AntiGravity / Cursor Agent / Cline 等其他 AI 编程 Agent 都可以读懂 [`AGENTS.md`](../AGENTS.md) 并执行 bootstrap，但 hooks 配置（SessionStart / Stop）只对 Claude Code 生效。其他 harness 跑核心 Skills 没问题，会少掉"会话简报自动注入"和"会话结束自动写 log"两个便利性功能。

### 2. Obsidian 桌面应用
- **用途**：渲染 `[[wiki-link]]` 双链；提供"双周演化提案"的人工审批 UI。也是 LinkcOS 默认的 vault 编辑界面。
- **安装**：https://obsidian.md
- **macOS 推荐**：`brew install --cask obsidian`（这种装法会自动 symlink 出下面的 Obsidian CLI）

### 3. Obsidian CLI（`obsidian` 命令）
- **用途**：6 个 Skills 中 4 个（linkc-compile / lint / reflect / query）调用 `obsidian create / append / move / property:set / search / unresolved` 来读写 vault，并自动维护双链索引。
- **来源**：从 Obsidian 1.x 的某个版本起，**官方 Obsidian.app 内置了这个二进制**（位于 `/Applications/Obsidian.app/Contents/MacOS/obsidian-cli`）。
- **macOS 启用方式**：用 brew cask 安装 Obsidian 时会自动 symlink 到 `/usr/local/bin/obsidian`。手动安装的话需要自己 `ln -s /Applications/Obsidian.app/Contents/MacOS/obsidian-cli /usr/local/bin/obsidian`。
- **验证**：`obsidian version` 应返回 Obsidian 版本号（如 `1.12.7`）。
- **fallback**：CLAUDE.md 已规定"CLI 命令失败时回退到直接文件操作"。Obsidian CLI 不可用时仍能跑，只是丢失双链自动索引能力。

### 4. Bash / Python 3
- **用途**：跑 hook 脚本（`.claude/scripts/session-brief.sh`）和未来你可能加的自动化脚本。
- **安装**：macOS / Linux 自带；Windows 需 WSL 或 Git Bash。

## 可选 / 扩展依赖

> 公开版仓库**不绑定**任何特定的扩展 Skill。下面只是参考——LinkcOS 用户可按需扩展。

- **NotebookLM MCP**（音频化电子书等用途）：原作者陈言的私有 vault 里挂着 [ebook-to-podcast](https://github.com/...) 这样的扩展 Skill，依赖 `uvx --from notebooklm-py notebooklm`。本仓库**不带这些扩展**。
- **Linear / Slack / Gmail MCP**：可以接入到 `linkc-compile` 的归属判断决策树里，让 LinkcOS 直接读取你工单/消息/邮件作为输入源。

## 跨平台说明

| 平台 | 核心可用性 | Hooks 可用性 | Obsidian CLI 可用性 |
|---|---|---|---|
| macOS | ✅ | ✅ | ✅（brew cask 安装即 OK） |
| Linux | ✅ | ✅ | ⚠️（Obsidian Linux 版本是否带 CLI 待确认；不带的话 fallback 到直接文件操作） |
| Windows | ✅（WSL 强烈推荐） | ⚠️（hook 命令是 bash 语法，需 WSL） | ⚠️（同上） |
