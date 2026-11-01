# yaskkserv2-service

## 概要

Nixユーザ向けに [yaskkserv2](https://github.com/wachikun/yaskkserv2) をserviceとして提供するflakeモジュールです。

`flake.lock`では、リリースタグではなくupstreamの`master`にある
[0.1.8のコミット](https://github.com/wachikun/yaskkserv2/commit/08aabbc91a39c67ff2562b29f92c2a274bd0394b)を固定しています。

## 環境とビルド

Nixの`nix-command`と`flakes`を有効にして利用します。
flakeは`aarch64-darwin`、`x86_64-darwin`、`x86_64-linux`、`aarch64-linux`向けにパッケージとappを公開します。

リポジトリのルートで次を実行できます。

```shell
nix build .#yaskkserv2
nix run .#yaskkserv2 -- --version
nix flake check --no-build
```

パッケージのビルドではCargoのテストを実行しません。
upstreamのテストには辞書のダウンロードやネットワーク接続が必要です。

## モジュールの設定

利用するflakeのinputsに`yaskkserv2-service.url = "github:ttak0422/yaskkserv2-service";`を追加し、
nix-darwinでは次のように設定します。モジュールから`inputs`を参照できるよう、`specialArgs`などで渡してください。

```nix
{ inputs, ... }:
{
  imports = [ inputs.yaskkserv2-service.darwinModules.default ];
  services.yaskkserv2 = {
    enable = true;
    dictionary = "/path/to/dictionary.yaskkserv2";
    listenAddress = "127.0.0.1";
  };
}
```

NixOSではimportを`inputs.yaskkserv2-service.nixosModules.default`に置き換えます。
nix-darwinではユーザーのlaunchd agent、NixOSではsystemd serviceとして起動します。
その他の設定項目と既定値は[modules/options.nix](modules/options.nix)を参照してください。

## 利用にあたって

現時点でyaskkserv2向け辞書の管理機能は提供していません。辞書を作成するためのappを提供しているので、必要に応じて辞書を作成し、optionsで指定する必要があります。
ユーザ側でNixを利用して辞書を作るのも良さそうです。

```shell
nix run .#makeDirectory -- --dictionary-filename=/path/to/dictionary.yaskkserv2 ./skk-dev/dict/SKK-JISYO.L
```

## ソースの更新

他のNix inputを保ったままupstreamのソースを更新する場合は、次を実行します。

```shell
nix flake update yaskkserv2-src
```
