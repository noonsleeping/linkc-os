# AGENTS.md — LinkcOS Bootstrap 协议

> If you are an **AI coding agent** (Claude Code / Codex / AntiGravity / Cursor / Cline / etc.) helping a user bootstrap their own LinkcOS instance from this template, **follow these steps strictly**. Don't skip steps. Ask the user when their input is required, instead of guessing.

---

## 你的目标

把这份模板仓库（一个三层 Karpathy LLM-Wiki 风格的"个人操作系统"骨架）变成 **属于这个用户自己的** LinkcOS：身份对、依赖装好、第一批种子页面落地、hooks 路径绑定到他的实际 vault 位置。

---

## Bootstrap 8 步流水

### 第 1 步｜核对依赖

读 [`docs/dependencies.md`](docs/dependencies.md)。逐项检查用户机器上是否安装：

| 依赖 | 检查命令 | 缺失时 |
|---|---|---|
| Claude Code（或等效 Agent harness） | 用户当前已经在用一个 → 跳过 | 提示用户安装 https://claude.com/claude-code |
| Obsidian 桌面应用 | `ls /Applications/Obsidian.app` (mac) / `which obsidian-app` | 提示用户去 https://obsidian.md 下载 |
| Obsidian CLI | `obsidian version` | 引导用户 brew cask 装 Obsidian 或手动 symlink |
| Bash | `bash --version` | 几乎不会缺；缺了让用户先解决 |

**未安装的依赖必须先解决**，不要跳过。

### 第 2 步｜采集用户身份和定制偏好

向用户连续提问（一次问全，不要逐条问，给他打字效率）：

**关于他自己**：

1. 你的中文名 / 英文名 / 想用的"我"的称呼？
2. 你的角色 / 简短身份（一两句话——比如 "某互联网公司的产品经理"、"独立开发者，正在做 AI 产品"）？
3. 现在最重要的 1-3 个项目是什么？（每个一句话）

**关于这个 OS 怎么放、怎么叫**：

4. 你想给你的个人 OS 起一个什么名字？
   - 默认保留 `LinkcOS`
   - 也可以改成 `MyOS` / `<你的名字>OS` / `Brain` / `第二大脑` / 任意你喜欢的
   - 这个名字会出现在 `CLAUDE.md`、session 简报、Skill 文件里——不影响 LICENSE 和原作者署名
5. 你想把这个仓库放在本机的哪个目录？
   - 默认 `~/linkc-os`
   - 如果你给系统改了名字，建议路径也对应改，比如 `~/my-os` 或 `~/brain`

记下用户回答，下面几步都要用。**用户在问题 5 给的目录就是 clone 目标**——如果第 1 步还没 clone，到这里再 clone（或者你已经 clone 了就 mv 过去）。

### 第 3 步｜重写 CLAUDE.md 的"# 身份锚点"块

打开根目录的 `CLAUDE.md`，找到 `# 身份锚点` 那一段。它长这样：

```markdown
# 身份锚点

<!-- ⚠️ 这一段是占位模板。Bootstrap 时由你或你的 AI Agent 改写为你自己的身份。... -->

我是 [Your Name]，[Your Role / 一两句身份简述]。
详细背景：[[02-wiki/entities/people/me]]（请基于 `03-schema/templates/person.md` 创建此页）
```

把它替换成用户的真实身份。把整个 `<!-- ... -->` 注释删掉。保留对 `[[02-wiki/entities/people/me]]` 的双链。

### 第 4 步｜创建 `02-wiki/entities/people/me.md`

读 `03-schema/templates/person.md` 拿到模板。按用户在第 2 步给的信息填好 frontmatter（name / role / relation 设为 `self`）和正文。

正文至少包含：
- 一段背景介绍（用户身份、角色、当前主要工作）
- 当前 / 长期目标（如果用户提到）
- "认识方式 / 信任来源"——填 `self`

### 第 5 步｜为每个活跃项目生成一个 project 页

对第 2 步用户列的每个活跃项目，读 `03-schema/templates/project.md` 模板，在 `02-wiki/projects/<slug>.md` 创建。frontmatter 至少填 `name`、`status: active`、`stage: in-progress`、`stakeholders: [me]`。正文先放一段当前状态（让用户后面 ingest 时再补 KPI / deadline）。

### 第 6 步｜起一个今日 journal

按 `03-schema/templates/journal.md` 模板，创建 `02-wiki/journal/<YYYY-MM-DD>.md`（`YYYY-MM-DD` 用真实当日日期，可执行 `date +%Y-%m-%d` 拿）。frontmatter 设 `entries: 1`。正文写一条 entry，记 "<系统名> 初始化完成 + bootstrap by <你这个 agent 是什么>"。

### 第 7 步｜把 hooks 路径绑定到用户实际 vault 路径

打开 `.claude/settings.json` 和 `.claude/scripts/session-brief.sh`：

- 这两个文件已经用 `${CLAUDE_PROJECT_DIR}` 变量做了模板化
- 如果用户用 Claude Code，**什么都不用改**——`CLAUDE_PROJECT_DIR` 会自动指向项目根目录
- 如果用户用其他不支持 `CLAUDE_PROJECT_DIR` 的 Agent harness（Codex / Cursor 等），把这两处变量替换为用户实际 vault 的绝对路径（比如 `/Users/<name>/<dir-name>`）

### 第 7.5 步｜重命名系统（可选——只在用户给了非 "LinkcOS" 的名字时执行）

如果用户在第 2 步问题 4 选了**自定义系统名**（比如 `BobOS` / `第二大脑` / `MyOS`），在以下文件做整词替换 `LinkcOS` → `<用户选的名字>`（保持出现位置的语义一致；中文/英文标点周围都要兼容）：

- `CLAUDE.md`
- `.claude/skills/*/SKILL.md`（6 个文件）
- `.claude/scripts/session-brief.sh`（包括注释和 echo 输出 `=== LinkcOS 简报 ===` 这一类）

**绝对不要改**：
- `LICENSE` — 保持原作者 Linkc-Chen 的版权署名
- `03-schema/changelog/` — 这是模板仓库的真实历史记录，篡改会让用户的 changelog 系统从一开始就活在虚假叙事里
- `docs/philosophy.md`、`docs/architecture.md`、`docs/dependencies.md` — 这些是讲述 LinkcOS 设计哲学和依赖的源版文档，引用的是模板本身（不是用户的系统）
- `README.md` / `AGENTS.md` / `SETUP.md` — 模板向导文档；建议用户 fork 后**直接删除或改写为他自己的版本**（这些主要给"想初始化"的人看，初始化完毕后对用户本人就没用了）

替换完成后向用户报告：`已把系统名从 LinkcOS 重命名为 <用户名字>，触及 N 个文件。LICENSE / 03-schema/changelog/ / docs/ 保持原样以保留模板溯源。`

如果用户保留了 "LinkcOS" 这个默认名字，**跳过这一步**——什么都不做。

### 第 8 步｜报告完成 + Next steps

向用户输出一个完成清单：

```
✅ 仓库已 clone 到 <实际目录>
✅ 系统名：<LinkcOS / 用户改的新名字>（如果改了，触及 N 个文件）
✅ 身份锚点已写入 CLAUDE.md
✅ me.md 已创建于 02-wiki/entities/people/
✅ N 个项目页已创建于 02-wiki/projects/
✅ 今日 journal 已创建于 02-wiki/journal/<date>.md
✅ Hooks 路径已绑定

接下来你可以：
1. 给我说说你今天发生了什么 / 想到了什么 → 我会按 linkc-compile 流程编译到对应 wiki 页面
2. /linkc-compile <text> 显式调用编译
3. /lint 检查 wiki 健康度（断链、孤儿页、过时内容）
4. /reflect day|week|month 做一次复盘
5. 用 Obsidian 打开这个目录，可视化浏览所有 wiki 链接

可选清理（用户可以自行决定）：
- 删除 README.md / AGENTS.md / SETUP.md（这些是给"想初始化"的人看的模板向导，对你已经没用了）
- 删除 docs/dependencies.md（如果你的依赖装好了不会再回头查）
- 保留 docs/philosophy.md 和 docs/architecture.md（设计哲学和架构文档，未来你忘了为啥这么设计时还能回看）

详细操作见各 SKILL.md。
```

---

## 通则

- **不要在 bootstrap 过程中删除 `01-raw/` 之外的任何东西**——第三定律明确不修改 01-raw
- **不要替用户做品味判断**——比如他可能想把"项目"叫"工作"或"任务"，跟用户确认而不是按你的偏好命名
- **Bootstrap 完成前不要触发 `linkc-compile` skill**——这个 skill 假设系统已经初始化完成
- **如果某一步用户说"先跳过"**——尊重用户决定，但在第 8 步的完成清单里诚实标 `⏭️ 跳过`
