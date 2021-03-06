## リソースごとのスケールアップ/ダウンへの対応

| リソース名| スケールアップ/ダウン対応 | 無停止での変更 | 
|-------------------|:---:|:---:|
| サーバ             | ◯ | × |
| サーバ(ディスク)    | ◯ | × |
| サーバ(NIC)        | ◯ | × |
| ディスク           | × | - |
| スイッチ            | × | - |
| ルータ(帯域)       | ◯ | ◯ |
| ルータ(サブネット)  | ◯ | ◯ |
| ローカルルータ      | × | - |
| AWS接続オプション   | × | - |
| ロードバランサ      | × | - |
| データベース        | × | - |
| NFS               | × | - |
| VPCルータ          | × | - |
| エンハンスドロードバランサ| ◯ | ◯ |
| GSLB              | × | - |
| DNS               | × | - |


### サーバ          

プランを変更することでスケールアップが可能です。 プランの変更時にはサーバの再起動が必要です。  

関連する設定項目:
  - CPUコア数
  - メモリサイズ
  - コア共有/コア専有
  - 共有ホスト/専有ホスト

#### サーバのメモリサイズとNICの帯域幅

スイッチに接続されているNICについてはサーバのメモリサイズ(など)でNIC〜スイッチ間の帯域幅が決定されます。  
詳細はスイッチのセクションを参照してください。  

#### 注意点: プラン変更時にIDが変更される

プランを変更するとサーバのIDが変更されます。  
さくらのクラウドの外部でステートを管理している場合(Terraformなど)にはプラン変更前後でリソースの関連付けなどが必要になることがあります。  

> なおTerraformの場合、Terraformからプラン変更を行った場合はID変更に対応しています。
 
#### 注意点: プラン変更時の料金計算について

プラン変更時には変更前との料金の合算は行われません。  
例: プラン変更前に19日分、プラン変更後に11日分利用した場合、サーバの月額料金ではなくそれぞれのプランを利用した日数分の日割料金が適用されます。  

### サーバ(ディスク)    

サーバに接続するディスクは0個〜3個までの間で伸縮可能です。ディスクの接続/取外し時にはサーバを停止しておく必要があります。  

### サーバ(NIC)     

サーバに接続するNICは0個〜10個までの間で伸縮可能です。NICの追加/削除時にはサーバを停止しておく必要があります。

#### NICへのIPアドレス設定について

基本的に追加したNICへのIPアドレスの設定はさくらのクラウド側で管理されません。  
(例外的に先頭のNICについては「ディスクの修正」機能でIPアドレスの設定が可能です)  

### ディスク

ディスクサイズの伸長やディスクプランの変更(SSD <-> HDD)は行えません。  
これらを行いたい場合、既存のディスクをコピー元として新たにディスクを作成する必要があります。  

#### 注意点: パーティションサイズの変更作業について

ディスクサイズ伸長のために既存のディスクをコピーして新規作成した場合、新規作成したディスクのパーティションのサイズは変更されません。  
このため、新規作成したディスクに対しgrowpartコマンドなどでパーティションサイズを拡張する必要があります。

条件を満たしていればさくらのクラウドから提供されているパーティションサイズを拡張するスタートアップスクリプトも利用可能です。  

[参考: さくらのクラウド マニュアル: パーティションサイズの拡張](https://manual.sakura.ad.jp/cloud/storage/modifydisk/resize-partition.html#resize-partition)

### スイッチ         

スイッチ〜他機器間の帯域幅は一定で増減はできません。  
ただし、スイッチ〜サーバ間の接続についてはサーバのメモリサイズにより帯域幅が変わるケースもあります。  

詳細はさくらのクラウドマニュアルを参照してください。  

[参考: さくらのクラウド マニュアル: スイッチに帯域制限はありますか?](https://manual.sakura.ad.jp/cloud/support/technical/network.html#support-network-03)

### ルータ(帯域)      

ルータの帯域幅は100Mbps〜10,000Mbpsで変更可能です。変更は無停止で行えます(接続断は発生しません)。  
ただし、5,000Mbpsより大きな帯域については東京第2ゾーン(tk1b)でのみ利用可能です。  

#### 注意点: 帯域幅変更時の料金計算について

帯域幅変更時には変更前との料金の合算は行われません。  
例: 変更前に19日分、変更後に11日分利用した場合、月額料金ではなくそれぞれの帯域幅を利用した日数分の日割料金が適用されます。

通常ルータを再作成した場合はグローバルIPアドレスブロック(サブネット)分の月額料金が必要となりますが、帯域幅変更時は不要です(すでに割り当て済みのブロックが継続利用されます)。

### ルータ(サブネット)

追加でグローバルIPアドレスブロック(サブネット)を割り当て可能です。
コントロールパネル上では「スタティックルート追加」と表記されています。  

サブネットの追加/削除は無停止で行えます。  

#### 注意点: サブネット追加時の料金計算について

サブネットは月額料金のみとなっています。このため、作成ごとに月額料金が必要となります。  
頻繁に追加/削除するとその分料金がかかります。  

### ローカルルータ      

スペックや帯域幅は固定で変更できません。

### AWS接続オプション   

スペックや帯域幅は固定で変更できません。

### ロードバランサ      

作成後のプラン変更はサポートされておらず、異なるプランで新規作成する必要があります。  

帯域幅についてはルータに接続されている場合はルータ側の帯域幅を変更することで変更可能です。  

### データベース       

プランごとにスペック/データ容量が決まります。  
作成後のプラン変更はサポートされておらず、異なるプランで新規作成する必要があります。  
ただし、新規作成時には既存のデータベースアプライアンスをクローン元として指定可能です。  

帯域幅についてはルータに接続されている場合はルータ側の帯域幅を変更することで変更可能です。

### NFS

プランごとにスペック/データ容量が決まります。
作成後のプラン変更はサポートされておらず、異なるプランで新規作成する必要があります。
ただし、新規作成時には既存のNFSアプライアンスをクローン元として指定可能です。


### VPCルータ       

作成後のプラン変更はサポートされておらずスペックの変更はサポートされておらず、異なるプランで新規作成する必要があります。

### 注意点: 標準プランから上位プランへの変更

標準プラン以外では上流ネットワークとしてルータ+スイッチのみが指定可能です。  
このため、標準プランからより上位のプランへ移行する場合にはグローバルIPアドレスの引き継ぎが行えません。  

また、上位プランではVRIDやVIPの指定が必要になります。  

### エンハンスドロードバランサ

プラン変更によりCPSを増減可能です。プラン変更は無停止で行えます。  

### GSLB         

スペックは固定で変更できません。  

### DNS

スペックは固定で変更できません。