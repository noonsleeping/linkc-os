---
name: lint
description: Wiki 健康检查。检测孤儿页、断链、过时内容、未解矛盾。
             由定时任务（周度）或用户显式请求触发。
allowed-tools: Read Grep Glob Bash
---

# Lint Skill · Wiki 健康检查

## 检查清单

### 1. 断链检测
```bash
obsidian unresolved
```

### 2. 孤儿页检测
查找没有任何入链的 wiki 页面。

### 3. 未解矛盾
```bash
grep -r "⚠️" ~/linkc-os/02-wiki/ --include="*.md" -l
```
检查 ⚠️ 标记超过 7 天未处理的。

### 4. 过期内容
查找 `updated` 字段超过 14 天的活跃项目和长期目标。
```bash
obsidian search query="status::active" format=json
```
然后检查每个结果的 updated 字段。

### 5. 缺失页面
查找被提及 ≥ 3 次但没有独立页面的实体/概念。

### 6. index 同步
确认 index.md 的目录总览与实际文件结构一致。

## 输出

生成检查报告，列出每项发现和建议行动。
不自动修复——让用户决定。
