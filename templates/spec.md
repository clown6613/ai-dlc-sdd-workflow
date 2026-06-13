# Spec テンプレート

> **使い方:** `/sdd-spec` コマンドを実行すると、`intent.md` の内容から AI がこのテンプレートを埋めます。
> AI が生成した内容を人間がレビュー・承認してから実装を開始します（Mob Elaboration）。

---

# [機能名] — 仕様書

**Intent:** [intent.md へのリンクまたはインライン参照]  
**ステータス:** Draft / Approved / In Progress / Done  
**最終更新:** YYYY-MM-DD

---

## Stage 1: 要件（Requirements）

> EARS 記法: `WHEN [条件], the システム SHALL [動作]`

### 機能要件（正常系）

```
WHEN [条件1],
  the システム SHALL [動作1]

WHEN [条件2],
  the システム SHALL [動作2]

The システム SHALL [常に適用される要件]
```

### 機能要件（異常系・エラーハンドリング）

```
WHEN [エラー条件1],
  the システム SHALL [エラー応答1]

WHEN [エラー条件2],
  the システム SHALL [エラー応答2]
```

### 非機能要件

```
The システム SHALL [パフォーマンス要件 — 例: API レスポンスを p95 で 300ms 以内に返す]
The システム SHALL [セキュリティ要件 — 例: すべての通信を HTTPS で暗号化する]
The システム SHALL [可用性要件]
```

---

## Stage 2: 設計（Design）

### アーキテクチャ概要

```
[コンポーネントとその責務を図または箇条書きで記述]

例（ログイン機能）:
  UI（LoginScreen）
    ↓ 入力値バリデーション
  AuthUseCase
    ↓ 認証リクエスト
  AuthRepository
    ↓ API 呼び出し
  AuthAPI（POST /api/v1/auth/login）
    ↓ レスポンス
  TokenStorage（ローカルへの保存）
    ↓
  ホーム画面へ遷移

例（プッシュ通知）:
  NotificationService
    ↓ デバイストークン登録
  PushAPI（POST /api/v1/devices）
    ↓
  NotificationRepository（ローカルキャッシュ更新）
```

### インターフェース定義

**API エンドポイント（該当する場合）:**

```
メソッド: POST
パス: /api/v1/...
認証: 必要 / 不要

リクエスト:
  ボディ:
    - email: string
    - password: string

レスポンス（成功）:
  ステータス: 200
  ボディ: { accessToken: string, expiresAt: number }

レスポンス（エラー）:
  401: 認証情報が不正
  429: レートリミット超過
```

**型定義（TypeScript の場合）:**

```typescript
// 主要な型のみ記載
interface LoginRequest {
  email: string
  password: string
}

interface AuthTokens {
  accessToken: string
  refreshToken: string
  expiresAt: number
}

type AuthErrorCode = "INVALID_CREDENTIALS" | "RATE_LIMITED" | "NETWORK_ERROR"
```

### データフロー

```
1. [ステップ1の説明]
2. [ステップ2の説明]
3. [ステップ3の説明]
```

### エラーハンドリング方針

| エラー | 原因 | ユーザーへの表示 | 処理 |
|--------|------|----------------|------|
| 401 Unauthorized | 認証情報が不正 | 「メールアドレスまたはパスワードが正しくありません」 | 再入力を促す |
| 429 Too Many Requests | ログイン試行超過 | 「しばらくしてからお試しください」 | retryAfter 秒後に再試行可能に |
| ネットワークエラー | 接続なし / タイムアウト | リトライボタン付きエラー画面 | ユーザー操作で再試行 |

---

## Stage 3: タスクリスト（Task List）

> 各タスクは **SMAV 原則**（Specific・Measurable・Atomic・Verifiable）に従って記述します。
> 依存関係がある場合は順序を保持してください。

### タスク一覧

- [ ] **Task 1:** [タスク名]
  - **内容:** [具体的に何をするか]
  - **成功条件:** [テスト可能な成功基準]
  - **品質チェック:** `[実行コマンド]`

- [ ] **Task 2:** [タスク名]
  - **内容:** [具体的に何をするか]
  - **成功条件:** [テスト可能な成功基準]
  - **品質チェック:** `[実行コマンド]`

- [ ] **Task N:** 品質ゲート
  - **内容:** テスト・型チェック・lint をすべて通過させる
  - **成功条件:** テストカバレッジ 80% 以上、型エラーゼロ、lint エラーゼロ
  - **品質チェック:** `yarn test && tsc --noEmit && eslint . --max-warnings 0`

### 推定工数

| フェーズ | 見積もり |
|---------|---------|
| 実装 | |
| テスト作成 | |
| レビュー対応 | |
| **合計** | |

---

## Mob Elaboration チェックリスト

チームが Spec をレビューする際に確認するポイント:

- [ ] 要件が EARS 記法で記述されているか
- [ ] 正常系・異常系・非機能要件の3種が網羅されているか
- [ ] 設計がアーキテクチャ上の制約と整合しているか
- [ ] タスクが SMAV 原則に従っているか（曖昧なタスクがないか）
- [ ] 完了基準が自動テストで検証可能か
- [ ] スコープ外の事項が intent.md に明記されているか

**承認:** __________________ 日付: __________
