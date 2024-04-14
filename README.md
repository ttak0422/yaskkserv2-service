# yaskkserv2-service

## 環境

- [x] aarch64-darwin
- [x] x86_64-darwin (未テスト)
- [x] x86_64-linux
- [x] aarch64-linux (未テスト)

## 概要

Nixユーザ向けに [yaskkserv2](https://github.com/wachikun/yaskkserv2) をserviceとして提供するflakeモジュールです。

## 利用にあたって

現時点でyaskkserv2向け辞書の管理機能は提供していません。辞書を作成するためのappを提供しているので、必要に応じて辞書を作成し、optionsで指定する必要があります。
ユーザ側でNixを利用して辞書を作るのも良さそうです。

```shell
nix run .#makeDirectory -- --dictionary-filename=/path/to/dictionary.yaskkserv2 ./skk-dev/dict/SKK-JISYO.L
```
