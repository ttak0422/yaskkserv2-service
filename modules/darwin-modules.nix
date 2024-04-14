self:
{ config, lib, pkgs, ... }:
let
  inherit (lib) concatStringsSep;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) yaskkserv2;
  cfg = config.services.yaskkserv2;
in {
  options = import ./options.nix { inherit lib pkgs yaskkserv2; };
  config = lib.mkIf cfg.enable {
    launchd.user.agents.yaskkserv2 = {
      script = concatStringsSep " " [
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
        "--google-cache-expire-seconds ${toString cfg.googleCacheExpireSeconds}"
        "--google-max-candidates-length ${
          toString cfg.googleMaxCandidatesLength
        }"
        "--max-server-completions ${toString cfg.maxServerCompletions}"
        "--google-japanese-input ${cfg.googleJapaneseInput}"
        (if cfg.googleSuggest then "--google-suggest" else "")
        (if cfg.googleUseHttp then "--google-use-http" else "")
        (if cfg.midashiUtf8 then "--midashi-utf8" else "")
      ];
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
