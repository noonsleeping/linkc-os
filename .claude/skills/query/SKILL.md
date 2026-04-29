---
name: query
description: 回答关于 wiki 内容的问题。搜索相关页面，综合多源信息，
             给出带引用的答复。有价值的回答可归档回 wiki。
allowed-tools: Read Grep Glob Bash
---

# Query Skill · 从 Wiki 检索与回答

## Step 1 · 搜索相关页面

```bash
obsidian search query="<关键词>" format=json
```

若搜索结果不足，扩大范围用 Grep 扫描。

## Step 2 · 读取并综合

读取定位到的页面，综合回答。
回答中用 [[page]] 双链引用来源。

## Step 3 · 判断是否值得归档

如果这个回答本身有价值（深度分析、比较、策略），
主动问：
"这个分析要不要归档为 [[concepts/xxx]] 或 [[decisions/xxx]]？"

好的回答不应消失在聊天记录里。
