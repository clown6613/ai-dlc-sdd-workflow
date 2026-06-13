# /sdd-spec — Intent から Spec を生成する

**使い方:** `/sdd-spec [intent.md のパス]`  
例: `/sdd-spec specs/csv-download/intent.md`

---

## このコマンドがすること

指定された `intent.md` を読み込み、SDD の3ステージ Spec（`spec.md`）を生成します。

1. `intent.md` を読んで内容を理解する
2. 不明な点があれば**実装前に質問する**（コアメンタルモデル）
3. CLAUDE.md のルールに従って `spec.md` を生成する:
   - Stage 1: 要件（EARS記法）
   - Stage 2: 設計
   - Stage 3: タスクリスト（SMAV）
4. 生成した Spec を人間にレビューするよう促す

## 実行手順

1. `$ARGUMENTS` のパスの `intent.md` を Read ツールで読み込む
2. `CLAUDE.md` の Spec 生成ルールを参照する
3. Intent の内容を分析し、不明点があれば質問する
4. intent.md と同じディレクトリに `spec.md` を生成する
5. 生成後に「Mob Elaboration（チームレビュー）を行ってください」と案内する

## 生成品質のチェックポイント

Spec を生成する際、以下を必ず確認する:

- [ ] すべての要件が EARS 記法で記述されているか
- [ ] 正常系と異常系の両方が含まれているか
- [ ] 非機能要件が含まれているか（パフォーマンス・セキュリティ）
- [ ] 設計にエラーハンドリング方針が含まれているか
- [ ] タスクが SMAV 原則に従っているか（曖昧でないか）
- [ ] 各タスクに検証可能な完了基準があるか

## 注意

- Spec 生成後すぐに実装を開始しない
- 必ず人間の承認（Mob Elaboration）を待つ
- Intent に曖昧な点がある場合は推測して進めず、質問する
