#!/bin/bash
# SDD ワークフロー セットアップスクリプト
# 使い方: 導入したいプロジェクトのルートで実行する
#   bash <(curl -s https://raw.githubusercontent.com/clown6613/ai-dlc-sdd-workflow/main/setup.sh)
# または clone 後:
#   bash /path/to/sdd-workflow/setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"

echo "SDD ワークフローを ${TARGET_DIR} に導入します..."
echo ""

# 既存ファイルの確認
warn_existing() {
  if [ -e "${TARGET_DIR}/$1" ]; then
    echo "  ⚠️  既存ファイルあり: $1 (スキップ。上書きする場合は --force を指定)"
    return 1
  fi
  return 0
}

FORCE=false
for arg in "$@"; do
  [ "$arg" = "--force" ] && FORCE=true
done

copy_file() {
  local src="$1"
  local dst="${TARGET_DIR}/$2"
  if [ "$FORCE" = true ] || [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  ✅ $2"
  else
    echo "  ⚠️  スキップ（既存）: $2"
  fi
}

echo "📄 CLAUDE.md（Steering）"
copy_file "${SCRIPT_DIR}/CLAUDE.md" "CLAUDE.md"

echo ""
echo "📁 テンプレート"
copy_file "${SCRIPT_DIR}/templates/intent.md" "templates/intent.md"
copy_file "${SCRIPT_DIR}/templates/spec.md"   "templates/spec.md"

echo ""
echo "🔧 Claude Code コマンド & Hooks"
copy_file "${SCRIPT_DIR}/.claude/commands/sdd-intent.md"    ".claude/commands/sdd-intent.md"
copy_file "${SCRIPT_DIR}/.claude/commands/sdd-spec.md"      ".claude/commands/sdd-spec.md"
copy_file "${SCRIPT_DIR}/.claude/commands/sdd-register.md"  ".claude/commands/sdd-register.md"
copy_file "${SCRIPT_DIR}/.claude/commands/sdd-implement.md" ".claude/commands/sdd-implement.md"
copy_file "${SCRIPT_DIR}/.claude/commands/sdd-review.md"    ".claude/commands/sdd-review.md"
copy_file "${SCRIPT_DIR}/.claude/settings.json"          ".claude/settings.json"

echo ""
echo "📂 specs/ ディレクトリを作成"
mkdir -p "${TARGET_DIR}/specs"
echo "  ✅ specs/"

echo ""
echo "✨ 完了！"
echo ""
echo "次のステップ:"
echo "  1. Claude Code で /sdd-intent specs/<feature-name>/ を実行（対話形式で Intent を作成）"
echo "  2. チームで Intent をレビューしたら /sdd-spec specs/<feature-name>/intent.md を実行"
echo "  3. チームで Spec をレビュー（Mob Elaboration）して承認"
echo "  4. 実装 → /sdd-review specs/<feature-name>/spec.md でレビュー"
echo ""
echo "詳細: https://github.com/clown6613/ai-dlc-sdd-workflow"
