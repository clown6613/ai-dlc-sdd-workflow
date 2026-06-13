# SDD Workflow — Claude Code テンプレート

**Spec-Driven Development（仕様駆動開発）** を Claude Code で実践するためのテンプレートリポジトリです。  
サイバーエージェントの AI-DLC 教材に基づき、チーム開発向けに設計されています。

---

## 使い方

### 方法A: GitHub テンプレートから新規プロジェクト作成（推奨）

1. このリポジトリの **「Use this template」** ボタンをクリック
2. 新しいリポジトリ名を入力して作成
3. clone してプロジェクト開発を開始

### 方法B: 既存プロジェクトに導入

```bash
# このリポジトリを clone
git clone https://github.com/<your-org>/sdd-workflow /tmp/sdd-workflow

# 導入したいプロジェクトのルートで実行
cd /path/to/your-project
bash /tmp/sdd-workflow/setup.sh
```

既存ファイルを上書きしたい場合:
```bash
bash /tmp/sdd-workflow/setup.sh --force
```

### 方法C: curl で直接実行

```bash
# 導入したいプロジェクトのルートで実行
cd /path/to/your-project
bash <(curl -s https://raw.githubusercontent.com/<your-org>/sdd-workflow/main/setup.sh)
```

---

## 導入されるファイル

```
your-project/
├── CLAUDE.md                          ← Steering（SDDルールをClaudeに伝える）
├── templates/
│   ├── intent.md                      ← Intentテンプレート（コピー元）
│   └── spec.md                        ← Specテンプレート（コピー元）
├── specs/                             ← 各機能のIntent・Specを置く
└── .claude/
    ├── settings.json                  ← Hooks（型チェック・lint自動実行）
    └── commands/
        ├── sdd-spec.md                ← /sdd-spec コマンド
        └── sdd-review.md             ← /sdd-review コマンド
```

---

## ワークフロー概要

```
1. Intent 作成（人間）
   cp templates/intent.md specs/<feature>/intent.md
   # Description・Context・Completion Criteria を記述

2. Spec 生成（AI）
   /sdd-spec specs/<feature>/intent.md
   # AIがEARS要件・設計・SMAVタスクリストを生成

3. Mob Elaboration（チームでSpecをレビュー・承認）

4. 実装（AI がタスクを1つずつ実装）

5. 品質ゲート（テスト・型チェック・lint — Hooksで自動実行）

6. /sdd-review → Mob Construction → マージ
```

詳細は [workflow-guide.md](./workflow-guide.md) を参照してください。

---

## ファイル説明

| ファイル | 役割 |
|---------|------|
| [`CLAUDE.md`](./CLAUDE.md) | Steering。EARS記法・SMAV・Human in the Loopルールを定義 |
| [`workflow-guide.md`](./workflow-guide.md) | Phase 1〜5 のステップバイステップ手順書 |
| [`templates/intent.md`](./templates/intent.md) | Intent（意図）の記入テンプレート |
| [`templates/spec.md`](./templates/spec.md) | Spec（仕様書）の構造テンプレート |
| [`.claude/commands/sdd-spec.md`](./.claude/commands/sdd-spec.md) | `/sdd-spec` コマンド定義 |
| [`.claude/commands/sdd-review.md`](./.claude/commands/sdd-review.md) | `/sdd-review` コマンド定義 |
| [`.claude/settings.json`](./.claude/settings.json) | Hooks設定（ファイル保存時に型チェック・lint） |
| [`setup.sh`](./setup.sh) | 既存プロジェクトへの導入スクリプト |

---

## GitHub テンプレートリポジトリとして設定する方法

1. GitHub でこのリポジトリの **Settings** を開く
2. **General** タブの「Template repository」にチェックを入れる
3. 以降、他のリポジトリ作成時に「Use this template」が表示される

---

## 参考

- [AI-DLC 教材（はじめに）](../docs/00-introduction.md)
- [SDD アプローチの解説](../docs/03-approaches.md)
- [エレベータサイネージ事例（SDD + スクラム）](../docs/04-case-studies.md#case-3-エレベータサイネージ--sdd--スクラム融合)
