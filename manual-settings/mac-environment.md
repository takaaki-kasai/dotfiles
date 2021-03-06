# macOS 環境設定

## デスクトップとスクリーンセーバ

### スクリーンセーバ

* 開始するまでの時間: 開始しない
* ホットコーナー > 左下: ディスプレイをスリープさせる(ノートPCを除く)

## セキュリティとプライバシー

### 一般

* スリープとスクリーンセーバの解除にパスワードを要求 開始後: すぐに

## 省エネルギー

* ディスプレイを切にするまでの時間: 10分(スライダーをクリックすると時間が表示される)
* ディスプレイがオフのときにコンピュータを自動でスリープさせない: ON

## キーボード

### キーボード

* キーのリピート: 最大値(速い)
* リピート入力認識までの時間: 最大値(短い)
* 修飾キー > Caps Lock キー: Control

### ショートカット

* LaunchpadとDock > Launchpadを表示: F4
* Mission Control > Mission Control: Ctrl + ↑
* Mission Control > アプリケーションウィンドウ: Ctrl + ↓
* Mission Control > デスクトップを表示: F11

## マウス

* 「スクロールの方向: ナチュラル」: ON
* 軌跡の速さ: 7段階目（デフォルトは4段階目）
* スクロールの早さ: 5段階目（デフォルトは4段階目）
* ダブルクリックの間隔: 9段階目（上から3段階目、デフォルトと同じ）

# ターミナルで実行するコマンド

## ホスト名設定

```
sudo scutil --set ComputerName (ホスト名)
sudo scutil --set HostName (ホスト名)
sudo scutil --set LocalHostName (ホスト名)
```
