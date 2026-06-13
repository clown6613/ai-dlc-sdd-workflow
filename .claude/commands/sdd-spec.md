# /sdd-spec — Intent から Spec を生成する

**使い方:**
- `/sdd-spec specs/<feature>/` — フォルダを指定（`intent.md` を自動で読み込む）
- `/sdd-spec` — 引数なしで実行すると、最近作成された Intent の一覧から選べる

---

## このコマンドがすること

指定されたフォルダの `intent.md` を読み込み、SDD の3ステージ Spec（`spec.md`）を生成します。

1. `intent.md` を読んで内容を理解する
2. 不明な点があれば**実装前に質問する**（コアメンタルモデル）
3. CLAUDE.md のルールに従って `spec.md` を生成する:
   - Stage 1: 要件（EARS記法）
   - Stage 2: 設計
   - Stage 3: タスクリスト（SMAV）
4. Mob Elaboration を促す

---

## 実行手順

### Step 0: 対象フォルダを決める

`$ARGUMENTS` が指定されていれば、そのフォルダを使う（末尾の `/` は任意）。

**指定がない場合:**

```bash
find specs/ -name "intent.md" | xargs ls -t 2>/dev/null
```

結果を新しい順に提示し、番号で選んでもらう:

> `specs/` 内の Intent（新しい順）:
>
> 1. `specs/user-auth/`（10分前）
> 2. `specs/push-notification/`（昨日）
> 3. `specs/profile-edit/`（3日前）
>
> 番号を選ぶか、別のパスを入力してください。

`specs/` が空または存在しない場合:

> `specs/` に Intent が見つかりません。  
> 先に `/sdd-intent` で Intent を作成してください。

---

### Step 1: intent.md を読み込む

確定したフォルダの `intent.md` を Read ツールで読み込む。

---

### Step 2: 不明点を質問する

Intent の内容を分析し、Spec 生成に必要な情報が不足している場合は**実装前に質問する**。

質問すべき典型例:
- 認証・認可の方式（例: JWT トークン？セッション？）
- 既存コードとの統合方法（例: 既存の API クライアントを使う？新規作成？）
- エラー時のユーザー体験（例: トーストで表示？画面遷移？）
- パフォーマンス要件の具体値（例: タイムアウトは何秒？）

---

### Step 3: spec.md を生成する

`intent.md` と同じフォルダに `spec.md` を生成する。  
`templates/spec.md` の構造に従い、以下の3ステージで記述する。

#### Stage 1: 要件（EARS記法）

Intent の Completion Criteria をもとに、すべての要件を EARS 記法で記述する。

```
# 正常系の例
WHEN ユーザーがログインフォームに正しい認証情報を入力して送信する,
  the システム SHALL アクセストークンを発行してホーム画面に遷移する

WHEN ユーザーがアプリをバックグラウンドから復帰させる,
  the システム SHALL トークンの有効期限を確認してセッションを維持する

The システム SHALL すべての通信を HTTPS で暗号化する

# 異常系の例
WHEN ユーザーが誤った認証情報を入力して送信する,
  the システム SHALL 「メールアドレスまたはパスワードが正しくありません」と表示し再入力を促す

WHEN ネットワーク接続がない状態でリクエストが発生する,
  the システム SHALL リトライボタン付きのエラーメッセージを表示する
```

正常系・異常系・非機能要件の3種を必ず含める。

#### Stage 2: 設計（Design）

**アーキテクチャ概要:** 関与するコンポーネントとその責務を図または箇条書きで示す。

```
# 例（ログイン機能）
UI（LoginScreen）
  ↓ 入力値バリデーション
AuthUseCase
  ↓ 認証リクエスト
AuthRepository
  ↓ API 呼び出し
AuthAPI（/api/v1/auth/login）
  ↓ レスポンス
TokenStorage（ローカルへの保存）
  ↓
ホーム画面へ遷移

# 例（プッシュ通知）
NotificationService
  ↓ デバイストークン登録
PushAPI（/api/v1/devices）
  ↓
NotificationRepository（ローカルキャッシュ）
```

**インターフェース定義:** API・関数・コンポーネントの入出力を定義する。

```
# API エンドポイントの例
POST /api/v1/auth/login
  リクエスト: { email: string, password: string }
  レスポンス（200）: { accessToken: string, refreshToken: string, expiresAt: number }
  エラー（401）: { code: "INVALID_CREDENTIALS", message: string }
  エラー（429）: { code: "RATE_LIMITED", retryAfter: number }

# 型定義の例
interface AuthTokens {
  accessToken: string
  refreshToken: string
  expiresAt: number
}

interface AuthError {
  code: "INVALID_CREDENTIALS" | "RATE_LIMITED" | "NETWORK_ERROR"
  message: string
}
```

**エラーハンドリング方針:** エラーの種類ごとに対処を定める。

#### Stage 3: タスクリスト（SMAV）

Intent の成功ケース・失敗ケース・品質ゲートをもとに、原子的なタスクに分解する。

```
# タスク例（ログイン機能）
- [ ] Task 1: LoginScreen UI を実装する
      内容: メールアドレス・パスワード入力欄と送信ボタンを実装
      成功条件: 両フィールドが空の場合、送信ボタンが非活性になる
      品質チェック: yarn test LoginScreen

- [ ] Task 2: AuthUseCase.login() を実装する
      内容: 入力値バリデーション → AuthRepository.login() 呼び出し → トークン保存
      成功条件: 正常系でアクセストークンが TokenStorage に保存される
      品質チェック: yarn test AuthUseCase

- [ ] Task 3: エラーハンドリングを実装する
      内容: INVALID_CREDENTIALS → エラーメッセージ表示 / NETWORK_ERROR → リトライ UI
      成功条件: 各エラーコードに対応する UI が表示される
      品質チェック: yarn test AuthUseCase --coverage

- [ ] Task 4: 品質ゲート
      内容: テスト・型チェック・lint をすべて通過させる
      成功条件: テストカバレッジ 80% 以上、型エラーゼロ、lint エラーゼロ
      品質チェック: yarn test && tsc --noEmit && eslint . --max-warnings 0
```

---

### Step 4: Mob Elaboration を促す

生成後に次のメッセージを表示する:

> ✅ `specs/[機能名]/spec.md` を生成しました（タスク全 N 件）。
>
> **次のステップ:**
> 1. チームで Spec をレビューする（Mob Elaboration）
>    - 要件に漏れ・誤りがないか
>    - 設計がアーキテクチャと整合しているか
>    - タスクが適切な粒度に分割されているか
> 2. 承認したら `spec.md` のステータスを `Approved` に変更する
> 3. （任意）タスク管理ツールに登録する → `/sdd-register specs/[機能名]/`
> 4. 実装を開始する → `/sdd-implement specs/[機能名]/`

---

## 生成品質のチェックポイント

- [ ] すべての要件が EARS 記法で記述されているか
- [ ] 正常系・異常系・非機能要件の3種が含まれているか
- [ ] 設計にエラーハンドリング方針が含まれているか
- [ ] タスクが SMAV 原則に従っているか（1タスク = 1つのことのみ）
- [ ] 各タスクに検証可能な完了基準とコマンドが書かれているか

## 注意

- Spec 生成後すぐに実装を開始しない
- 必ず人間の承認（Mob Elaboration）を待つ
- Intent に曖昧な点がある場合は推測して進めず、質問する
