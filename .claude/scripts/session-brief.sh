#!/bin/bash
# LinkcOS Session Brief
# 每次 Claude Code 会话启动时自动执行，注入上下文简报

VAULT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

echo "=== LinkcOS 简报 ==="
echo ""

# 0. 真实日期（防 Claude Code 注入的 currentDate 缓存过时）
echo "📅 真实日期：$(date '+%Y-%m-%d (%a) %H:%M %Z')"
echo ""

# 1. 检查待审提案
PENDING=$(find "$VAULT/03-schema/proposals" -name "*.md" -exec grep -l "status: pending-review" {} \; 2>/dev/null)
if [ -n "$PENDING" ]; then
  echo "📋 有待审提案："
  for f in $PENDING; do
    echo "  · $(basename "$f" .md)"
  done
  echo ""
fi

# 2. 检查已审批待执行的提案
REVIEWED=$(find "$VAULT/03-schema/proposals" -name "*.md" -exec grep -l "status: reviewed" {} \; 2>/dev/null)
if [ -n "$REVIEWED" ]; then
  echo "✅ 有已审批待执行的提案："
  for f in $REVIEWED; do
    echo "  · $(basename "$f" .md)"
  done
  echo ""
fi

# 3. 最近系统迭代
LATEST_CHANGE=$(ls -t "$VAULT/03-schema/changelog/"*.md 2>/dev/null | head -1)
if [ -n "$LATEST_CHANGE" ]; then
  echo "🔧 最近系统迭代："
  echo "  · $(basename "$LATEST_CHANGE" .md)"
  echo ""
fi

# 4. 最近 5 条 log
if [ -f "$VAULT/02-wiki/log.md" ]; then
  echo "🕐 最近活动："
  grep "^## \[" "$VAULT/02-wiki/log.md" | tail -5 | sed 's/^/  /'
  echo ""
fi

# 5. wiki 页面统计
WIKI_COUNT=$(find "$VAULT/02-wiki" -name "*.md" -not -name ".gitkeep" | wc -l | tr -d ' ')
echo "📊 Wiki 页面总数: $WIKI_COUNT"
