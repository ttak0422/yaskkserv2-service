self:
{ config, lib, pkgs, ... }:
let
  inherit (lib) types mkOption mkEnableOption concatStringsSep;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) yaskkserv2;
  cfg = config.services.yaskkserv2;
in {
  options = {
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
  };
  config = lib.mkIf cfg.enable {
    users = {
      users.yaskkserv2 = {
        description = "yaskkserv2 daemon user";
        isSystemUser = true;
        group = "yaskkserv2";
      };
      groups.yaskkserv2 = { };
    };
    systemd.services.yaskkserv2 = {
      wantedBy = [ "default.target" ];
      serviceConfig = {
        User = "yaskkserv2";
        Group = "yaskkserv2";
        Restart = "always";
        ExecStart = concatStringsSep " " [
          "${lib.getBin cfg.package}/bin/yaskkserv2"
          cfg.dictionary
          "--no-daemonize"
          "--port ${toString cfg.port}"
          "--max-connections ${toString cfg.maxConnections}"
          "--listen-address ${cfg.listenAddress}"
          "--hostname-and-ip-address-for-protocol-3 ${cfg.hostnameAndIpAddressForProtocol3}"
          "--google-timeout-milliseconds ${
            toString cfg.googleTimeoutMilliseconds
          }"
          (if cfg.googleCacheFilename != null then
            "--google-cache-filename ${cfg.googleCacheFilename}"
          else
            "")
          "--google-cache-entries ${toString cfg.googleCacheEntries}"
          "--google-cache-expire-seconds ${
            toString cfg.googleCacheExpireSeconds
          }"
          "--google-max-candidates-length ${
            toString cfg.googleMaxCandidatesLength
          }"
          "--max-server-completions ${toString cfg.maxServerCompletions}"
          "--google-japanese-input ${cfg.googleJapaneseInput}"
          (if cfg.googleSuggest then "--google-suggest" else "")
          (if cfg.googleUseHttp then "--google-use-http" else "")
          (if cfg.midashiUtf8 then "--midashi-utf8" else "")
        ];
      };
    };
  };
}
