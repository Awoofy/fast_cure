# Fast Cure -GATCG Life Counter- 運用マニュアル

## 1. システム構成図

### 1.1 アプリケーション構成
```
Fast Cure
├── フロントエンド（Flutter Web/モバイル）
│   ├── UI層
│   │   ├── プレイヤー1エリア
│   │   ├── リセットボタン
│   │   └── プレイヤー2エリア
│   └── ステート管理層
└── 開発環境（Docker）
    ├── Flutter開発コンテナ
    └── ボリューム（ソースコード、依存関係）
```

### 1.2 開発環境構成
- Dockerコンテナ環境
  - イメージ: flutter_dev
  - ポート: 8080（Web開発サーバー）
  - ボリューム: 
    - flutter-cache
    - flutter-gradle
    - android-sdk
    - ソースコード

## 2. 監視項目

### 2.1 アプリケーション監視
1. **パフォーマンス指標**
   - UI応答性
   - アニメーションの滑らかさ
   - メモリ使用量

2. **エラー監視**
   - クラッシュレポート
   - 例外発生状況
   - UIレンダリングエラー

3. **ユーザー体験指標**
   - タップ操作の反応速度
   - 画面遷移の安定性

### 2.2 開発環境監視
1. **Dockerコンテナ**
   - コンテナの状態
   - リソース使用率（CPU/メモリ）
   - ボリュームの空き容量

2. **開発サーバー**
   - Web開発サーバーの稼働状態
   - ポート8080の利用可能性

## 3. 障害対応手順

### 3.1 アプリケーション関連の障害
1. **UIレンダリング問題**
   - 症状: 画面表示の乱れ、アニメーションの停止
   - 対応:
     1. アプリケーションの再起動
     2. キャッシュのクリア
     3. 問題が継続する場合はログを確認

2. **パフォーマンス低下**
   - 症状: 操作の遅延、アニメーションのカクつき
   - 対応:
     1. メモリ使用量の確認
     2. デバッグモードでのプロファイリング
     3. パフォーマンスボトルネックの特定

### 3.2 開発環境の障害
1. **Dockerコンテナの問題**
   ```bash
   # コンテナの状態確認
   docker ps

   # コンテナの再起動
   docker compose down
   docker compose up -d

   # ログの確認
   docker logs flutter_dev
   ```

2. **開発サーバーの問題**
   ```bash
   # サーバーの再起動
   docker exec flutter_dev flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
   ```

## 4. メンテナンス手順

### 4.1 定期メンテナンス
1. **依存関係の更新**
   ```bash
   # パッケージの更新確認
   docker exec flutter_dev flutter pub outdated

   # パッケージの更新
   docker exec flutter_dev flutter pub upgrade
   ```

2. **キャッシュクリア**
   ```bash
   # ビルドキャッシュのクリア
   docker exec flutter_dev flutter clean

   # パッケージの再取得
   docker exec flutter_dev flutter pub get
   ```

### 4.2 バックアップ手順
1. **ソースコードのバックアップ**
   - Gitリポジトリによるバージョン管理
   - 定期的なコミットとプッシュ

2. **開発環境のバックアップ**
   ```bash
   # Dockerボリュームのバックアップ
   docker volume create flutter-backup
   docker run --rm -v flutter-cache:/source -v flutter-backup:/backup alpine tar czf /backup/flutter-cache.tar.gz -C /source .
   ```

## 5. デプロイメント手順

### 5.1 Webアプリケーションのデプロイ
```bash
# プロダクションビルド
docker exec flutter_dev flutter build web

# ビルド成果物の確認
ls build/web/
```

### 5.2 モバイルアプリケーションのビルド
```bash
# Androidビルド
docker exec flutter_dev flutter build apk

# iOSビルド（要macOS環境）
flutter build ios
```

## 6. トラブルシューティングガイド

### 6.1 よくある問題と解決策
1. **開発サーバーに接続できない**
   - ポート8080の使用状況確認
   - Dockerネットワークの確認
   - ファイアウォール設定の確認

2. **ビルドエラー**
   - 依存関係の競合確認
   - FlutterSDKのバージョン確認
   - ビルドキャッシュのクリア

### 6.2 パフォーマンスチューニング
1. **メモリ最適化**
   - 不要なウィジェットの削除
   - メモリリークの調査
   - ガベージコレクションの監視

2. **レンダリング最適化**
   - ウィジェットツリーの最適化
   - 不要な再描画の防止
   - アニメーションの効率化