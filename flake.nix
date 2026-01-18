{
  description = "yaskkserv2 service for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    yaskkserv2-src = {
      url = "github:wachikun/yaskkserv2";
      flake = false;
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane.url = "github:ipetkov/crane";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      perSystem = { system, pkgs, ... }:
        let
          inherit (pkgs.lib) optionals;
          inherit (pkgs.stdenv) isLinux isDarwin;
          toolchain = pkgs.fenix.stable.defaultToolchain;
          craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;
          yaskkserv2 = with craneLib; rec {
            commonArgs = {
              src = cleanCargoSource inputs.yaskkserv2-src;
              # skip test
              checkPhaseCargoCommand = "";
              buildInputs = with pkgs;
                [ pkg-config libiconv ]
                ++ (optionals isLinux (with pkgs; [ openssl.dev ]))
                ++ (optionals isDarwin (with pkgs; [ apple-sdk ]));
            };
            artifacts = buildDepsOnly (commonArgs // { pname = "yaskkserv2"; });
            package =
              buildPackage (commonArgs // { cargoArtifacts = artifacts; });
          };
        in {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.fenix.overlays.default ];
          };
          packages.yaskkserv2 = yaskkserv2.package;
          apps = {
            yaskkserv2 = {
              type = "app";
              program = "${yaskkserv2.package}/bin/yaskkserv2";
            };
            makeDirectory = {
              type = "app";
              program = "${yaskkserv2.package}/bin/yaskkserv2_make_dictionary";
            };
          };
        };
    }) // {
      darwinModules.default = import ./modules/darwin-modules.nix self;
      nixosModules.default = import ./modules/nixos-modules.nix self;
    };
}
