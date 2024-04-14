{ lib, pkgs, yaskkserv2 }:
let inherit (lib) types mkOption mkEnableOption concatStringsSep;
in {
  services.yaskkserv2 = {
    enable = mkEnableOption "Enable yaskkserv2";
    package = mkOption {
      type = types.package;
      default = yaskkserv2;
    };
    dictionary = mkOption { type = types.str; };
    port = mkOption {
      type = types.int;
      default = 1178;
    };
    maxConnections = mkOption {
      type = types.int;
      default = 16;
    };
    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    hostnameAndIpAddressForProtocol3 = mkOption {
      type = types.str;
      default = "localhost:127.0.0.1";
    };
    googleTimeoutMilliseconds = mkOption {
      type = types.int;
      default = 1000;
    };
    googleCacheFilename = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    googleCacheEntries = mkOption {
      type = types.int;
      default = 1024;
    };
    googleCacheExpireSeconds = mkOption {
      type = types.int;
      default = 2592000;
    };
    googleMaxCandidatesLength = mkOption {
      type = types.int;
      default = 25;
    };
    maxServerCompletions = mkOption {
      type = types.int;
      default = 64;
    };
    googleJapaneseInput = mkOption {
      type = types.enum [ "notfound" "disable" "last" "first" ];
      default = "notfound";
    };
    googleSuggest = mkOption {
      type = types.bool;
      default = false;
    };
    googleUseHttp = mkOption {
      type = types.bool;
      # default: https
      default = false;
    };
    midashiUtf8 = mkOption {
      type = types.bool;
      # default: euc
      default = false;
    };
  };
}
