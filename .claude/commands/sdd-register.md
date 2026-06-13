# /sdd-register — タスクをタスク管理ツールに登録する

**使い方:**
- `/sdd-register specs/<feature>/` — フォルダを指定（`spec.md` を自動で読み込む）
- `/sdd-register` — 引数なしで実行すると、最近作成された Spec の一覧から選べる

---

## このコマンドがすること

`spec.md` の Stage 3 タスクリストを、指定したタスク管理ツールに登録します。  
`/sdd-spec` 実行後・Mob Elaboration 承認後のタイミングで使うことを想定しています。

---

## 実行手順

### Step 0: 対象フォルダを決める

`$ARGUMENTS` が指定されていれば、そのフォルダを使う（末尾の `/` は任意）。

**指定がない場合:**

```bash
find specs/ -name "spec.md" | xargs ls -t 2>/dev/null
```

結果を新しい順に提示し、番号で選んでもらう:

> `specs/` 内の Spec（新しい順）:
>
> 1. `specs/user-auth/`（10分前）★ Approved
> 2. `specs/push-notification/`（昨日）Draft
>
> 番号を選ぶか、別のパスを入力してください。

---

### Step 1: spec.md を読み込む

確定したフォルダの `spec.md` を Read ツールで読み込み、  
Stage 3 のタスクリスト（タスク名・内容・成功条件・品質チェックコマンド）を抽出する。

タスク一覧を表示する:

> **登録するタスク（全 N 件）:**
>
> - Task 1: [タスク名]
> - Task 2: [タスク名]
> - Task 3: 品質ゲート
>
> 登録先を選んでください:
>
> 1. Linear
> 2. GitHub Issues
> 3. Obsidian（`specs/[機能名]/tasks.md` に書き出す）
> 4. キャンセル

---

### Step 2: 選択した登録先に登録する

#### 登録先: Linear

1. `list_teams` ツールでチーム一覧を取得して提示する
2. ユーザーがチームを選択する
3. 各タスクを `save_issue` で登録する:
   - **title:** `[機能名] / [タスク名]`
   - **description:** 以下の形式で記述する

```
## 内容
[タスクの内容]

## 成功条件
[成功条件]

## 品質チェック
`[コマンド]`

---
Spec: specs/[機能名]/spec.md
```

4. 登録完了後、各タスクの Issue URL を一覧で表示する

---

#### 登録先: GitHub Issues

`gh issue create` コマンドで各タスクを登録する:

```bash
gh issue create \
  --title "[機能名] / [タスク名]" \
  --body "## 内容\n[内容]\n\n## 成功条件\n[成功条件]\n\n## 品質チェック\n\`[コマンド]\`\n\n---\nSpec: specs/[機能名]/spec.md"
```

登録完了後、各タスクの Issue URL を一覧で表示する。

---

#### 登録先: Obsidian

`specs/[機能名]/tasks.md` にチェックリスト形式で書き出す:

```markdown
# タスクリスト

> Spec: [./spec.md](./spec.md)
> 作成日: [今日の日付]

- [ ] Task 1: [タスク名]
  - 内容: [タスクの内容]
  - 成功条件: [成功条件]
  - 品質チェック: `[コマンド]`

- [ ] Task 2: [タスク名]
  - 内容: [タスクの内容]
  - 成功条件: [成功条件]
  - 品質チェック: `[コマンド]`
```

> ℹ️ このファイルを Obsidian から開くには、vault に `specs/` フォルダが含まれているか、  
> `specs/[機能名]/tasks.md` を vault 内の任意の場所にコピーしてください。

---

### Step 3: 完了を報告する

> ✅ タスク N 件を [ツール名] に登録しました。
>
> **次のステップ:**
> 1. Spec のステータスが `Approved` になっていることを確認する
> 2. 実装を開始する → `/sdd-implement specs/[機能名]/`

---

## 注意

- 同じ Spec を複数回登録すると重複する可能性があります。再登録前に既存のチケットを確認してください
- `tasks.md` がすでに存在する場合は上書き前に確認する
